Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40272 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaLOTJy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 14:09:54 -0500
Date: Mon, 15 Dec 2014 17:09:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: grigore calugar <zradu1100@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [tvtime] Broke support for cards with multiple numbers of the
 input
Message-ID: <20141215170948.1066aea9@recife.lan>
In-Reply-To: <CA+S3egD3p9p2MVNZqWAZ3zvcuJ3KQn9KDZp_Hm1im0NhiPfP3g@mail.gmail.com>
References: <CA+S3egD3p9p2MVNZqWAZ3zvcuJ3KQn9KDZp_Hm1im0NhiPfP3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Dec 2014 11:56:16 +0000
grigore calugar <zradu1100@gmail.com> escreveu:

> After commit:http://git.linuxtv.org/cgit.cgi/tvtime.git/commit/?id=c49ebc47c51e0bcf9e8c4403efdf0f31bf1b4479
> support for support for cards with multiple numbers of the input is
> broken. My tuner has 4 inputs and after this commit I can not select
> any from OSD menu.

Sorry, I inverted a test there. The enclosed patch should fix it.
I'm merging upstream.

Regards,
Mauro

[PATCH] Fix input select condition

Changeset c49ebc47c51e added an inverted condition with caused a
regression.

Reported-by: Grigore Calugar <zradu1100@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/src/videoinput.c b/src/videoinput.c
index 084cc3f4c7ed..50c2b84b70de 100644
--- a/src/videoinput.c
+++ b/src/videoinput.c
@@ -849,8 +849,8 @@ void videoinput_set_input_num( videoinput_t *vidin, int inputnum )
 
     videoinput_stop_capture_v4l2( vidin );
 
-    if( !vidin->numinputs ) {
-        if( ioctl( vidin->grab_fd, VIDIOC_S_INPUT, &index ) < 0 ) {
+    if( vidin->numinputs ) {
+	if( ioctl( vidin->grab_fd, VIDIOC_S_INPUT, &index ) < 0 ) {
 	    fprintf( stderr, "videoinput: Card refuses to set its input.\n"
 		     "Please post a bug report to " PACKAGE_BUGREPORT "\n"
 		     "indicating your card, driver, and this error message: %s.\n",


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
