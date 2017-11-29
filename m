Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50697 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753405AbdK2J04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 04:26:56 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] keytable: allow a period or delay of 0 to be set
Date: Wed, 29 Nov 2017 09:26:55 +0000
Message-Id: <20171129092655.17201-2-sean@mess.org>
In-Reply-To: <20171129092655.17201-1-sean@mess.org>
References: <20171129092655.17201-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If both period or delay are zero, then autorepeat is turned off.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 4c1e8641..988e9857 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -250,8 +250,8 @@ static int readtable = 0;
 static int clear = 0;
 static int debug = 0;
 static int test = 0;
-static int delay = 0;
-static int period = 0;
+static int delay = -1;
+static int period = -1;
 static enum sysfs_protocols ch_proto = 0;
 
 struct cfgfile cfg = {
@@ -477,10 +477,14 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		clear++;
 		break;
 	case 'D':
-		delay = atoi(arg);
+		delay = strtol(arg, &p, 10);
+		if (!p || *p || delay < 0)
+			argp_error(state, _("Invalid delay: %s"), arg);
 		break;
 	case 'P':
-		period = atoi(arg);
+		period = strtol(arg, &p, 10);
+		if (!p || *p || period < 0)
+			argp_error(state, _("Invalid period: %s"), arg);
 		break;
 	case 'd':
 		devicename = arg;
@@ -1513,7 +1517,7 @@ int main(int argc, char *argv[])
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP, 0, 0);
 
 	/* Just list all devices */
-	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && !delay && !period) {
+	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && delay < 0 && period < 0) {
 		if (devicename) {
 			fd = open(devicename, O_RDONLY);
 			if (fd < 0) {
@@ -1659,12 +1663,12 @@ int main(int argc, char *argv[])
 	/*
 	 * Fiveth step: change repeat rate/delay
 	 */
-	if (delay || period) {
+	if (delay >= 0 || period >= 0) {
 		unsigned int new_delay, new_period;
 		get_rate(fd, &new_delay, &new_period);
-		if (delay)
+		if (delay >= 0)
 			new_delay = delay;
-		if (period)
+		if (period >= 0)
 			new_period = period;
 		set_rate(fd, new_delay, new_period);
 	}
-- 
2.14.3
