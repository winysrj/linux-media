Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1O1QwKb006892
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 20:26:58 -0500
Received: from mxout-04.mxes.net (mxout-04.mxes.net [216.86.168.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1O1QJlI000341
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 20:26:19 -0500
Message-ID: <47C0C7B8.20608@cybermato.com>
Date: Sat, 23 Feb 2008 17:26:16 -0800
From: Chris MacGregor <chris-video4linux-list@cybermato.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH] usbvideo: usbvideo.c should check palette in VIDIOCSPICT
 (resend again)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Chris MacGregor <chris-usbvideo-patch-080216-3@cybermato.com>

This change makes VIDIOCSPICT return EINVAL if the requested palette (format)
doesn't match anything in paletteBits; this is essentially the same check as
is already made in VIDIOCMCAPTURE.  The patch is against 2.6.24.2.

The problem I had was that vlc (www.videolan.org) was failing to read video
from my Logitech Quickcam Messenger.  I ultimately tracked it to the fact that
vlc was testing what formats the driver+hardware could handle by trying to
select them with VIDIOCSPICT, and was assuming that if it didn't get an error
then the requested format was kosher.  However, usbvideo.c was not even
looking at that field, and so anything would succeed, but then VIDIOCMCAPTURE
would bomb out silently (EINVAL, but no log message) if the right paletteBits
bit wasn't set.

The risk, of course, is that this patch will break existing v4l clients that
accidentally pass non-zero garbage in the video_picture.palette field when
calling VIDIOCSPICT, but which pass a valid format to VIDIOCMCAPTURE.
However, what vlc does seems reasonable, and in fact I don't see an
alternative to it (though I'm no v4l expert), so I think we're better off with
the change than without.  I found plaintive, unanswered cries for help on
forums from folks wanting to know why vlc wasn't working with their webcams.

One could make the argument that a similar check should be made on the depth
field, but vlc doesn't mess with it and I'm not feeling that ambitious today.

Signed-off-by: Chris MacGregor <chris-usbvideo-patch-080216-3@cybermato.com>

---

Hi.  I was going to post this in lkml, but after looking in MAINTAINERS this
list seems more appropriate - if I'm wrong about that, please tell me
(directly, as I don't generally subscribe to either list).

I sent this message previously on February 16, 2008 (11:27 pm PST) but it
doesn't seem to have shown up on the list (based on looking through the
archives).  Ditto yesterday, so this time I'm sending it via a different
route in case the problem is an overzealous spam filter someplace.
Apologies to anyone who has already seen it.

Please CC me on replies as I'm not necessarily subscribed here.

    Chris MacGregor
    my first name @ cybermato.com
    www.cybermato.com

--- linux-2.6.24.2/drivers/media/video/usbvideo/usbvideo.c.orig	2008-02-10 21:51:11.000000000 -0800
+++ linux-2.6.24.2/drivers/media/video/usbvideo/usbvideo.c	2008-02-16 23:12:16.000000000 -0800
@@ -1299,6 +1299,9 @@ static int usbvideo_v4l_do_ioctl(struct 
 		case VIDIOCSPICT:
 		{
 			struct video_picture *pic = arg;
+			if (pic->palette
+			    && ((1L << pic->palette) & uvd->paletteBits) == 0)
+				return -EINVAL;
 			/*
 			 * Use temporary 'video_picture' structure to preserve our
 			 * own settings (such as color depth, palette) that we


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
