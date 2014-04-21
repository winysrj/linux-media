Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.ekb-info.ru ([217.24.190.220]:43470 "EHLO
	relay.ekb-info.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaDUNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 09:19:48 -0400
Date: Mon, 21 Apr 2014 19:11:14 +0600
From: Andrey Volkov <volkov.am@ekb-info.ru>
To: linux-media@vger.kernel.org
Cc: volkov.am@ekb-info.ru
Subject: [Bugreport] v4l-utils/libv4lconvert/ov511-decomp does not shutdown
 on SIGTERM
Message-ID: <20140421191114.391d005d@axid.nolty.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

I use motion for my old web camera (v4l1) with
export LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so

v4l2convert.so run decompress helper ov511-decomp.

Processes look like:
/usr/bin/motion
\_ /usr/lib/i386-linux-gnu/libv4lconvert0/ov511-decomp

(motion - http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome)
Everything works fine, but when I stop motion daemon I have to wait for a minute.

strace prints that ov511-decomp got SIGTERM, wait for the minute and then got SIGKILL.

When I do "killall -TERM ov511-decomp" ov511-decomp ignores it and continue to decomress.
"killall -INT ov511-decomp" ov511-decomp shut down as expected.

As a workaround I made this patch to lib/libv4lconvert/helper.c

--- v4l-utils-1.0.1.orig/lib/libv4lconvert/helper.c
+++ v4l-utils-1.0.1/lib/libv4lconvert/helper.c
@@ -212,7 +212,7 @@ void v4lconvert_helper_cleanup(struct v4
void v4lconvert_helper_cleanup(struct v4lconvert_data *data)
{
	int status;

	if (data->decompress_pid != -1) {
-		kill(data->decompress_pid, SIGTERM);
+		kill(data->decompress_pid, SIGINT);
		waitpid(data->decompress_pid, &status, 0);

		close(data->decompress_out_pipe[WRITE_END]);
