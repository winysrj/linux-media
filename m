Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab3DAOUU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:20:20 -0400
Message-ID: <51599877.2050801@redhat.com>
Date: Mon, 01 Apr 2013 16:23:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] xawtv: release buffer if it can't be displayed
References: <201303301047.41952.hverkuil@xs4all.nl> <51583081.4000806@redhat.com> <201304011219.30985.hverkuil@xs4all.nl>
In-Reply-To: <201304011219.30985.hverkuil@xs4all.nl>
Content-Type: multipart/mixed;
 boundary="------------080700000301000503050402"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080700000301000503050402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 04/01/2013 12:19 PM, Hans Verkuil wrote:
> Hi Hans,
>
> On Sun March 31 2013 14:48:01 Hans de Goede wrote:
>> Hi,
>>
>> On 03/30/2013 10:47 AM, Hans Verkuil wrote:
>>> This patch for xawtv3 releases the buffer if it can't be displayed because
>>> the resolution of the current format is larger than the size of the window.
>>>
>>> This will happen if the hardware cannot scale down to the initially quite
>>> small xawtv window. For example the au0828 driver has a fixed size of 720x480,
>>> so it will not display anything until the window is large enough for that
>>> resolution.
>>>
>>> The problem is that xawtv never releases (== calls QBUF) the buffer in that
>>> case, and it will of course run out of buffers and stall. The only way to
>>> kill it is to issue a 'kill -9' since ctrl-C won't work either.
>>>
>>> By releasing the buffer xawtv at least remains responsive and a picture will
>>> appear after resizing the window. Ideally of course xawtv should resize itself
>>> to the minimum supported resolution, but that's left as an exercise for the
>>> reader...
>>>
>>> Hans, the xawtv issues I reported off-list are all caused by this bug and by
>>> by the scaling bug introduced recently in em28xx. They had nothing to do with
>>> the alsa streaming, that was a red herring.
>>
>> Thanks for the debugging and for the patch. I've pushed the patch to
>> xawtv3.git. I've a 2 patch follow up set which should fix the issue with being
>> able to resize the window to a too small size.
>>
>> I'll send this patch set right after this mail, can you test it with the au0828
>> please?
>
> I've tested it and it is not yet working. I've tracked it down to video_gd_configure
> where it calls ng_ratio_fixup() which changes the cur_tv_width of 736 to 640. The
> height remains the same at 480.

Thanks for testing and for figuring out where the problem lies. I've attached a
second version of the second patch, can you give that a try please?

Thanks,

Hans

--------------080700000301000503050402
Content-Type: text/x-patch;
 name="0001-xawtv-Limit-minimum-window-size-to-minimum-capture-r.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-xawtv-Limit-minimum-window-size-to-minimum-capture-r.pa";
 filename*1="tch"

>From 1628ca8cddcd213abd16c20ad847072e6446976c Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 31 Mar 2013 14:41:17 +0200
Subject: [PATCH] xawtv: Limit minimum window size to minimum capture
 resolution

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 x11/xawtv.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/x11/xawtv.c b/x11/xawtv.c
index bade35a..37afcb6 100644
--- a/x11/xawtv.c
+++ b/x11/xawtv.c
@@ -1636,7 +1636,7 @@ create_launchwin(void)
 int
 main(int argc, char *argv[])
 {
-    int            i;
+    int            i, min_width, min_height;
     unsigned long  freq;
 
     hello_world("xawtv");
@@ -1784,11 +1784,18 @@ main(int argc, char *argv[])
     XSetWMProtocols(XtDisplay(app_shell), XtWindow(app_shell),
 		    &WM_DELETE_WINDOW, 1);
 
+    drv->get_min_size(h_drv, &min_width, &min_height);
+    ng_ratio_fixup2(&min_width, &min_height, NULL, NULL,
+                    ng_ratio_x, ng_ratio_y, True);
+    min_width  = ((min_width + (WIDTH_INC - 1)) / WIDTH_INC) * WIDTH_INC;
+    min_height = ((min_height + (HEIGHT_INC - 1)) / HEIGHT_INC) * HEIGHT_INC;
+    if (debug)
+	fprintf(stderr,"main: window min size %dx%d\n", min_width, min_height);
     XtVaSetValues(app_shell,
 		  XtNwidthInc,  WIDTH_INC,
 		  XtNheightInc, HEIGHT_INC,
-		  XtNminWidth,  WIDTH_INC,
-		  XtNminHeight, HEIGHT_INC,
+		  XtNminWidth,  min_width,
+		  XtNminHeight, min_height,
 		  NULL);
     if (f_drv & CAN_TUNE)
 	XtVaSetValues(chan_shell,
-- 
1.8.1.4


--------------080700000301000503050402--
