Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1L23Zy-0008DD-GX
	for linux-dvb@linuxtv.org; Mon, 17 Nov 2008 13:51:47 +0100
Received: by fk-out-0910.google.com with SMTP id f40so3584098fka.1
	for <linux-dvb@linuxtv.org>; Mon, 17 Nov 2008 04:51:42 -0800 (PST)
Message-ID: <492168D8.4050900@googlemail.com>
Date: Mon, 17 Nov 2008 13:51:36 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------050809070002090508090501"
Subject: [linux-dvb] [PATCH]Fix a bug in scan,
 which outputs the wrong frequency if the current tuned transponder
 is scanned only
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------050809070002090508090501
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

if the current tuned transponder is scanned only and the output needs the frequency of the
transponder, it is used the last frequency, which is found during the NIT scanning. This
is wrong. The attached patch will fix this problem.

Regards,
Hartmut



--------------050809070002090508090501
Content-Type: text/x-diff;
 name="scan_fix_current_transponder_only.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan_fix_current_transponder_only.diff"

signed-off-by: Hartmut Birr <e9hack@googlemail.com>
diff -r afd0efc0f9d2 util/scan/scan.c
--- a/util/scan/scan.c	Mon Nov 10 16:32:50 2008 +0100
+++ b/util/scan/scan.c	Mon Nov 17 10:20:02 2008 +0100
@@ -221,8 +221,6 @@ static struct transponder *find_transpon
 
 	list_for_each(pos, &scanned_transponders) {
 		tp = list_entry(pos, struct transponder, list);
-		if (current_tp_only)
-			return tp;
 		if (is_same_transponder(tp->param.frequency, frequency))
 			return tp;
 	}
@@ -879,9 +877,10 @@ static void parse_nit (const unsigned ch
 		if (tn.type == fe_info.type) {
 			/* only add if develivery_descriptor matches FE type */
 			t = find_transponder(tn.param.frequency);
-			if (!t)
+			if (!t && !current_tp_only)
 				t = alloc_transponder(tn.param.frequency);
-			copy_transponder(t, &tn);
+			if (t)
+				copy_transponder(t, &tn);
 		}
 
 		section_length -= descriptors_loop_len + 6;
@@ -2284,7 +2283,10 @@ int main (int argc, char **argv)
 	signal(SIGINT, handle_sigint);
 
 	if (current_tp_only) {
-		current_tp = alloc_transponder(0); /* dummy */
+		struct dvb_frontend_parameters frontend_params;
+		if (ioctl(frontend_fd, FE_GET_FRONTEND, &frontend_params) < 0)
+			fatal("FE_GET_FRONTEND failed: %d %m\n", errno);
+		current_tp = alloc_transponder(frontend_params.frequency);
 		/* move TP from "new" to "scanned" list */
 		list_del_init(&current_tp->list);
 		list_add_tail(&current_tp->list, &scanned_transponders);

--------------050809070002090508090501
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050809070002090508090501--
