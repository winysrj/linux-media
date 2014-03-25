Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40661 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaCYSUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 14:20:32 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so784789eei.0
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 11:20:30 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 02/11] libdvbv5: fix asprintf compile warnings
Date: Tue, 25 Mar 2014 19:19:52 +0100
Message-Id: <1395771601-3509-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- allow logging in dvb_vchannel
- get rid of compile warings about unused asprintf return value

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-demux.c |  8 ++++++--
 lib/libdvbv5/dvb-fe.c    |  8 ++++++--
 lib/libdvbv5/dvb-file.c  | 31 +++++++++++++++++++++----------
 utils/dvb/dvbv5-zap.c    | 17 +++++++++++++----
 4 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index cfd075f..91636f5 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -43,9 +43,13 @@
 int dvb_dmx_open(int adapter, int demux)
 {
 	char* demux_name = NULL;
+	int fd_demux;
+	int r;
 
-	asprintf(&demux_name, "/dev/dvb/adapter%i/demux%i", adapter, demux );
-	int fd_demux = open( demux_name, O_RDWR | O_NONBLOCK );
+	r = asprintf(&demux_name, "/dev/dvb/adapter%i/demux%i", adapter, demux );
+	if (r < 0)
+		return -1;
+	fd_demux = open( demux_name, O_RDWR | O_NONBLOCK );
 	free(demux_name);
 	return fd_demux;
 }
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 28e6354..4975ff9 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -52,12 +52,16 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose,
 				    unsigned use_legacy_call, dvb_logfunc logfunc)
 {
-	int fd, i;
+	int fd, i, r;
 	char *fname;
 	struct dtv_properties dtv_prop;
 	struct dvb_v5_fe_parms *parms = NULL;
 
-	asprintf(&fname, "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
+	r = asprintf(&fname, "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
+	if (r < 0) {
+		logfunc(LOG_ERR, "asprintf error");
+		return NULL;
+	}
 	if (!fname) {
 		logfunc(LOG_ERR, "fname calloc: %s", strerror(errno));
 		return NULL;
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index e0cef34..3e0394e 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -807,7 +807,7 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 	return 0;
 };
 
-static char *dvb_vchannel(struct dvb_table_nit *nit, uint16_t service_id)
+static char *dvb_vchannel(struct dvb_v5_fe_parms *parms, struct dvb_table_nit *nit, uint16_t service_id)
 {
 	int i;
 	char *buf;
@@ -817,17 +817,18 @@ static char *dvb_vchannel(struct dvb_table_nit *nit, uint16_t service_id)
 
 for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *) nit->descriptor; desc; desc = (struct dvb_desc_logical_channel *) desc->next ) \
 		if(desc->type == logical_channel_number_descriptor) {
-//	dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) {
+/* FIXME:  dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) ? */
 		struct dvb_desc_logical_channel *d = (void *)desc;
-
 		size_t len;
+		int r;
 
 		len = d->length / sizeof(d->lcn);
-
 		for (i = 0; i < len; i++) {
 			if (service_id == d->lcn[i].service_id) {
-				asprintf(&buf, "%d.%d",
+				r = asprintf(&buf, "%d.%d",
 					d->lcn[i].logical_channel_number, i);
+				if (r < 0)
+					dvb_perror("asprintf");
 				return buf;
 			}
 		}
@@ -836,13 +837,16 @@ for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *)
 	dvb_desc_find(struct dvb_desc_ts_info, desc, nit, TS_Information_descriptior) {
 		const struct dvb_desc_ts_info *d = (const void *) desc;
 		const struct dvb_desc_ts_info_transmission_type *t;
+		int r;
 
 		t = &d->transmission_type;
 
 		for (i = 0; i < t->num_of_service; i++) {
 			if (d->service_id[i] == service_id) {
-				asprintf(&buf, "%d.%d",
+				r = asprintf(&buf, "%d.%d",
 					d->remote_control_key_id, i);
+				if (r < 0)
+					dvb_perror("asprintf");
 				return buf;
 			}
 		}
@@ -1062,13 +1066,16 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 		atsc_vct_channel_foreach(d, dvb_scan_handler->vct) {
 			char *channel = NULL;
 			char *vchannel = NULL;
+			int r;
 
 			channel = calloc(1, strlen(d->short_name) + 1);
 			strcpy(channel, d->short_name);
 
-			asprintf(&vchannel, "%d.%d",
+			r = asprintf(&vchannel, "%d.%d",
 				d->major_channel_number,
 				d->minor_channel_number);
+			if (r < 0)
+				dvb_perror("asprintf");
 
 			if (parms->verbose)
 				dvb_log("Virtual channel %s, name = %s",
@@ -1095,6 +1102,7 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 	dvb_sdt_service_foreach(service, dvb_scan_handler->sdt) {
 		char *channel = NULL;
 		char *vchannel = NULL;
+		int r;
 
 		dvb_desc_find(struct dvb_desc_service, desc, service, service_descriptor) {
 			if (desc->name) {
@@ -1107,12 +1115,15 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 			break;
 		}
 
-		if (!channel)
-			asprintf(&channel, "#%d", service->service_id);
+		if (!channel) {
+			r = asprintf(&channel, "#%d", service->service_id);
+			if (r < 0)
+				dvb_perror("asprintf");
+		}
 
 		if (parms->verbose)
 			dvb_log("Storing as channel %s", channel);
-		vchannel = dvb_vchannel(dvb_scan_handler->nit, service->service_id);
+		vchannel = dvb_vchannel(parms, dvb_scan_handler->nit, service->service_id);
 
 		rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
 					   service->service_id,
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 5c3b74c..d4a4b98 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -692,6 +692,7 @@ int main(int argc, char **argv)
 	int audio_fd = -1, video_fd = -1;
 	int dvr_fd = -1, file_fd = -1;
 	int err = -1;
+	int r;
 	struct dvb_v5_fe_parms *parms = NULL;
 	const struct argp argp = {
 		.options = options,
@@ -732,11 +733,19 @@ int main(int argc, char **argv)
 		}
 	}
 
-	asprintf(&args.demux_dev,
+	r = asprintf(&args.demux_dev,
 		 "/dev/dvb/adapter%i/demux%i", args.adapter, args.demux);
+	if (r < 0) {
+		fprintf(stderr, "asprintf error\n");
+		return -1;
+	}
 
-	asprintf(&args.dvr_dev,
+	r = asprintf(&args.dvr_dev,
 		 "/dev/dvb/adapter%i/dvr%i", args.adapter, args.demux);
+	if (r < 0) {
+		fprintf(stderr, "asprintf error\n");
+		return -1;
+	}
 
 	if (args.silent < 2)
 		fprintf(stderr, "using demux '%s'\n", args.demux_dev);
@@ -744,11 +753,11 @@ int main(int argc, char **argv)
 	if (!args.confname) {
 		if (!homedir)
 			ERROR("$HOME not set");
-		asprintf(&args.confname, "%s/.tzap/%i/%s",
+		r = asprintf(&args.confname, "%s/.tzap/%i/%s",
 			 homedir, args.adapter, CHANNEL_FILE);
 		if (access(args.confname, R_OK)) {
 			free(args.confname);
-			asprintf(&args.confname, "%s/.tzap/%s",
+			r = asprintf(&args.confname, "%s/.tzap/%s",
 				homedir, CHANNEL_FILE);
 		}
 	}
-- 
1.8.3.2

