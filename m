Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54430 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZI1SkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 14:40:15 -0400
Received: by fxm18 with SMTP id 18so3900931fxm.17
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 11:40:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090928T201911-109@post.gmane.org>
References: <loom.20090928T201911-109@post.gmane.org>
Date: Mon, 28 Sep 2009 14:40:18 -0400
Message-ID: <829197380909281140p36e632f9le3c6a8c9275fb275@mail.gmail.com>
Subject: Re: em28xx #0: vidioc_s_fmt_vid_cap queue busy
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Dick <dick@mrns.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 28, 2009 at 2:25 PM, Dick <dick@mrns.nl> wrote:
> Hi all,
>
> I'm trying to use my TerraTec Grabby (em2860 using em28xx module, tip v4l-dvb
> sources). Everything works using mplayer.
>
> Now I'd like to use the USB videograbber from gstreamer 0.10.24 but I get the
> following error in dmesg:
>
> em28xx #0: vidioc_s_fmt_vid_cap queue busy
>
> And gstreamer tells me:
> # gst-launch -v v4lsrc
> Setting pipeline to PAUSED ...
> Pipeline is live and does not need PREROLL ...
> ERROR: from element /GstPipeline:pipeline0/GstV4lSrc:v4lsrc0: No supported
> formats found
> Additional debug info:
> gstbasesrc.c(2475): gst_base_src_default_negotiate ():
> /GstPipeline:pipeline0/GstV4lSrc:v4lsrc0:
> This element did not produce valid caps
> ERROR: pipeline doesn't want to preroll.
> Setting pipeline to PAUSED ...
> Setting pipeline to READY ...
> Setting pipeline to NULL ...
> Freeing pipeline ...
>
> Does someone know what might be wrong?
>
> Thanks in advance,
> Dick

I'm not very familiar with gstreamer, but you should probably be using
"v4l2src" instead of "v4lsrc", and you probably need to be specifying
the other parameters such as the video standard, capture width,
height, format, etc.  The man page for gst-launch has some examples
you might want to look at (if you haven't already).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
