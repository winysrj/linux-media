Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.asp4me.at ([80.240.225.30]:11562 "EHLO samre002.asp4me.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0EDHM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 03:12:28 -0400
Message-ID: <4BDFC550.6040706@beko.at>
Date: Tue, 04 May 2010 08:57:20 +0200
From: Simon Vogl <simon.vogl@beko.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gnutv: change channels quickly with cam suport  
Content-Type: multipart/mixed;
 boundary="------------050505090800010006070509"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050505090800010006070509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,
I extended gnutv a little in order to make it switch channels
quickly: I'v added a command line option (-remote) to make
it read channel names from stdin and change from one channel
to another in a few hundred ms.

Hope you find this useful,
Simon

-- 
DI Dr. Simon Vogl                        | @ simon.vogl@beko.at 
Leiter Technik & Entwicklung             | w www.homebutler.at
Competence Center Smart Home Solutions   | w www.beko.at
BEKO Engineering & Informatik AG         | t +43 664 23 12 482
Gruberstr. 2 - 6, 4020  Linz             | f +43 732 655465 20


--------------050505090800010006070509
Content-Type: text/x-patch;
 name="gnutv_rc+restart.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gnutv_rc+restart.patch"

diff -r 5d49967c2184 util/gnutv/Makefile
--- a/util/gnutv/Makefile	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/Makefile	Mon May 03 14:16:42 2010 +0200
@@ -8,9 +8,9 @@ binaries = gnutv
 
 inst_bin = $(binaries)
 
-CPPFLAGS += -I../../lib
+CPPFLAGS += -I../../lib 
 LDFLAGS  += -L../../lib/libdvbapi -L../../lib/libdvbcfg -L../../lib/libdvbsec -L../../lib/libdvben50221 -L../../lib/libucsi
-LDLIBS   += -ldvbcfg -ldvben50221 -lucsi -ldvbsec -ldvbapi -lpthread
+LDLIBS   += -ldvbcfg -ldvben50221 -lucsi -ldvbsec -ldvbapi -lpthread -lrt
 
 .PHONY: all
 
diff -r 5d49967c2184 util/gnutv/gnutv.c
--- a/util/gnutv/gnutv.c	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv.c	Mon May 03 14:16:42 2010 +0200
@@ -28,6 +28,9 @@
 #include <signal.h>
 #include <pthread.h>
 #include <sys/poll.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/select.h>
 #include <libdvbapi/dvbdemux.h>
 #include <libdvbapi/dvbaudio.h>
 #include <libdvbsec/dvbsec_cfg.h>
@@ -101,6 +104,54 @@ int find_channel(struct dvbcfg_zapchanne
 	return 0;
 }
 
+/*
+ * remote control: get channel info
+ * @return 0 on success, -1 otherwise
+ */
+int rc_get_channel_info(char* chanfile, char* channel_name, struct gnutv_dvb_params* gnutv_dvb_params)
+{
+	// find the requested channel
+	if (strlen(channel_name) >= sizeof(gnutv_dvb_params->channel.name)) {
+		fprintf(stderr, "404 Channel name is too long %s\n", channel_name);
+		return -1;
+	}
+	FILE *channel_file = fopen(chanfile, "r");
+	if (channel_file == NULL) {
+		fprintf(stderr, "404 Could open channel file %s\n", chanfile);
+		return -1;
+	}
+	memcpy(gnutv_dvb_params->channel.name, channel_name, strlen(channel_name) + 1);
+	if (dvbcfg_zapchannel_parse(channel_file, find_channel, &gnutv_dvb_params->channel) != 1) {
+		fprintf(stderr, "404 Unable to find requested channel %s\n", channel_name);
+		return -1;
+	}
+	fclose(channel_file);
+
+	return 0;
+}
+
+
+#include <time.h>
+struct timespec timer_start;
+
+void start_timer(void)
+{
+	clock_gettime(CLOCK_REALTIME, &timer_start);
+}
+
+void stop_timer(void)
+{
+	struct timespec timer_end;
+	clock_gettime(CLOCK_REALTIME, &timer_end);
+	timer_end.tv_sec -= timer_start.tv_sec;
+	timer_end.tv_nsec -= timer_start.tv_nsec;
+	if (timer_end.tv_nsec <0 ) {
+		timer_end.tv_nsec += 1000000000;
+		timer_end.tv_sec --;
+	}
+	fprintf(stderr, "700 timer: %ld.%ld   s.ms \n", timer_end.tv_sec, timer_end.tv_nsec / 1000000);
+}
+
 int main(int argc, char *argv[])
 {
 	int adapter_id = 0;
@@ -126,7 +177,12 @@ int main(int argc, char *argv[])
 	int ffaudiofd = -1;
 	int usertp = 0;
 	int buffer_size = 0;
-
+	int remote_control = 0;
+	int rc_fd = 0; // read from stdin
+#define INPUT_LEN 80
+	char input_line[INPUT_LEN]="";
+	int input_pos=0;
+	
 	while(argpos != argc) {
 		if (!strcmp(argv[argpos], "-h")) {
 			usage();
@@ -235,6 +291,9 @@ int main(int argc, char *argv[])
 		} else if (!strcmp(argv[argpos], "-cammenu")) {
 			cammenu = 1;
 			argpos++;
+		} else if (!strcmp(argv[argpos], "-remote")) {
+			remote_control = 1;
+			argpos++;
 		} else {
 			if ((argc - argpos) != 1)
 				usage();
@@ -263,7 +322,7 @@ int main(int argc, char *argv[])
 	// setup any signals
 	signal(SIGINT, signal_handler);
 	signal(SIGPIPE, SIG_IGN);
-
+start_timer(); // initialize once. 
 	// start the CA stuff
 	gnutv_ca_params.adapter_id = adapter_id;
 	gnutv_ca_params.caslot_num = caslot_num;
@@ -349,6 +408,53 @@ int main(int argc, char *argv[])
 			gnutv_ca_ui();
 		else
 			usleep(1);
+
+		if (remote_control) {
+			fd_set set;
+			struct timeval _timeout = { 0, 1000*10 }; // 10ms
+			FD_SET(rc_fd, &set); // add stdin
+			select(rc_fd+1, &set, NULL, NULL, &_timeout);
+			if (FD_ISSET(rc_fd,&set)) {
+				// data on stdin
+				int len;
+				len = read(rc_fd,input_line+input_pos,  INPUT_LEN-input_pos-1);
+				if (len>0) {
+					input_pos+=len;
+					input_line[input_pos]=0;
+					if (input_line[input_pos-1]=='\n') {
+						int ret;
+						// todo: propably more portable newline handling
+						// -> switch to new channel
+
+                                                input_line[input_pos-1]='\0';
+start_timer(); // end timer in gnutv_ca:263 - after ca received new pmt
+						ret = rc_get_channel_info(chanfile, input_line, &gnutv_dvb_params);
+						if (!ret) {
+							gnutv_data_stop();
+							gnutv_dvb_stop();
+                                                        dvbfe_close(gnutv_dvb_params.fe);
+
+                                                        usleep(10*1000); // yield to let threads pass away
+                                                        gnutv_ca_restart(&gnutv_ca_params);
+
+                                                        gnutv_dvb_params.fe = dvbfe_open(adapter_id, frontend_id, 0);
+							gnutv_dvb_start(&gnutv_dvb_params);
+							// start the data stuff
+							gnutv_data_start(output_type, ffaudiofd, adapter_id, demux_id, buffer_size, outfile, outif, outaddrs, usertp);
+						} else {
+							if (!strcmp("quit",input_line)) {
+								quit_app = 1;
+							} else {
+								fprintf(stderr, "400 channel name [%s] not found.\n",input_line);
+							}
+						}
+						input_pos=0;
+						input_line[0]='\0';
+					}
+				}
+			}
+		}
+
 	}
 
 	// stop data handling
diff -r 5d49967c2184 util/gnutv/gnutv.h
--- a/util/gnutv/gnutv.h	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv.h	Mon May 03 14:16:42 2010 +0200
@@ -34,4 +34,7 @@
 #define OUTPUT_TYPE_UDP 5
 #define OUTPUT_TYPE_STDOUT 6
 
+extern void start_timer(void);
+void stop_timer(void);
+
 #endif
diff -r 5d49967c2184 util/gnutv/gnutv_ca.c
--- a/util/gnutv/gnutv_ca.c	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv_ca.c	Mon May 03 14:16:42 2010 +0200
@@ -1,24 +1,24 @@
 /*
-	gnutv utility
+        gnutv utility
 
-	Copyright (C) 2004, 2005 Manu Abraham <abraham.manu@gmail.com>
-	Copyright (C) 2006 Andrew de Quincey (adq_dvb@lidskialf.net)
+        Copyright (C) 2004, 2005 Manu Abraham <abraham.manu@gmail.com>
+        Copyright (C) 2006 Andrew de Quincey (adq_dvb@lidskialf.net)
 
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
+        This program is free software; you can redistribute it and/or modify
+        it under the terms of the GNU General Public License as published by
+        the Free Software Foundation; either version 2 of the License, or
+        (at your option) any later version.
 
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+        This program is distributed in the hope that it will be useful,
+        but WITHOUT ANY WARRANTY; without even the implied warranty of
+        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 
-	GNU General Public License for more details.
+        GNU General Public License for more details.
 
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+        You should have received a copy of the GNU General Public License
+        along with this program; if not, write to the Free Software
+        Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -38,23 +38,23 @@
 
 static int gnutv_ca_info_callback(void *arg, uint8_t slot_id, uint16_t session_number, uint32_t ca_id_count, uint16_t *ca_ids);
 static int gnutv_ai_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-			     uint8_t application_type, uint16_t application_manufacturer,
-			     uint16_t manufacturer_code, uint8_t menu_string_length,
-			     uint8_t *menu_string);
+        uint8_t application_type, uint16_t application_manufacturer,
+        uint16_t manufacturer_code, uint8_t menu_string_length,
+        uint8_t *menu_string);
 
 static int gnutv_mmi_close_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-				    uint8_t cmd_id, uint8_t delay);
+        uint8_t cmd_id, uint8_t delay);
 static int gnutv_mmi_display_control_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-					      uint8_t cmd_id, uint8_t mmi_mode);
+        uint8_t cmd_id, uint8_t mmi_mode);
 static int gnutv_mmi_enq_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-				  uint8_t blind_answer, uint8_t expected_answer_length,
-				  uint8_t *text, uint32_t text_size);
+        uint8_t blind_answer, uint8_t expected_answer_length,
+        uint8_t *text, uint32_t text_size);
 static int gnutv_mmi_menu_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-				   struct en50221_app_mmi_text *title,
-				   struct en50221_app_mmi_text *sub_title,
-				   struct en50221_app_mmi_text *bottom,
-				   uint32_t item_count, struct en50221_app_mmi_text *items,
-				   uint32_t item_raw_length, uint8_t *items_raw);
+        struct en50221_app_mmi_text *title,
+        struct en50221_app_mmi_text *sub_title,
+        struct en50221_app_mmi_text *bottom,
+        uint32_t item_count, struct en50221_app_mmi_text *items,
+        uint32_t item_raw_length, uint8_t *items_raw);
 static void *camthread_func(void* arg);
 
 static struct en50221_transport_layer *tl = NULL;
@@ -78,327 +78,349 @@ uint32_t ui_linepos = 0;
 
 void gnutv_ca_start(struct gnutv_ca_params *params)
 {
-	// create transport layer
-	tl = en50221_tl_create(1, 16);
-	if (tl == NULL) {
-		fprintf(stderr, "Failed to create transport layer\n");
-		return;
-	}
+    // create transport layer
+    tl = en50221_tl_create(1, 16);
+    if (tl == NULL) {
+        fprintf(stderr, "Failed to create transport layer\n");
+        return;
+    }
 
-	// create session layer
-	sl = en50221_sl_create(tl, 16);
-	if (sl == NULL) {
-		fprintf(stderr, "Failed to create session layer\n");
-		en50221_tl_destroy(tl);
-		return;
-	}
+    // create session layer
+    sl = en50221_sl_create(tl, 16);
+    if (sl == NULL) {
+        fprintf(stderr, "Failed to create session layer\n");
+        en50221_tl_destroy(tl);
+        return;
+    }
 
-	// create the stdcam instance
-	stdcam = en50221_stdcam_create(params->adapter_id, params->caslot_num, tl, sl);
-	if (stdcam == NULL) {
-		en50221_sl_destroy(sl);
-		en50221_tl_destroy(tl);
-		return;
-	}
+    // create the stdcam instance
+    stdcam = en50221_stdcam_create(params->adapter_id, params->caslot_num, tl, sl);
+    if (stdcam == NULL) {
+        en50221_sl_destroy(sl);
+        en50221_tl_destroy(tl);
+        return;
+    }
 
-	// hook up the AI callbacks
-	if (stdcam->ai_resource) {
-		en50221_app_ai_register_callback(stdcam->ai_resource, gnutv_ai_callback, stdcam);
-	}
+    // hook up the AI callbacks
+    if (stdcam->ai_resource) {
+        en50221_app_ai_register_callback(stdcam->ai_resource, gnutv_ai_callback, stdcam);
+    }
 
-	// hook up the CA callbacks
-	if (stdcam->ca_resource) {
-		en50221_app_ca_register_info_callback(stdcam->ca_resource, gnutv_ca_info_callback, stdcam);
-	}
+    // hook up the CA callbacks
+    if (stdcam->ca_resource) {
+        en50221_app_ca_register_info_callback(stdcam->ca_resource, gnutv_ca_info_callback, stdcam);
+    }
 
-	// hook up the MMI callbacks
-	if (params->cammenu) {
-		if (stdcam->mmi_resource) {
-			en50221_app_mmi_register_close_callback(stdcam->mmi_resource, gnutv_mmi_close_callback, stdcam);
-			en50221_app_mmi_register_display_control_callback(stdcam->mmi_resource, gnutv_mmi_display_control_callback, stdcam);
-			en50221_app_mmi_register_enq_callback(stdcam->mmi_resource, gnutv_mmi_enq_callback, stdcam);
-			en50221_app_mmi_register_menu_callback(stdcam->mmi_resource, gnutv_mmi_menu_callback, stdcam);
-			en50221_app_mmi_register_list_callback(stdcam->mmi_resource, gnutv_mmi_menu_callback, stdcam);
-		} else {
-			fprintf(stderr, "CAM Menus are not supported by this interface hardware\n");
-			exit(1);
-		}
-	}
+    // hook up the MMI callbacks
+    if (params->cammenu) {
+        if (stdcam->mmi_resource) {
+            en50221_app_mmi_register_close_callback(stdcam->mmi_resource, gnutv_mmi_close_callback, stdcam);
+            en50221_app_mmi_register_display_control_callback(stdcam->mmi_resource, gnutv_mmi_display_control_callback, stdcam);
+            en50221_app_mmi_register_enq_callback(stdcam->mmi_resource, gnutv_mmi_enq_callback, stdcam);
+            en50221_app_mmi_register_menu_callback(stdcam->mmi_resource, gnutv_mmi_menu_callback, stdcam);
+            en50221_app_mmi_register_list_callback(stdcam->mmi_resource, gnutv_mmi_menu_callback, stdcam);
+        } else {
+            fprintf(stderr, "CAM Menus are not supported by this interface hardware\n");
+            exit(1);
+        }
+    }
 
-	// any other stuff
-	moveca = params->moveca;
-	cammenu = params->cammenu;
+    // any other stuff
+    moveca = params->moveca;
+    cammenu = params->cammenu;
 
-	// start the cam thread
-	pthread_create(&camthread, NULL, camthread_func, NULL);
+    // start the cam thread
+    pthread_create(&camthread, NULL, camthread_func, NULL);
 }
 
 void gnutv_ca_stop(void)
 {
-	if (stdcam == NULL)
-		return;
+    if (stdcam == NULL)
+        return;
 
-	// shutdown the cam thread
-	camthread_shutdown = 1;
-	pthread_join(camthread, NULL);
+    // shutdown the cam thread
+    camthread_shutdown = 1;
+    pthread_join(camthread, NULL);
 
-	// destroy the stdcam
-	if (stdcam->destroy)
-		stdcam->destroy(stdcam, 1);
+    // destroy the stdcam
+    if (stdcam->destroy)
+        stdcam->destroy(stdcam, 1);
 
-	// destroy session layer
-	en50221_sl_destroy(sl);
+    // destroy session layer
+    en50221_sl_destroy(sl);
 
-	// destroy transport layer
-	en50221_tl_destroy(tl);
+    // destroy transport layer
+    en50221_tl_destroy(tl);
+
+    tl = NULL;
+    sl = NULL;
+    stdcam = NULL;
+    ca_resource_connected = 0;
+}
+
+void gnutv_ca_restart(struct gnutv_ca_params *params)
+{
+
+    printf("303 cam thread restart....\n");
+    if (stdcam == NULL)
+        return;
+
+    printf("303 ca_start restart\n");
+    // create transport layer
+
+    seenpmt = 0;
+
+    // any other stuff
+    moveca = params->moveca;
+    cammenu = params->cammenu;
 }
 
 void gnutv_ca_ui(void)
 {
-	// make up polling structure for stdin
-	struct pollfd pollfd;
-	pollfd.fd = 0;
+    // make up polling structure for stdin
+    struct pollfd pollfd;
+    pollfd.fd = 0;
 	pollfd.events = POLLIN|POLLPRI|POLLERR;
 
-	if (stdcam == NULL)
-		return;
+    if (stdcam == NULL)
+        return;
 
-	// is there a character?
-	if (poll(&pollfd, 1, 10) != 1)
-		return;
-	if (pollfd.revents & POLLERR)
-		return;
+    // is there a character?
+    if (poll(&pollfd, 1, 10) != 1)
+        return;
+    if (pollfd.revents & POLLERR)
+        return;
 
-	// try to read the character
-	char c;
-	if (read(0, &c, 1) != 1)
-		return;
-	if (c == '\r') {
-		return;
-	} else if (c == '\n') {
+    // try to read the character
+    char c;
+    if (read(0, &c, 1) != 1)
+        return;
+    if (c == '\r') {
+        return;
+    } else if (c == '\n') {
 		switch(mmi_state) {
-		case MMI_STATE_CLOSED:
-		case MMI_STATE_OPEN:
-			if ((ui_linepos == 0) && (ca_resource_connected)) {
-				en50221_app_ai_entermenu(stdcam->ai_resource, stdcam->ai_session_number);
-			}
-			break;
+            case MMI_STATE_CLOSED:
+            case MMI_STATE_OPEN:
+                if ((ui_linepos == 0) && (ca_resource_connected)) {
+                    en50221_app_ai_entermenu(stdcam->ai_resource, stdcam->ai_session_number);
+                }
+                break;
 
-		case MMI_STATE_ENQ:
-			if (ui_linepos == 0) {
-				en50221_app_mmi_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
-							MMI_ANSW_ID_CANCEL, NULL, 0);
-			} else {
-				en50221_app_mmi_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
-							MMI_ANSW_ID_ANSWER, (uint8_t*) ui_line, ui_linepos);
-			}
-			mmi_state = MMI_STATE_OPEN;
-			break;
+            case MMI_STATE_ENQ:
+                if (ui_linepos == 0) {
+                    en50221_app_mmi_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
+                            MMI_ANSW_ID_CANCEL, NULL, 0);
+                } else {
+                    en50221_app_mmi_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
+                            MMI_ANSW_ID_ANSWER, (uint8_t*) ui_line, ui_linepos);
+                }
+                mmi_state = MMI_STATE_OPEN;
+                break;
 
-		case MMI_STATE_MENU:
-			ui_line[ui_linepos] = 0;
-			en50221_app_mmi_menu_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
-							atoi(ui_line));
-			mmi_state = MMI_STATE_OPEN;
-			break;
-		}
-		ui_linepos = 0;
-	} else {
-		if (ui_linepos < (sizeof(ui_line)-1)) {
-			ui_line[ui_linepos++] = c;
-		}
-	}
+            case MMI_STATE_MENU:
+                ui_line[ui_linepos] = 0;
+                en50221_app_mmi_menu_answ(stdcam->mmi_resource, stdcam->mmi_session_number,
+                        atoi(ui_line));
+                mmi_state = MMI_STATE_OPEN;
+                break;
+        }
+        ui_linepos = 0;
+    } else {
+        if (ui_linepos < (sizeof (ui_line) - 1)) {
+            ui_line[ui_linepos++] = c;
+        }
+    }
 }
 
-int gnutv_ca_new_pmt(struct mpeg_pmt_section *pmt)
-{
-	uint8_t capmt[4096];
-	int size;
+int gnutv_ca_new_pmt(struct mpeg_pmt_section *pmt) {
+    uint8_t capmt[4096];
+    int size;
 
-	if (stdcam == NULL)
-		return -1;
+    if (stdcam == NULL)
+        return -1;
 
-	if (ca_resource_connected) {
-		fprintf(stderr, "Received new PMT - sending to CAM...\n");
+    if (ca_resource_connected) {
+        fprintf(stderr, "Received new PMT - sending to CAM...\n");
 
-		// translate it into a CA PMT
-		int listmgmt = CA_LIST_MANAGEMENT_ONLY;
-		if (seenpmt) {
-			listmgmt = CA_LIST_MANAGEMENT_UPDATE;
-		}
-		seenpmt = 1;
+        // translate it into a CA PMT
+        int listmgmt = CA_LIST_MANAGEMENT_ONLY;
+        if (seenpmt) {
+            listmgmt = CA_LIST_MANAGEMENT_UPDATE;
+        }
+        seenpmt = 1;
 
 		if ((size = en50221_ca_format_pmt(pmt, capmt, sizeof(capmt), moveca, listmgmt,
-						  CA_PMT_CMD_ID_OK_DESCRAMBLING)) < 0) {
-			fprintf(stderr, "Failed to format PMT\n");
-			return -1;
-		}
+                CA_PMT_CMD_ID_OK_DESCRAMBLING)) < 0) {
+            fprintf(stderr, "Failed to format PMT\n");
+            return -1;
+        }
 
-		// set it
-		if (en50221_app_ca_pmt(stdcam->ca_resource, stdcam->ca_session_number, capmt, size)) {
-			fprintf(stderr, "Failed to send PMT\n");
-			return -1;
-		}
+        // set it
+        if (en50221_app_ca_pmt(stdcam->ca_resource, stdcam->ca_session_number, capmt, size)) {
+            fprintf(stderr, "Failed to send PMT\n");
+            return -1;
+        }
+        stop_timer();
+        // we've seen this PMT
+        return 1;
+    }
 
-		// we've seen this PMT
-		return 1;
-	}
-
-	return 0;
+    return 0;
 }
 
 void gnutv_ca_new_dvbtime(time_t dvb_time)
 {
-	if (stdcam == NULL)
-		return;
+    if (stdcam == NULL)
+        return;
 
-	if (stdcam->dvbtime)
-		stdcam->dvbtime(stdcam, dvb_time);
+    if (stdcam->dvbtime)
+        stdcam->dvbtime(stdcam, dvb_time);
 }
 
 static void *camthread_func(void* arg)
 {
-	(void) arg;
-	int entered_menu = 0;
+    (void) arg;
+    int entered_menu = 0;
 
-	while(!camthread_shutdown) {
-		stdcam->poll(stdcam);
+    camthread_shutdown = 0;
+    while (!camthread_shutdown) {
+        stdcam->poll(stdcam);
 
-		if ((!entered_menu) && cammenu && ca_resource_connected && stdcam->mmi_resource) {
-			en50221_app_ai_entermenu(stdcam->ai_resource, stdcam->ai_session_number);
-			entered_menu = 1;
-		}
-	}
+        if ((!entered_menu) && cammenu && ca_resource_connected && stdcam->mmi_resource) {
+            en50221_app_ai_entermenu(stdcam->ai_resource, stdcam->ai_session_number);
+            entered_menu = 1;
+        }
+    }
 
-	return 0;
+    return 0;
 }
 
 static int gnutv_ai_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-			     uint8_t application_type, uint16_t application_manufacturer,
-			     uint16_t manufacturer_code, uint8_t menu_string_length,
+        uint8_t application_type, uint16_t application_manufacturer,
+        uint16_t manufacturer_code, uint8_t menu_string_length,
 			     uint8_t *menu_string)
 {
-	(void) arg;
-	(void) slot_id;
-	(void) session_number;
+    (void) arg;
+    (void) slot_id;
+    (void) session_number;
 
-	fprintf(stderr, "CAM Application type: %02x\n", application_type);
-	fprintf(stderr, "CAM Application manufacturer: %04x\n", application_manufacturer);
-	fprintf(stderr, "CAM Manufacturer code: %04x\n", manufacturer_code);
-	fprintf(stderr, "CAM Menu string: %.*s\n", menu_string_length, menu_string);
+    fprintf(stderr, "CAM Application type: %02x\n", application_type);
+    fprintf(stderr, "CAM Application manufacturer: %04x\n", application_manufacturer);
+    fprintf(stderr, "CAM Manufacturer code: %04x\n", manufacturer_code);
+    fprintf(stderr, "CAM Menu string: %.*s\n", menu_string_length, menu_string);
 
-	return 0;
+    return 0;
 }
 
 static int gnutv_ca_info_callback(void *arg, uint8_t slot_id, uint16_t session_number, uint32_t ca_id_count, uint16_t *ca_ids)
 {
-	(void) arg;
-	(void) slot_id;
-	(void) session_number;
+    (void) arg;
+    (void) slot_id;
+    (void) session_number;
 
-	fprintf(stderr, "CAM supports the following ca system ids:\n");
-	uint32_t i;
+    fprintf(stderr, "CAM supports the following ca system ids:\n");
+    uint32_t i;
 	for(i=0; i< ca_id_count; i++) {
-		fprintf(stderr, "  0x%04x\n", ca_ids[i]);
-	}
-	ca_resource_connected = 1;
-	return 0;
+        fprintf(stderr, "  0x%04x\n", ca_ids[i]);
+    }
+    ca_resource_connected = 1;
+    return 0;
 }
 
 static int gnutv_mmi_close_callback(void *arg, uint8_t slot_id, uint16_t session_number,
 				    uint8_t cmd_id, uint8_t delay)
 {
-	(void) arg;
-	(void) slot_id;
-	(void) session_number;
-	(void) cmd_id;
-	(void) delay;
+    (void) arg;
+    (void) slot_id;
+    (void) session_number;
+    (void) cmd_id;
+    (void) delay;
 
-	// note: not entirely correct as its supposed to delay if asked
-	mmi_state = MMI_STATE_CLOSED;
-	return 0;
+    // note: not entirely correct as its supposed to delay if asked
+    mmi_state = MMI_STATE_CLOSED;
+    return 0;
 }
 
 static int gnutv_mmi_display_control_callback(void *arg, uint8_t slot_id, uint16_t session_number,
 					      uint8_t cmd_id, uint8_t mmi_mode)
 {
-	struct en50221_app_mmi_display_reply_details reply;
-	(void) arg;
-	(void) slot_id;
+    struct en50221_app_mmi_display_reply_details reply;
+    (void) arg;
+    (void) slot_id;
 
-	// don't support any commands but set mode
-	if (cmd_id != MMI_DISPLAY_CONTROL_CMD_ID_SET_MMI_MODE) {
-		en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
-					      MMI_DISPLAY_REPLY_ID_UNKNOWN_CMD_ID, &reply);
-		return 0;
-	}
+    // don't support any commands but set mode
+    if (cmd_id != MMI_DISPLAY_CONTROL_CMD_ID_SET_MMI_MODE) {
+        en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
+                MMI_DISPLAY_REPLY_ID_UNKNOWN_CMD_ID, &reply);
+        return 0;
+    }
 
-	// we only support high level mode
-	if (mmi_mode != MMI_MODE_HIGH_LEVEL) {
-		en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
-					      MMI_DISPLAY_REPLY_ID_UNKNOWN_MMI_MODE, &reply);
-		return 0;
-	}
+    // we only support high level mode
+    if (mmi_mode != MMI_MODE_HIGH_LEVEL) {
+        en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
+                MMI_DISPLAY_REPLY_ID_UNKNOWN_MMI_MODE, &reply);
+        return 0;
+    }
 
-	// ack the high level open
-	reply.u.mode_ack.mmi_mode = mmi_mode;
-	en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
-				      MMI_DISPLAY_REPLY_ID_MMI_MODE_ACK, &reply);
-	mmi_state = MMI_STATE_OPEN;
-	return 0;
+    // ack the high level open
+    reply.u.mode_ack.mmi_mode = mmi_mode;
+    en50221_app_mmi_display_reply(stdcam->mmi_resource, session_number,
+            MMI_DISPLAY_REPLY_ID_MMI_MODE_ACK, &reply);
+    mmi_state = MMI_STATE_OPEN;
+    return 0;
 }
 
 static int gnutv_mmi_enq_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-				  uint8_t blind_answer, uint8_t expected_answer_length,
-				  uint8_t *text, uint32_t text_size)
+        uint8_t blind_answer, uint8_t expected_answer_length,
+        uint8_t *text, uint32_t text_size)
 {
-	(void) arg;
-	(void) slot_id;
-	(void) session_number;
+    (void) arg;
+    (void) slot_id;
+    (void) session_number;
 
-	fprintf(stderr, "%.*s: ", text_size, text);
-	fflush(stdout);
+    fprintf(stderr, "%.*s: ", text_size, text);
+    fflush(stdout);
 
-	mmi_enq_blind = blind_answer;
-	mmi_enq_length = expected_answer_length;
-	mmi_state = MMI_STATE_ENQ;
-	return 0;
+    mmi_enq_blind = blind_answer;
+    mmi_enq_length = expected_answer_length;
+    mmi_state = MMI_STATE_ENQ;
+    return 0;
 }
 
 static int gnutv_mmi_menu_callback(void *arg, uint8_t slot_id, uint16_t session_number,
-				   struct en50221_app_mmi_text *title,
-				   struct en50221_app_mmi_text *sub_title,
-				   struct en50221_app_mmi_text *bottom,
-				   uint32_t item_count, struct en50221_app_mmi_text *items,
-				   uint32_t item_raw_length, uint8_t *items_raw)
+        struct en50221_app_mmi_text *title,
+        struct en50221_app_mmi_text *sub_title,
+        struct en50221_app_mmi_text *bottom,
+        uint32_t item_count, struct en50221_app_mmi_text *items,
+        uint32_t item_raw_length, uint8_t *items_raw)
 {
-	(void) arg;
-	(void) slot_id;
-	(void) session_number;
-	(void) item_raw_length;
-	(void) items_raw;
+    (void) arg;
+    (void) slot_id;
+    (void) session_number;
+    (void) item_raw_length;
+    (void) items_raw;
 
-	fprintf(stderr, "------------------------------\n");
+    fprintf(stderr, "------------------------------\n");
 
-	if (title->text_length) {
-		fprintf(stderr, "%.*s\n", title->text_length, title->text);
-	}
-	if (sub_title->text_length) {
-		fprintf(stderr, "%.*s\n", sub_title->text_length, sub_title->text);
-	}
+    if (title->text_length) {
+        fprintf(stderr, "%.*s\n", title->text_length, title->text);
+    }
+    if (sub_title->text_length) {
+        fprintf(stderr, "%.*s\n", sub_title->text_length, sub_title->text);
+    }
 
-	uint32_t i;
-	fprintf(stderr, "0. Quit menu\n");
+    uint32_t i;
+    fprintf(stderr, "0. Quit menu\n");
 	for(i=0; i< item_count; i++) {
 		fprintf(stderr, "%i. %.*s\n", i+1, items[i].text_length, items[i].text);
-	}
+    }
 
-	if (bottom->text_length) {
-		fprintf(stderr, "%.*s\n", bottom->text_length, bottom->text);
-	}
-	fprintf(stderr, "Enter option: ");
-	fflush(stdout);
+    if (bottom->text_length) {
+        fprintf(stderr, "%.*s\n", bottom->text_length, bottom->text);
+    }
+    fprintf(stderr, "Enter option: ");
+    fflush(stdout);
 
-	mmi_state = MMI_STATE_MENU;
-	return 0;
+    mmi_state = MMI_STATE_MENU;
+    return 0;
 }
diff -r 5d49967c2184 util/gnutv/gnutv_ca.h
--- a/util/gnutv/gnutv_ca.h	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv_ca.h	Mon May 03 14:16:42 2010 +0200
@@ -31,6 +31,7 @@ struct gnutv_ca_params {
 };
 
 extern void gnutv_ca_start(struct gnutv_ca_params *params);
+extern void gnutv_ca_restart(struct gnutv_ca_params *params);
 extern void gnutv_ca_ui(void);
 extern void gnutv_ca_stop(void);
 
diff -r 5d49967c2184 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv_data.c	Mon May 03 14:16:42 2010 +0200
@@ -61,7 +61,7 @@ static int outfd = -1;
 static int dvrfd = -1;
 static int pat_fd_dvrout = -1;
 static int pmt_fd_dvrout = -1;
-static int outputthread_shutdown = 0;
+static volatile int outputthread_shutdown = 0;
 
 static int usertp = 0;
 static int adapter_id = -1;
@@ -86,7 +86,7 @@ void gnutv_data_start(int _output_type,
 	adapter_id = _adapter_id;
 	output_type = _output_type;
 
-	// setup output
+        // setup output
 	switch(output_type) {
 	case OUTPUT_TYPE_DECODER:
 	case OUTPUT_TYPE_DECODER_ABYPASS:
@@ -186,6 +186,11 @@ void gnutv_data_stop()
 		close(pmt_fd_dvrout);
 	if (outaddrs)
 		freeaddrinfo(outaddrs);
+
+	outaddrs = NULL;
+	dvrfd = -1;
+	pmt_fd_dvrout = -1;
+	pat_fd_dvrout = -1;
 }
 
 void gnutv_data_new_pat(int pmt_pid)
@@ -235,7 +240,9 @@ static void *fileoutputthread_func(void*
 	pollfd.fd = dvrfd;
 	pollfd.events = POLLIN|POLLPRI|POLLERR;
 
-	while(!outputthread_shutdown) {
+	outputthread_shutdown=0;
+
+        while(!outputthread_shutdown) {
 		if (poll(&pollfd, 1, 1000) == -1) {
 			if (errno == EINTR)
 				continue;
@@ -274,7 +281,7 @@ static void *fileoutputthread_func(void*
 			}
 		}
 	}
-
+	printf("202 shutdown fileoutputthread\n ");
 	return 0;
 }
 
@@ -310,6 +317,8 @@ static void *udpoutputthread_func(void* 
 		bufbase = 12;
 	}
 
+	outputthread_shutdown=0;
+
 	while(!outputthread_shutdown) {
 		if (poll(&pollfd, 1, 1000) != 1)
 			continue;
@@ -403,7 +412,7 @@ static void gnutv_data_decoder_pmt(struc
 	int audio_pid = -1;
 	int video_pid = -1;
 	struct mpeg_pmt_stream *cur_stream;
-	mpeg_pmt_section_streams_for_each(pmt, cur_stream) {
+        mpeg_pmt_section_streams_for_each(pmt, cur_stream) {
 		switch(cur_stream->stream_type) {
 		case 1:
 		case 2: // video
diff -r 5d49967c2184 util/gnutv/gnutv_dvb.c
--- a/util/gnutv/gnutv_dvb.c	Sun May 02 10:31:40 2010 +0200
+++ b/util/gnutv/gnutv_dvb.c	Mon May 03 14:16:42 2010 +0200
@@ -57,6 +57,11 @@ static int create_section_filter(int ada
 
 int gnutv_dvb_start(struct gnutv_dvb_params *params)
 {
+	dvbthread_shutdown = 0;
+	pat_version = -1;
+	ca_pmt_version = -1;
+	data_pmt_version = -1;
+
 	pthread_create(&dvbthread, NULL, dvbthread_func, (void*) params);
 	return 0;
 }
@@ -81,6 +86,8 @@ static void *dvbthread_func(void* arg)
 
 	struct gnutv_dvb_params *params = (struct gnutv_dvb_params *) arg;
 
+	dvbthread_shutdown = 0;
+
 	tune_state = 0;
 
 	// create PAT filter
@@ -252,7 +259,7 @@ static void process_pat(int pat_fd, stru
 	// try and find the requested program
 	struct mpeg_pat_program *cur_program;
 	mpeg_pat_section_programs_for_each(pat, cur_program) {
-		if (cur_program->program_number == params->channel.service_id) {
+            if (cur_program->program_number == params->channel.service_id) {
 			// close old PMT fd
 			if (*pmt_fd != -1)
 				close(*pmt_fd);
@@ -345,7 +352,7 @@ static void process_pmt(int pmt_fd, stru
 
 	// do ca handling
 	if (section_ext->version_number != ca_pmt_version) {
-		if (gnutv_ca_new_pmt(pmt) == 1)
+		if (gnutv_ca_new_pmt(pmt) == 1) 
 			ca_pmt_version = pmt->head.version_number;
 	}
 }

--------------050505090800010006070509--
