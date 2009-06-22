Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f196.google.com ([209.85.210.196]:57210 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZFVXnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 19:43:41 -0400
Received: by yxe34 with SMTP id 34so100041yxe.33
        for <linux-media@vger.kernel.org>; Mon, 22 Jun 2009 16:43:43 -0700 (PDT)
Subject: Re: [Patch] New utility program atsc_epg added to dvb-apps utility
 suite.
From: Yufei Yuan <yfyuan@gmail.com>
Reply-To: yfyuan@gmail.com
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1a297b360906200030y1322de83j296ced63e713ef66@mail.gmail.com>
References: <ccdf9f470906171618r26518ce7pa97d747e301009ca@mail.gmail.com>
	 <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
	 <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
	 <ccdf9f470906180606w1046ee88nda933b4e6638357a@mail.gmail.com>
	 <ccdf9f470906181752u65c8d7f1nce46e3d46991b70c@mail.gmail.com>
	 <ccdf9f470906181839h4047acc1t1d537300a0b4b581@mail.gmail.com>
	 <ccdf9f470906181855m2d6c471cm12afea3f228fd57c@mail.gmail.com>
	 <1a297b360906200030y1322de83j296ced63e713ef66@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 18:43:40 -0500
Message-Id: <1245714220.14686.16.camel@core2duo.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I sent out a new patch yesterday under a different subject line, but it 
looks like it did not make through it. Is this list a moderated one?
 
Anyway, please ignore yesterday's patch if you have not had a chance to 
look at it. Please use this following patch, which is against 1283. It 
contains: 

1. atsc_epg bug fix: when ETM message gets longer than 256 characters, 
the last character was chopped, due to incorrect calling to snprintf(). 
2. atsc_epg code cleanup:
  - error report function re-factored.
  - white space added after keywords;
  - hard wrap around column 80 removed;
  - one-line conditional statement now w/o brackets.
3. scan Makefile workaround for building in gcc4.4/kernel 2.6.30 was not 
picked up yet, include again.

Regards,

Signed-off-by: Yufei Yuan <yfyuan@gmail.com>

diff -upr dvb-apps/util/atsc_epg/atsc_epg.c dvb-apps_local/util/atsc_epg/atsc_epg.c
--- dvb-apps/util/atsc_epg/atsc_epg.c	2009-06-22 12:13:04.136925772 -0500
+++ dvb-apps_local/util/atsc_epg/atsc_epg.c	2009-06-22 13:17:15.287986505 -0500
@@ -20,6 +20,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdarg.h>
 #include <unistd.h>
 #include <string.h>
 #include <time.h>
@@ -46,6 +47,18 @@
 #define MAX_NUM_CHANNELS		16
 #define MAX_NUM_EVENTS_PER_CHANNEL	(4 * 24 * 7)
 
+static inline void print_error(const char *s, const char *f, ...)
+{
+	va_list ap;
+
+	va_start(ap, f);
+	fprintf(stderr, "%s(): ", s);
+	vfprintf(stderr, f, ap);
+	fprintf(stderr, "\n");
+}
+
+#define error_msg(format, ...) print_error(__FUNCTION__, format, ## __VA_ARGS__)
+
 static int atsc_scan_table(int dmxfd, uint16_t pid, enum atsc_section_tag tag,
 	void **table_section);
 
@@ -168,9 +181,8 @@ void *(*table_callback[16])(struct atsc_
 
 static void int_handler(int sig_num)
 {
-	if(SIGINT != sig_num) {
+	if (SIGINT != sig_num)
 		return;
-	}
 	ctrl_c = 1;
 }
 
@@ -219,8 +231,9 @@ static void help(void)
 
 static int close_frontend(struct dvbfe_handle *fe)
 {
-	if(NULL == fe) {
-		fprintf(stderr, "%s(): NULL pointer detected\n", __FUNCTION__);
+	if (NULL == fe) {
+		error_msg("NULL pointer detected");
+		return -1;
 	}
 
 	dvbfe_close(fe);
@@ -232,24 +245,21 @@ static int open_frontend(struct dvbfe_ha
 {
 	struct dvbfe_info fe_info;
 
-	if(NULL == (*fe = dvbfe_open(adapter, 0, 0))) {
-		fprintf(stderr, "%s(): error calling dvbfe_open()\n",
-			__FUNCTION__);
+	if (NULL == (*fe = dvbfe_open(adapter, 0, 0))) {
+		error_msg("error calling dvbfe_open()");
 		return -1;
 	}
 	dvbfe_get_info(*fe, 0, &fe_info, DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0);
-	if(DVBFE_TYPE_ATSC != fe_info.type) {
-		fprintf(stderr, "%s(): only ATSC frontend supported currently\n",
-			__FUNCTION__);
+	if (DVBFE_TYPE_ATSC != fe_info.type) {
+		error_msg("only ATSC frontend supported currently");
 		return -1;
 	}
 	fe_info.feparams.frequency = frequency;
 	fe_info.feparams.inversion = DVBFE_INVERSION_AUTO;
 	fe_info.feparams.u.atsc.modulation = DVBFE_ATSC_MOD_VSB_8;
 	fprintf(stdout, "tuning to %d Hz, please wait...\n", frequency);
-	if(dvbfe_set(*fe, &fe_info.feparams, TIMEOUT * 1000)) {
-		fprintf(stderr, "%s(): cannot lock to %d Hz in %d seconds\n",
-			__FUNCTION__, frequency, TIMEOUT);
+	if (dvbfe_set(*fe, &fe_info.feparams, TIMEOUT * 1000)) {
+		error_msg("cannot lock to %d Hz in %d seconds", frequency, TIMEOUT);
 		return -1;
 	}
 	fprintf(stdout, "tuner locked.\n");
@@ -257,7 +267,7 @@ static int open_frontend(struct dvbfe_ha
 	return 0;
 }
 
-#if ENABLE_RRT
+#ifdef ENABLE_RRT
 /* this is untested as since this part of the library is broken */
 static int parse_rrt(int dmxfd)
 {
@@ -270,20 +280,18 @@ static int parse_rrt(int dmxfd)
 	i = 0;
 	fprintf(stdout, "waiting for RRT: ");
 	fflush(stdout);
-	while(i < RRT_TIMEOUT) {
+	while (i < RRT_TIMEOUT) {
 		ret = atsc_scan_table(dmxfd, ATSC_BASE_PID, tag, (void **)&rrt);
-		if(0 > ret) {
-			fprintf(stderr, "%s(): error calling atsc_scan_table()\n",
-				__FUNCTION__);
+		if (0 > ret) {
+			error_msg("error calling atsc_scan_table()");
 			return -1;
 		}
-		if(0 == ret) {
-			if(RRT_TIMEOUT > i) {
+		if (0 == ret) {
+			if (RRT_TIMEOUT > i) {
 				fprintf(stdout, ".");
 				fflush(stdout);
 			} else {
-				fprintf(stdout, "\nno RRT in %d seconds\n",
-					RRT_TIMEOUT);
+				fprintf(stdout, "\nno RRT in %d seconds\n", RRT_TIMEOUT);
 				return 0;
 			}
 			i += TIMEOUT;
@@ -301,14 +309,13 @@ static int parse_rrt(int dmxfd)
 		atsc_text_string_segments_for_each(atsc_str, seg, j) {
 			const char *c;
 			int k;
-			if(seg->mode < 0x3E) {
-				fprintf(stderr, "%s(): text mode of 0x%02X "
-					"not supported yet\n",
-					__FUNCTION__, seg->mode);
+
+			if (seg->mode < 0x3E) {
+				error_msg("text mode of 0x%02X not supported yet", seg->mode);
 				return -1;
 			}
 			c = (const char *)atsc_text_string_segment_bytes(seg);
-			for(k = 0; k < seg->number_bytes; k++) {
+			for (k = 0; k < seg->number_bytes; k++) {
 				fprintf(stdout, "%c", c[k]);
 			}
 		}
@@ -327,12 +334,11 @@ static int parse_stt(int dmxfd)
 	int ret;
 
 	ret = atsc_scan_table(dmxfd, ATSC_BASE_PID, tag, (void **)&stt);
-	if(0 > ret) {
-		fprintf(stderr, "%s(): error calling atsc_scan_table()\n",
-			__FUNCTION__);
+	if (0 > ret) {
+		error_msg("error calling atsc_scan_table()");
 		return -1;
 	}
-	if(0 == ret) {
+	if (0 == ret) {
 		fprintf(stdout, "no STT in %d seconds\n", TIMEOUT);
 		return 0;
 	}
@@ -360,99 +366,86 @@ static int parse_tvct(int dmxfd)
 
 	do {
 		ret = atsc_scan_table(dmxfd, ATSC_BASE_PID, tag, (void **)&tvct);
-		if(0 > ret) {
-			fprintf(stderr, "%s(): error calling atsc_scan_table()\n",
-			__FUNCTION__);
+		if (0 > ret) {
+			error_msg("error calling atsc_scan_table()");
 			return -1;
 		}
-		if(0 == ret) {
+		if (0 == ret) {
 			fprintf(stdout, "no TVCT in %d seconds\n", TIMEOUT);
 			return 0;
 		}
 
-		if(-1 == num_sections) {
+		if (-1 == num_sections) {
 			num_sections = 1 + tvct->head.ext_head.last_section_number;
-			if(32 < num_sections) {
-				fprintf(stderr, "%s(): no support yet for "
-					"tables having more than 32 sections\n",
-					__FUNCTION__);
+			if (32 < num_sections) {
+				error_msg("no support yet for tables having more than 32 sections");
 				return -1;
 			}
 		} else {
-			if(num_sections !=
+			if (num_sections !=
 				1 + tvct->head.ext_head.last_section_number) {
-				fprintf(stderr,
-					"%s(): last section number does not match\n",
-					__FUNCTION__);
+				error_msg("last section number does not match");
 				return -1;
 			}
 		}
-		if(section_pattern & (1 << tvct->head.ext_head.section_number)) {
+		if (section_pattern & (1 << tvct->head.ext_head.section_number))
 			continue;
-		}
+
 		section_pattern |= 1 << tvct->head.ext_head.section_number;
 
-		if(MAX_NUM_CHANNELS < guide.num_channels +
+		if (MAX_NUM_CHANNELS < guide.num_channels +
 			tvct->num_channels_in_section) {
-			fprintf(stderr, "%s(): no support for more than %d "
-				"virtual channels in a pyhsical channel\n",
-				__FUNCTION__, MAX_NUM_CHANNELS);
+			error_msg("no support for more than %d virtual channels in a pyhsical channel", MAX_NUM_CHANNELS);
 			return -1;
 		}
 		curr_info = &guide.ch[guide.num_channels];
 		guide.num_channels += tvct->num_channels_in_section;
 
-	atsc_tvct_section_channels_for_each(tvct, ch, i) {
-		/* initialize the curr_info structure */
-		/* each EIT covers 3 hours */
-		curr_info->num_eits = (period / 3) + !!(period % 3);
-		while (curr_info->num_eits &&
-			(0xFFFF == guide.eit_pid[curr_info->num_eits - 1])) {
-			curr_info->num_eits -= 1;
-		}
-		if(curr_info->eit) {
-			fprintf(stderr, "%s(): non-NULL pointer detected "
-				"during initialization", __FUNCTION__);
-			return -1;
-		}
-		if(NULL == (curr_info->eit = calloc(curr_info->num_eits,
-			sizeof(struct atsc_eit_info)))) {
-			fprintf(stderr, "%s(): error calling calloc()\n",
-				__FUNCTION__);
-			return -1;
-		}
-		if(NULL == (curr_info->title_buf.string = calloc(TITLE_BUFFER_LEN,
-			sizeof(char)))) {
-			fprintf(stderr, "%s(): error calling calloc()\n",
-				__FUNCTION__);
-			return -1;
-		}
-		curr_info->title_buf.buf_len = TITLE_BUFFER_LEN;
-		curr_info->title_buf.buf_pos = 0;
+		atsc_tvct_section_channels_for_each(tvct, ch, i) {
+			/* initialize the curr_info structure */
+			/* each EIT covers 3 hours */
+			curr_info->num_eits = (period / 3) + !!(period % 3);
+			while (curr_info->num_eits &&
+				(0xFFFF == guide.eit_pid[curr_info->num_eits - 1])) {
+				curr_info->num_eits -= 1;
+			}
+			if (curr_info->eit) {
+				error_msg("non-NULL pointer detected during initialization");
+				return -1;
+			}
+			curr_info->eit = calloc(curr_info->num_eits, sizeof(struct atsc_eit_info));
+			if (NULL == curr_info->eit) {
+				error_msg("error calling calloc()");
+				return -1;
+			}
+			curr_info->title_buf.string = calloc(TITLE_BUFFER_LEN, sizeof(char));
+			if (NULL == curr_info->title_buf.string) {
+				error_msg("error calling calloc()");
+				return -1;
+			}
+			curr_info->title_buf.buf_len = TITLE_BUFFER_LEN;
+			curr_info->title_buf.buf_pos = 0;
 
-		if(NULL == (curr_info->msg_buf.string = calloc(MESSAGE_BUFFER_LEN,
-			sizeof(char)))) {
-			fprintf(stderr, "%s(): error calling calloc()\n",
-				__FUNCTION__);
-			return -1;
-		}
-		curr_info->msg_buf.buf_len = MESSAGE_BUFFER_LEN;
-		curr_info->msg_buf.buf_pos = 0;
+			curr_info->msg_buf.string = calloc(MESSAGE_BUFFER_LEN, sizeof(char));
+			if (NULL == curr_info->msg_buf.string) {
+				error_msg("error calling calloc()");
+				return -1;
+			}
+			curr_info->msg_buf.buf_len = MESSAGE_BUFFER_LEN;
+			curr_info->msg_buf.buf_pos = 0;
 
-		for(k = 0; k < 7; k++) {
-			curr_info->short_name[k] =
-				get_bits((const uint8_t *)ch->short_name,
-				k * 16, 16);
-		}
-		curr_info->service_type = ch->service_type;
-		curr_info->major_num = ch->major_channel_number;
-		curr_info->minor_num = ch->minor_channel_number;
-		curr_info->tsid = ch->channel_TSID;
-		curr_info->prog_num = ch->program_number;
-		curr_info->src_id = ch->source_id;
-		curr_info++;
+			for (k = 0; k < 7; k++)
+				curr_info->short_name[k] =
+					get_bits((const uint8_t *)ch->short_name, k * 16, 16);
+			curr_info->service_type = ch->service_type;
+			curr_info->major_num = ch->major_channel_number;
+			curr_info->minor_num = ch->minor_channel_number;
+			curr_info->tsid = ch->channel_TSID;
+			curr_info->prog_num = ch->program_number;
+			curr_info->src_id = ch->source_id;
+			curr_info++;
 		}
-	} while(section_pattern != (uint32_t)((1 << num_sections) - 1));
+	} while (section_pattern != (uint32_t)((1 << num_sections) - 1));
 
 	return 0;
 }
@@ -463,22 +456,21 @@ static int match_event(struct atsc_eit_i
 	int j, k;
 	struct atsc_eit_section_info *section;
 
-	if(NULL == eit || NULL == event || NULL == curr_index) {
-		fprintf(stderr, "%s(): NULL pointer detected\n", __FUNCTION__);
+	if (NULL == eit || NULL == event || NULL == curr_index) {
+		error_msg("NULL pointer detected");
 		return -1;
 	}
 
-	for(j = 0; j < eit->num_eit_sections; j++) {
+	for (j = 0; j < eit->num_eit_sections; j++) {
 		section = &eit->section[j];
 
-		for(k = 0; k < section->num_events; k++) {
-			if(section->events[k] && section->events[k]->id ==
-				event_id) {
+		for (k = 0; k < section->num_events; k++) {
+			if (section->events[k] && section->events[k]->id == event_id) {
 				*event = section->events[k];
 				break;
 			}
 		}
-		if(*event) {
+		if (*event) {
 			*curr_index = j;
 			break;
 		}
@@ -494,8 +486,8 @@ static int parse_message(struct atsc_cha
 	struct atsc_text *text;
 	struct atsc_text_string *str;
 
-	if(NULL == ett || NULL == event || NULL == channel) {
-		fprintf(stderr, "%s(): NULL pointer detected\n", __FUNCTION__);
+	if (NULL == ett || NULL == event || NULL == channel) {
+		error_msg("NULL pointer detected");
 		return -1;
 	}
 
@@ -505,17 +497,11 @@ static int parse_message(struct atsc_cha
 
 		atsc_text_string_segments_for_each(str, seg, j) {
 			event->msg_pos = channel->msg_buf.buf_pos;
-			if(0 > atsc_text_segment_decode(seg,
-				(uint8_t **)&channel->msg_buf.string,
-				(size_t *)&channel->msg_buf.buf_len,
-				(size_t *)&channel->msg_buf.buf_pos)) {
-				fprintf(stderr, "%s(): error calling "
-					"atsc_text_segment_decode()\n",
-					__FUNCTION__);
+			if (0 > atsc_text_segment_decode(seg, (uint8_t **)&channel->msg_buf.string, (size_t *)&channel->msg_buf.buf_len, (size_t *)&channel->msg_buf.buf_pos)) {
+				error_msg("error calling atsc_text_segment_decode()");
 				return -1;
 			}
-			event->msg_len = 1 + channel->msg_buf.buf_pos -
-				event->msg_pos;
+			event->msg_len = channel->msg_buf.buf_pos - event->msg_pos;
 		}
 	}
 
@@ -535,69 +521,58 @@ static int parse_ett(int dmxfd, int inde
 	uint16_t source_id, event_id;
 	int c, ret;
 
-	if(0xFFFF == guide.ett_pid[index]) {
+	if (0xFFFF == guide.ett_pid[index])
 		return 0;
-	}
 
-	for(c = 0; c < guide.num_channels; c++) {
+	for (c = 0; c < guide.num_channels; c++) {
 		channel = &guide.ch[c];
 		eit = &channel->eit[index];
 
 		section_pattern = 0;
-		while(section_pattern !=
-			(uint32_t)((1 << eit->num_eit_sections) - 1)) {
-			if(ctrl_c) {
+		while (section_pattern != (uint32_t)((1 << eit->num_eit_sections) - 1)) {
+			if (ctrl_c)
 				return 0;
-			}
+
 			ret = atsc_scan_table(dmxfd, pid, tag, (void **)&ett);
 			fprintf(stdout, ".");
 			fflush(stdout);
-			if(0 > ret) {
-				fprintf(stderr, "%s(): error calling "
-					"atsc_scan_table()\n", __FUNCTION__);
+			if (0 > ret) {
+				error_msg("error calling atsc_scan_table()");
 				return -1;
 			}
-			if(0 == ret) {
-				fprintf(stdout, "no ETT %d in %d seconds\n",
-					index, TIMEOUT);
+			if (0 == ret) {
+				fprintf(stdout, "no ETT %d in %d seconds\n", index, TIMEOUT);
 				return 0;
 			}
 
 			source_id = ett->ETM_source_id;
 			event_id = ett->ETM_sub_id;
-			if(source_id != channel->src_id) {
+			if (source_id != channel->src_id)
 				continue;
-			}
 
 			event = NULL;
-			if(match_event(eit, event_id, &event, &curr_index)) {
-				fprintf(stderr, "%s(): error calling "
-					"match_event()\n", __FUNCTION__);
+			if (match_event(eit, event_id, &event, &curr_index)) {
+				error_msg("error calling match_event()");
 				return -1;
 			}
-			if(NULL == event) {
+			if (NULL == event)
 				continue;
-			}
-			if(section_pattern & (1 << curr_index)) {
-				/* the section has been filled, so skip,
-				 * not consider version yet
-				 */
+
+			/* the section has been filled, so skip, not consider version yet */
+			if (section_pattern & (1 << curr_index))
 				continue;
-			}
-			if(event->msg_len) {
-				/* the message has been filled */
+
+			/* the message has been filled */
+			if (event->msg_len)
 				continue;
-			}
 
-			if(parse_message(channel, ett, event)) {
-				fprintf(stderr, "%s(): error calling "
-					"parse_message()\n", __FUNCTION__);
+			if (parse_message(channel, ett, event)) {
+				error_msg("error calling parse_message()");
 				return -1;
 			}
 			section = &eit->section[curr_index];
-			if(++section->num_received_etms == section->num_etms) {
+			if (++section->num_received_etms == section->num_etms)
 				section_pattern |= 1 << curr_index;
-			}
 		}
 	}
 
@@ -611,23 +586,20 @@ static int parse_events(struct atsc_chan
 	struct atsc_eit_event *e;
 	time_t start_time, end_time;
 
-	if(NULL == curr_info || NULL == eit) {
-		fprintf(stderr, "%s(): NULL pointer detected\n", __FUNCTION__);
+	if (NULL == curr_info || NULL == eit) {
+		error_msg("NULL pointer detected");
 		return -1;
 	}
 
 	atsc_eit_section_events_for_each(eit, e, i) {
 		struct atsc_text *title;
 		struct atsc_text_string *str;
-		struct atsc_event_info *e_info =
-			&curr_info->e[curr_info->event_info_index];
+		struct atsc_event_info *e_info = &curr_info->e[curr_info->event_info_index];
 
-		if(0 == i && curr_info->last_event) {
-			if(e->event_id == curr_info->last_event->id) {
+		if (0 == i && curr_info->last_event) {
+			if (e->event_id == curr_info->last_event->id) {
 				section->events[i] = NULL;
-				/* skip if it's the same event spanning
-				 * over sections
-				 */
+				/* skip if it's the same event spanning over sections */
 				continue;
 			}
 		}
@@ -638,10 +610,9 @@ static int parse_events(struct atsc_chan
 		end_time = start_time + e->length_in_seconds;
 		localtime_r(&start_time, &e_info->start);
 		localtime_r(&end_time, &e_info->end);
-		if(0 != e->ETM_location && 3 != e->ETM_location) {
-			/* FIXME assume 1 and 2 is interchangable as of now */
+		/* FIXME assume 1 and 2 is interchangable as of now */
+		if (0 != e->ETM_location && 3 != e->ETM_location)
 			section->num_etms++;
-		}
 
 		title = atsc_eit_event_name_title_text(e);
 		atsc_text_strings_for_each(title, str, j) {
@@ -649,17 +620,11 @@ static int parse_events(struct atsc_chan
 
 			atsc_text_string_segments_for_each(str, seg, k) {
 				e_info->title_pos = curr_info->title_buf.buf_pos;
-				if(0 > atsc_text_segment_decode(seg,
-					(uint8_t **)&curr_info->title_buf.string,
-					(size_t *)&curr_info->title_buf.buf_len,
-					(size_t *)&curr_info->title_buf.buf_pos)) {
-					fprintf(stderr, "%s(): error calling "
-						"atsc_text_segment_decode()\n",
-						__FUNCTION__);
+				if (0 > atsc_text_segment_decode(seg, (uint8_t **)&curr_info->title_buf.string, (size_t *)&curr_info->title_buf.buf_len, (size_t *)&curr_info->title_buf.buf_pos)) {
+					error_msg("error calling atsc_text_segment_decode()");
 					return -1;
 				}
-				e_info->title_len = curr_info->title_buf.buf_pos -
-					e_info->title_pos + 1;
+				e_info->title_len = curr_info->title_buf.buf_pos - e_info->title_pos;
 			}
 		}
 	}
@@ -682,8 +647,7 @@ static int parse_eit(int dmxfd, int inde
 	uint32_t eit_instance_pattern = 0;
 	int i, k, ret;
 
-	while(eit_instance_pattern !=
-		(uint32_t)((1 << guide.num_channels) - 1)) {
+	while (eit_instance_pattern != (uint32_t)((1 << guide.num_channels) - 1)) {
 		source_id = 0xFFFF;
 		section_pattern = 0;
 		num_sections = -1;
@@ -692,102 +656,71 @@ static int parse_eit(int dmxfd, int inde
 			ret = atsc_scan_table(dmxfd, pid, tag, (void **)&eit);
 			fprintf(stdout, ".");
 			fflush(stdout);
-			if(0 > ret) {
-				fprintf(stderr, "%s(): error calling "
-					"atsc_scan_table()\n", __FUNCTION__);
+			if (0 > ret) {
+				error_msg("error calling atsc_scan_table()");
 				return -1;
 			}
-			if(0 == ret) {
-				fprintf(stdout, "no EIT %d in %d seconds\n",
-					index, TIMEOUT);
+			if (0 == ret) {
+				fprintf(stdout, "no EIT %d in %d seconds\n", index, TIMEOUT);
 				return 0;
 			}
 
-			if(0xFFFF == source_id) {
+			if (0xFFFF == source_id) {
 			source_id = atsc_eit_section_source_id(eit);
-			for(k = 0; k < guide.num_channels; k++) {
-				if(source_id == guide.ch[k].src_id) {
+			for (k = 0; k < guide.num_channels; k++) {
+				if (source_id == guide.ch[k].src_id) {
 					curr_info = &guide.ch[k];
 					curr_channel_index = k;
-					if(0 == index) {
+					if (0 == index)
 						curr_info->last_event = NULL;
-					}
 					break;
 				}
 			}
-			if(k == guide.num_channels) {
-				fprintf(stderr, "%s(): cannot find source_id "
-					"0x%04X in the EIT\n",
-					__FUNCTION__, source_id);
+			if (k == guide.num_channels) {
+				error_msg("cannot find source_id 0x%04X in the EIT", source_id);
 				return -1;
 			}
 			} else {
-				if(source_id !=
-					atsc_eit_section_source_id(eit)) {
+				if (source_id != atsc_eit_section_source_id(eit))
 					continue;
-				}
 			}
-			if(eit_instance_pattern & (1 << curr_channel_index)) {
-				/* we have received this instance,
-				 * so quit quick
-				 */
+			/* if we have received this instance, quit quick */
+			if (eit_instance_pattern & (1 << curr_channel_index))
 				break;
-			}
 
-			if(-1 == num_sections) {
-				num_sections = 1 +
-					eit->head.ext_head.last_section_number;
-				if(32 < num_sections) {
-					fprintf(stderr,
-						"%s(): no support yet for "
-						"tables having more than "
-						"32 sections\n", __FUNCTION__);
+			if (-1 == num_sections) {
+				num_sections = 1 + eit->head.ext_head.last_section_number;
+				if (32 < num_sections) {
+					error_msg("no support yet for tables having more than 32 sections");
 					return -1;
 				}
 			} else {
-				if(num_sections != 1 +
-					eit->head.ext_head.last_section_number) {
-					fprintf(stderr,
-						"%s(): last section number "
-						"does not match\n",
-						__FUNCTION__);
+				if (num_sections != 1 + eit->head.ext_head.last_section_number) {
+					error_msg("last section number does not match");
 					return -1;
 				}
 			}
-			if(section_pattern &
-				(1 << eit->head.ext_head.section_number)) {
+			if (section_pattern & (1 << eit->head.ext_head.section_number))
 				continue;
-			}
 			section_pattern |= 1 << eit->head.ext_head.section_number;
 
 			eit_info = &curr_info->eit[index];
-			if(NULL == (eit_info->section =
-				realloc(eit_info->section,
-				(eit_info->num_eit_sections + 1) *
-				sizeof(struct atsc_eit_section_info)))) {
-				fprintf(stderr,
-					"%s(): error calling realloc()\n",
-					__FUNCTION__);
+			eit_info->section = realloc(eit_info->section, (eit_info->num_eit_sections + 1) * sizeof(struct atsc_eit_section_info));
+			if (NULL == eit_info->section) {
+				error_msg("error calling realloc()");
 				return -1;
 			}
 			section_num = eit->head.ext_head.section_number;
-			if(0 == eit_info->num_eit_sections) {
+			if (0 == eit_info->num_eit_sections) {
 				eit_info->num_eit_sections = 1;
 				section = eit_info->section;
 			} else {
-				/* have to sort it into section order
-				 * (temporal order)
-				 */
-				for(i = 0; i < eit_info->num_eit_sections; i++) {
-					if(eit_info->section[i].section_num >
-						section_num) {
+				/* have to sort it into section order (temporal order) */
+				for (i = 0; i < eit_info->num_eit_sections; i++) {
+					if (eit_info->section[i].section_num > section_num)
 						break;
-					}
 				}
-				memmove(&eit_info->section[i + 1],
-					&eit_info->section[i],
-					(eit_info->num_eit_sections - i) *
-					sizeof(struct atsc_eit_section_info));
+				memmove(&eit_info->section[i + 1], &eit_info->section[i], (eit_info->num_eit_sections - i) * sizeof(struct atsc_eit_section_info));
 				section = &eit_info->section[i - 1];
 				section = &eit_info->section[i];
 				eit_info->num_eit_sections += 1;
@@ -797,33 +730,31 @@ static int parse_eit(int dmxfd, int inde
 			section->num_events = eit->num_events_in_section;
 			section->num_etms = 0;
 			section->num_received_etms = 0;
-			if(NULL == (section->events = calloc(section->num_events,
-				sizeof(struct atsc_event_info *)))) {
-				fprintf(stderr, "%s(): error calling calloc()\n",
-					__FUNCTION__);
+			section->events = calloc(section->num_events, sizeof(struct atsc_event_info *));
+			if (NULL == section->events) {
+				error_msg("error calling calloc()");
 				return -1;
 			}
-			if(parse_events(curr_info, eit, section)) {
-				fprintf(stderr, "%s(): error calling "
-					"parse_events()\n", __FUNCTION__);
+			if (parse_events(curr_info, eit, section)) {
+				error_msg("error calling parse_events()");
 				return -1;
 			}
-		} while(section_pattern != (uint32_t)((1 << num_sections) - 1));
+		} while (section_pattern != (uint32_t)((1 << num_sections) - 1));
 		eit_instance_pattern |= 1 << curr_channel_index;
 	}
 
-	for(i = 0; i < guide.num_channels; i++) {
+	for (i = 0; i < guide.num_channels; i++) {
 		struct atsc_channel_info *channel = &guide.ch[i];
 		struct atsc_eit_info *ei = &channel->eit[index];
 		struct atsc_eit_section_info *s;
 
-		if(0 == ei->num_eit_sections) {
+		if (0 == ei->num_eit_sections) {
 			channel->last_event = NULL;
 			continue;
 		}
 		s = &ei->section[ei->num_eit_sections - 1];
 		/* BUG: it's incorrect when last section has no event */
-		if(0 == s->num_events) {
+		if (0 == s->num_events) {
 			channel->last_event = NULL;
 			continue;
 		}
@@ -841,12 +772,11 @@ static int parse_mgt(int dmxfd)
 	int i, j, ret;
 
 	ret = atsc_scan_table(dmxfd, ATSC_BASE_PID, tag, (void **)&mgt);
-	if(0 > ret) {
-		fprintf(stderr, "%s(): error calling atsc_scan_table()\n",
-			__FUNCTION__);
+	if (0 > ret) {
+		error_msg("error calling atsc_scan_table()");
 		return -1;
 	}
-	if(0 == ret) {
+	if (0 == ret) {
 		fprintf(stdout, "no MGT in %d seconds\n", TIMEOUT);
 		return 0;
 	}
@@ -855,31 +785,28 @@ static int parse_mgt(int dmxfd)
 	atsc_mgt_section_tables_for_each(mgt, t, i) {
 		struct mgt_table_name table;
 
-	for(j = 0; j < (int)(sizeof(mgt_tab_name_array) /
-		sizeof(struct mgt_table_name)); j++) {
-		if(t->table_type > mgt_tab_name_array[j].range) {
-			continue;
-		}
-		table = mgt_tab_name_array[j];
-		if(0 == j || mgt_tab_name_array[j - 1].range + 1 ==
-			mgt_tab_name_array[j].range) {
-			j = -1;
-		} else {
-			j = t->table_type - mgt_tab_name_array[j - 1].range - 1;
-			if(0x017F == table.range) {
-				guide.eit_pid[j] = t->table_type_PID;
-			} else if (0x027F == table.range) {
-				guide.ett_pid[j] = t->table_type_PID;
+		for (j = 0; j < (int)(sizeof(mgt_tab_name_array) / sizeof(struct mgt_table_name)); j++) {
+			if (t->table_type > mgt_tab_name_array[j].range)
+				continue;
+			table = mgt_tab_name_array[j];
+			if (0 == j || mgt_tab_name_array[j - 1].range + 1 ==
+				mgt_tab_name_array[j].range) {
+				j = -1;
+			} else {
+				j = t->table_type - mgt_tab_name_array[j - 1].range - 1;
+				if (0x017F == table.range) {
+					guide.eit_pid[j] = t->table_type_PID;
+				} else if (0x027F == table.range) {
+					guide.ett_pid[j] = t->table_type_PID;
+				}
 			}
+			break;
 		}
-		break;
-	}
 
 		fprintf(stdout, "  %2d: type = 0x%04X, PID = 0x%04X, %s", i,
-		    t->table_type, t->table_type_PID, table.string);
-		if(-1 != j) {
-		    fprintf(stdout, " %d", j);
-		}
+			t->table_type, t->table_type_PID, table.string);
+		if (-1 != j)
+			fprintf(stdout, " %d", j);
 		fprintf(stdout, "\n");
 	}
 
@@ -890,32 +817,24 @@ static int cleanup_guide(void)
 {
 	int i, j, k;
 
-	for(i = 0; i < guide.num_channels; i++) {
+	for (i = 0; i < guide.num_channels; i++) {
 		struct atsc_channel_info *channel = &guide.ch[i];
 
-		if(channel->title_buf.string) {
+		if (channel->title_buf.string)
 			free(channel->title_buf.string);
-		}
-		if(channel->msg_buf.string) {
+		if (channel->msg_buf.string)
 			free(channel->msg_buf.string);
-		}
-		for(j = 0; j < channel->num_eits; j++) {
+		for (j = 0; j < channel->num_eits; j++) {
 			struct atsc_eit_info *eit = &channel->eit[j];
 
-			for(k = 0; k < eit->num_eit_sections; k++) {
-				struct atsc_eit_section_info *section =
-					&eit->section[k];
-				if(section->num_events) {
+			for (k = 0; k < eit->num_eit_sections; k++) {
+				struct atsc_eit_section_info *section = &eit->section[k];
+				if (section->num_events)
 					free(section->events);
-				}
-			}
-			if(k) {
-				free(eit->section);
 			}
+			if (k) free(eit->section);
 		}
-		if(j) {
-			free(channel->eit);
-		}
+		if (j) free(channel->eit);
 	}
 
 	return 0;
@@ -927,38 +846,33 @@ static int print_events(struct atsc_chan
 	int m;
 	char line[256];
 
-	if(NULL == section) {
-		fprintf(stderr, "%s(): NULL pointer detected", __FUNCTION__);
+	if (NULL == section) {
+		error_msg("NULL pointer detected");
 		return -1;
 	}
-	for(m = 0; m < section->num_events; m++) {
+	for (m = 0; m < section->num_events; m++) {
 		struct atsc_event_info *event =
 			section->events[m];
 
-		if(NULL == event) {
+		if (NULL == event)
 			continue;
-		}
-		fprintf(stdout, "|%02d:%02d--%02d:%02d| ",
-			event->start.tm_hour, event->start.tm_min,
-			event->end.tm_hour, event->end.tm_min);
-		snprintf(line, event->title_len, "%s",
-			&channel->title_buf.string[event->title_pos]);
-		line[event->title_len] = '\0';
+		fprintf(stdout, "|%02d:%02d--%02d:%02d| ", event->start.tm_hour, event->start.tm_min, event->end.tm_hour, event->end.tm_min);
+		snprintf(line, event->title_len + 1, "%s", &channel->title_buf.string[event->title_pos]);
+		/*line[event->title_len] = '\0';*/
 		fprintf(stdout, "%s\n", line);
-		if(event->msg_len) {
+		if (event->msg_len) {
 			int len = event->msg_len;
 			int pos = event->msg_pos;
 			size_t part;
 
 			do {
 				part = len > 255 ? 255 : len;
-				snprintf(line, part, "%s",
-					&channel->msg_buf.string[pos]);
-				line[part] = '\0';
+				snprintf(line, part + 1, "%s", &channel->msg_buf.string[pos]);
+				/*line[part] = '\0';*/
 				fprintf(stdout, "%s", line);
 				len -= part;
 				pos += part;
-			} while(0 < len);
+			} while (0 < len);
 			fprintf(stdout, "\n");
 		}
 	}
@@ -970,20 +884,17 @@ static int print_guide(void)
 	int i, j, k;
 
 	fprintf(stdout, "%s\n", separator);
-	for(i = 0; i < guide.num_channels; i++) {
+	for (i = 0; i < guide.num_channels; i++) {
 		struct atsc_channel_info *channel = &guide.ch[i];
 
-		fprintf(stdout, "%d.%d  %s\n", channel->major_num,
-			channel->minor_num, channel->short_name);
-		for(j = 0; j < channel->num_eits; j++) {
+		fprintf(stdout, "%d.%d  %s\n", channel->major_num, channel->minor_num, channel->short_name);
+		for (j = 0; j < channel->num_eits; j++) {
 			struct atsc_eit_info *eit = &channel->eit[j];
 
-			for(k = 0; k < eit->num_eit_sections; k++) {
-				struct atsc_eit_section_info *section =
-					&eit->section[k];
-				if(print_events(channel, section)) {
-					fprintf(stderr, "%s(): error calling "
-						"print_events()\n", __FUNCTION__);
+			for (k = 0; k < eit->num_eit_sections; k++) {
+				struct atsc_eit_section_info *section = &eit->section[k];
+				if (print_events(channel, section)) {
+					error_msg("error calling print_events()");
 					return -1;
 				}
 			}
@@ -996,9 +907,8 @@ static int print_guide(void)
 
 static int open_demux(int *dmxfd)
 {
-	if((*dmxfd = dvbdemux_open_demux(adapter, 0, 0)) < 0) {
-		fprintf(stderr, "%s(): error calling dvbdemux_open_demux()\n",
-			__FUNCTION__);
+	if ((*dmxfd = dvbdemux_open_demux(adapter, 0, 0)) < 0) {
+		error_msg("error calling dvbdemux_open_demux()");
 		return -1;
 	}
 	return 0;
@@ -1006,9 +916,8 @@ static int open_demux(int *dmxfd)
 
 static int close_demux(int dmxfd)
 {
-	if(dvbdemux_stop(dmxfd)) {
-		fprintf(stderr, "%s(): error calling dvbdemux_stop()\n",
-			__FUNCTION__);
+	if (dvbdemux_stop(dmxfd)) {
+		error_msg("error calling dvbdemux_stop()");
 		return -1;
 	}
 	return 0;
@@ -1033,60 +942,52 @@ static int atsc_scan_table(int dmxfd, ui
 	memset(mask, 0, sizeof(mask));
 	filter[0] = tag;
 	mask[0] = 0xFF;
-	if(dvbdemux_set_section_filter(dmxfd, pid, filter, mask, 1, 1)) {
-		fprintf(stderr, "%s(): error calling atsc_scan_table()\n",
-			__FUNCTION__);
+	if (dvbdemux_set_section_filter(dmxfd, pid, filter, mask, 1, 1)) {
+		error_msg("error calling atsc_scan_table()");
 		return -1;
 	}
 
 	/* poll for data */
 	pollfd.fd = dmxfd;
 	pollfd.events = POLLIN | POLLERR |POLLPRI;
-	if((ret = poll(&pollfd, 1, TIMEOUT * 1000)) < 0) {
-		if(ctrl_c) {
+	if ((ret = poll(&pollfd, 1, TIMEOUT * 1000)) < 0) {
+		if (ctrl_c)
 			return 0;
-		}
-		fprintf(stderr, "%s(): error calling poll()\n", __FUNCTION__);
+		error_msg("error calling poll()");
 		return -1;
 	}
 
-	if(0 == ret) {
+	if (0 == ret)
 		return 0;
-	}
 
 	/* read it */
-	if((size = read(dmxfd, sibuf, sizeof(sibuf))) < 0) {
-		fprintf(stderr, "%s(): error calling read()\n", __FUNCTION__);
+	if ((size = read(dmxfd, sibuf, sizeof(sibuf))) < 0) {
+		error_msg("error calling read()");
 		return -1;
 	}
 
 	/* parse section */
 	section = section_codec(sibuf, size);
-	if(NULL == section) {
-		fprintf(stderr, "%s(): error calling section_codec()\n",
-			__FUNCTION__);
+	if (NULL == section) {
+		error_msg("error calling section_codec()");
 		return -1;
 	}
 
 	section_ext = section_ext_decode(section, 0);
-	if(NULL == section_ext) {
-		fprintf(stderr, "%s(): error calling section_ext_decode()\n",
-			__FUNCTION__);
+	if (NULL == section_ext) {
+		error_msg("error calling section_ext_decode()");
 		return -1;
 	}
 
 	psip = atsc_section_psip_decode(section_ext);
-	if(NULL == psip) {
-		fprintf(stderr,
-			"%s(): error calling atsc_section_psip_decode()\n",
-			__FUNCTION__);
+	if (NULL == psip) {
+		error_msg("error calling atsc_section_psip_decode()");
 		return -1;
 	}
 
 	*table_section = table_callback[tag & 0x0F](psip);
-	if(NULL == *table_section) {
-		fprintf(stderr, "%s(): error decode table section\n",
-			__FUNCTION__);
+	if (NULL == *table_section) {
+		error_msg("error decode table section");
 		return -1;
 	}
 
@@ -1100,17 +1001,16 @@ int main(int argc, char *argv[])
 
 	program = argv[0];
 
-	if(1 == argc) {
+	if (1 == argc) {
 		usage();
 		exit(-1);
 	}
 
-	for( ; ; ) {
+	for ( ; ; ) {
 		char c;
 
-		if(-1 == (c = getopt(argc, argv, "a:f:p:m:th"))) {
+		if (-1 == (c = getopt(argc, argv, "a:f:p:m:th")))
 			break;
-		}
 
 		switch(c) {
 		case 'a':
@@ -1124,9 +1024,8 @@ int main(int argc, char *argv[])
 		case 'p':
 			period = strtol(optarg, NULL, 0);
 			/* each table covers 3 hours */
-			if((3 * MAX_NUM_EVENT_TABLES) < period) {
+			if ((3 * MAX_NUM_EVENT_TABLES) < period)
 				period = 3 * MAX_NUM_EVENT_TABLES;
-			}
 			break;
 
 		case 'm':
@@ -1154,94 +1053,81 @@ int main(int argc, char *argv[])
 	memset(guide.eit_pid, 0xFF, MAX_NUM_EVENT_TABLES * sizeof(uint16_t));
 	memset(guide.ett_pid, 0xFF, MAX_NUM_EVENT_TABLES * sizeof(uint16_t));
 
-	if(open_frontend(&fe)) {
-		fprintf(stderr, "%s(): error calling open_frontend()\n",
-			__FUNCTION__);
+	if (open_frontend(&fe)) {
+		error_msg("error calling open_frontend()");
 		return -1;
 	}
 
-	if(open_demux(&dmxfd)) {
-		fprintf(stderr, "%s(): error calling open_demux()\n",
-			__FUNCTION__);
+	if (open_demux(&dmxfd)) {
+		error_msg("error calling open_demux()");
 		return -1;
 	}
 
-	if(parse_stt(dmxfd)) {
-		fprintf(stderr, "%s(): error calling parse_stt()\n",
-			__FUNCTION__);
+	if (parse_stt(dmxfd)) {
+		error_msg("error calling parse_stt()");
 		return -1;
 	}
 
-	if(parse_mgt(dmxfd)) {
-		fprintf(stderr, "%s(): error calling parse_mgt()\n",
-			__FUNCTION__);
+	if (parse_mgt(dmxfd)) {
+		error_msg("error calling parse_mgt()");
 		return -1;
 	}
 
-	if(parse_tvct(dmxfd)) {
-		fprintf(stderr, "%s(): error calling parse_tvct()\n",
-			__FUNCTION__);
+	if (parse_tvct(dmxfd)) {
+		error_msg("error calling parse_tvct()");
 		return -1;
 	}
 
 #ifdef ENABLE_RRT
-	if(parse_rrt(dmxfd)) {
-		fprintf(stderr, "%s(): error calling parse_rrt()\n",
-			__FUNCTION__);
+	if (parse_rrt(dmxfd)) {
+		error_msg("error calling parse_rrt()");
 		return -1;
 	}
 #endif
 
 	fprintf(stdout, "receiving EIT ");
-	for(i = 0; i < guide.ch[0].num_eits; i++) {
-		if(parse_eit(dmxfd, i, guide.eit_pid[i])) {
-			fprintf(stderr, "%s(): error calling parse_eit()\n",
-				__FUNCTION__);
+	for (i = 0; i < guide.ch[0].num_eits; i++) {
+		if (parse_eit(dmxfd, i, guide.eit_pid[i])) {
+			error_msg("error calling parse_eit()");
 			return -1;
 		}
 	}
 	fprintf(stdout, "\n");
 
 	old_handler = signal(SIGINT, int_handler);
-	if(enable_ett) {
+	if (enable_ett) {
 		fprintf(stdout, "receiving ETT ");
-		for(i = 0; i < guide.ch[0].num_eits; i++) {
-			if(0xFFFF != guide.ett_pid[i]) {
-				if(parse_ett(dmxfd, i, guide.ett_pid[i])) {
-					fprintf(stderr, "%s(): error calling "
-						"parse_eit()\n", __FUNCTION__);
+		for (i = 0; i < guide.ch[0].num_eits; i++) {
+			if (0xFFFF != guide.ett_pid[i]) {
+				if (parse_ett(dmxfd, i, guide.ett_pid[i])) {
+					error_msg("error calling parse_eit()");
 					return -1;
 				}
 			}
-			if(ctrl_c) {
+			if (ctrl_c)
 				break;
-			}
 		}
 		fprintf(stdout, "\n");
 	}
 	signal(SIGINT, old_handler);
 
-	if(print_guide()) {
-		fprintf(stderr, "%s(): error calling print_guide()\n",
-			__FUNCTION__);
+	if (print_guide()) {
+		error_msg("error calling print_guide()");
 		return -1;
 	}
 
-	if(cleanup_guide()) {
-		fprintf(stderr, "%s(): error calling cleanup_guide()\n",
-			__FUNCTION__);
+	if (cleanup_guide()) {
+		error_msg("error calling cleanup_guide()");
 		return -1;
 	}
 
-	if(close_demux(dmxfd)) {
-		fprintf(stderr, "%s(): error calling close_demux()\n",
-			__FUNCTION__);
+	if (close_demux(dmxfd)) {
+		error_msg("error calling close_demux()");
 		return -1;
 	}
 
-	if(close_frontend(fe)) {
-		fprintf(stderr, "%s(): error calling close_demux()\n",
-			__FUNCTION__);
+	if (close_frontend(fe)) {
+		error_msg("error calling close_demux()");
 		return -1;
 	}
 
diff -upr dvb-apps/util/scan/Makefile dvb-apps_local/util/scan/Makefile
--- dvb-apps/util/scan/Makefile	2009-06-22 12:13:04.171925478 -0500
+++ dvb-apps_local/util/scan/Makefile	2009-06-22 12:17:48.000000000 -0500
@@ -14,7 +14,7 @@ inst_bin = $(binaries)
 
 removing = atsc_psip_section.c atsc_psip_section.h
 
-CPPFLAGS += -DDATADIR=\"$(prefix)/share\"
+CPPFLAGS += -Wno-packed-bitfield-compat -D__KERNEL_STRICT_NAMES -DDATADIR=\"$(prefix)/share\"
 
 .PHONY: all
 


