Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35071 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbLRMZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 07:25:41 -0500
Received: by mail-wm0-f48.google.com with SMTP id l126so62044875wml.0
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 04:25:41 -0800 (PST)
Subject: Re: problem with coda when running qt-gstreamer and video reaches its
 end (resending in plain text)
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
References: <5671618A.5000300@elfin.de> <5671627C.8020205@elfin.de>
 <1450277389.3421.53.camel@pengutronix.de>
 <1450302584.6121.31.camel@collabora.com>
Cc: linux-media@vger.kernel.org
From: Piotr Lewicki <piotr.lewicki@elfin.de>
Message-ID: <5673FB43.3040303@elfin.de>
Date: Fri, 18 Dec 2015 13:25:39 +0100
MIME-Version: 1.0
In-Reply-To: <1450302584.6121.31.camel@collabora.com>
Content-Type: multipart/mixed;
 boundary="------------010005050501000104030506"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010005050501000104030506
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Thank you,
I updated GStreamer to version 1.6.1 and applied patches from Nicolas 
(https://bugzilla.gnome.org/show_bug.cgi?id=733864).
This resolved the issue witch "CODA PIC_RUN timeout".

At the moment situation looks a little bit different:
1. Playing flv videos (video codec: Sorenson Spark Video) allows me to 
play multiple videos and EOS message is received.

2. Playing h264 videos with lower resolution runs smoothly (no CODA 
PIC_RUN timeout) but when video reaches it's end - no message is 
reaching the qt application and thus I can only stop it manually.
* Is there a resolution of this problem with missing end-of-stream 
detection?

3. When playing h264 videos in HD resolution (tested with 
big_buck_bunny_1080p_h264.mov) the problem with "CODA PIC_RUN timeout" 
still occurs with small difference - when I press STOP "CODA PIC_RUN 
timeout" messages don't show up anymore while before they were showing 
up repeatedly (every second) until my qt application stopped.
- Another strange behaviour is that after I get "coda 2040000.vpu: 
failed to allocate bitstream ringbuffer" message -> the video starts 
running again (when I press PLAY) and it starts detecting end-of-stream 
(!) - see attached file

> > # [ 3049.161708] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> > # "Failed to allocate required memory."
>
> That shouldn't happen anymore in recent kernels. In the past, repeated
> reqbufs calls would leak buffers because the cleanup was only done on
> close.

Dear Phillip,
Unfortunately I'm using i.MX6 device so kernel provided by Freescale is 
v3.14 and I am using kernel provided by Phytec company which is based on 
mainline but the newest version is 3.19 and I cannot upgrade it.

I have already came upon some patches you provided:
starting with 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg77439.html 
and another pack starting with 
http://www.spinics.net/lists/linux-media/msg91575.html
but I think that some of these are dependent on other components like 
e.g. "[PATCH 07/10] [media] coda: drop custom list of pixel format 
descriptions".

* Is there a possibility for you to give me a list of patches to apply 
(and maybe dependent packages) so I can try to apply them manually?
I hope it's not too much too ask..

Best regards
Piotr Lewicki

On 16.12.2015 22:49, Nicolas Dufresne wrote:
> Le mercredi 16 décembre 2015 à 15:49 +0100, Philipp Zabel a écrit :
>>> # [ 1382.828875] coda 2040000.vpu: CODA PIC_RUN timeout
>>> # [ 1383.938704] coda 2040000.vpu: CODA PIC_RUN timeout
>>>   
>>> The video is stopped but I can see last frame on the screen although in
>>> qt application it should receive end-of-stream message and stop the
>>> video (resulting with black screen).
>> Looks like the coda driver is constantly fed empty buffers, which don't
>> increase the bitstream payload level, and the PIC_RUN times out with a
>> bitstream buffer underflow. What GStreamer version is this?
> I believe this is side effect of how the MFC driver worked in it's
> early stage. We had to keep pushing empty buffer to drain the driver.
> So GStreamer still poll/queue/poll/queue/... until all capture buffers
> are received. I notice recently that this behaviour can induce high CPU
> load with some other drivers that don't do any active wait when a empty
> buffer is queued. I would therefor suggest to change this code to only
> push one empty buffer for your use case. An submitted patch to support
> CMD_STOP can be found here, though is pending a re-submition by it's
> author.
>
> https://bugzilla.gnome.org/show_bug.cgi?id=733864
>
> For proper EOS detection with CODA driver (using EPIPE return value),
> you indeed need GStreamer 1.6+.
>
> cheers,
> Nicolas


--------------010005050501000104030506
Content-Type: text/x-log;
 name="2015-12-18-run_1080p_h264.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2015-12-18-run_1080p_h264.log"

root@phyflex-imx6-2:~# qmlplayer2 file:///.videos/big_buck_bunny_1080p_h264.mov 
QML debugging is enabled. Only use this in a safe environment.ny_1080p_h264.mov  
QEglFSImx6Hooks will set environment variable FB_MULTI_BUFFER=2 to enable double buffering and vsync.
 If this is not desired, you can override this via: export QT_EGLFS_IMX6_NO_FB_MULTI_BUFFER=1
Unable to query physical screen size, defaulting to 100 dpi.
To override, set QT_QPA_EGLFS_PHYSICAL_WIDTH and QT_QPA_EGLFS_PHYSICAL_HEIGHT (in millimeters).
** PLAY **
** video runs **
[ 2022.118671] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2023.118647] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2024.118645] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2025.118730] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2026.118638] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2027.118640] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2028.118723] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2029.118641] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2030.118638] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2031.118582] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2032.118651] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2033.118576] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2034.118582] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2035.118597] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2036.118632] coda 2040000.vpu: CODA PIC_RUN timeout
** STOP and PLAY **
** video runs **
[ 2446.438666] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2447.438753] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2448.438686] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2449.438733] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2450.438644] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2451.438730] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2452.438730] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2453.438728] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2454.438726] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2455.438732] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2456.438644] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2457.438569] coda 2040000.vpu: CODA PIC_RUN timeout
[ 2458.438656] coda 2040000.vpu: CODA PIC_RUN timeout
** STOP and PLAY **
** video not running **
[ 2461.043521] coda 2040000.vpu: Failed to allocate fb5 buffer of size 3655680
[ 2461.054544] coda 2040000.vpu: failed to allocate framebuffers
** STOP and PLAY **
** video not running **
[ 2560.075008] coda 2040000.vpu: Failed to allocate fb1 buffer of size 3655680
[ 2560.082640] coda 2040000.vpu: failed to allocate framebuffers
** STOP and PLAY **
** video not running **
[ 2569.879861] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
[ 2569.886931] coda 2040000.vpu: Failed to allocate slicebuf buffer of size 3264512
[ 2569.894399] coda 2040000.vpu: failed to allocate 0 byte slice buffer
** STOP and PLAY **
[ 2574.797829] coda 2040000.vpu: failed to allocate bitstream ringbuffer
** video runs **
>MessageEos
Reached end of stream. Playing next!
about to play  "file:///.videos/big_buck_bunny_1080p_h264.mov"
coda 2040000.vpu: failed to allocate bitstream ringbuffer
** video runs **
>MessageEos
Reached end of stream. Playing next!
about to play  "file:///.videos/big_buck_bunny_1080p_h264.mov"
[ 3768.749155] coda 2040000.vpu: failed to allocate bitstream ringbuffer
** video runs **
>MessageEos
Reached end of stream. Playing next!
about to play  "file:///.videos/big_buck_bunny_1080p_h264.mov"
coda 2040000.vpu: failed to allocate bitstream ringbuffer



--------------010005050501000104030506--
