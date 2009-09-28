Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:53781 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZI1SfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 14:35:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MsL3v-0002uH-8Y
	for linux-media@vger.kernel.org; Mon, 28 Sep 2009 20:35:03 +0200
Received: from j215101.upc-j.chello.nl ([24.132.215.101])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 20:35:03 +0200
Received: from dick by j215101.upc-j.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 20:35:03 +0200
To: linux-media@vger.kernel.org
From: Dick <dick@mrns.nl>
Subject: em28xx #0: =?utf-8?b?dmlkaW9jX3NfZm10X3ZpZF9jYXA=?= queue busy
Date: Mon, 28 Sep 2009 18:25:01 +0000 (UTC)
Message-ID: <loom.20090928T201911-109@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm trying to use my TerraTec Grabby (em2860 using em28xx module, tip v4l-dvb
sources). Everything works using mplayer.

Now I'd like to use the USB videograbber from gstreamer 0.10.24 but I get the
following error in dmesg:

em28xx #0: vidioc_s_fmt_vid_cap queue busy

And gstreamer tells me:
# gst-launch -v v4lsrc
Setting pipeline to PAUSED ...
Pipeline is live and does not need PREROLL ...
ERROR: from element /GstPipeline:pipeline0/GstV4lSrc:v4lsrc0: No supported
formats found
Additional debug info:
gstbasesrc.c(2475): gst_base_src_default_negotiate ():
/GstPipeline:pipeline0/GstV4lSrc:v4lsrc0:
This element did not produce valid caps
ERROR: pipeline doesn't want to preroll.
Setting pipeline to PAUSED ...
Setting pipeline to READY ...
Setting pipeline to NULL ...
Freeing pipeline ...

Does someone know what might be wrong?

Thanks in advance,
Dick

