Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantva.canterbury.ac.nz ([132.181.2.27]:3947 "EHLO
	cantva.canterbury.ac.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2EPBsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 21:48:32 -0400
Received: from CONVERSION-DAEMON.it.canterbury.ac.nz by it.canterbury.ac.nz
 (PMDF V6.5-x6 #31943) id <01OFJTVWUHJ4AOM9GD@it.canterbury.ac.nz> for
 linux-media@vger.kernel.org; Wed,
 16 May 2012 12:26:57 +1200 (NEW ZEALAND STANDARD TIME)
Date: Wed, 16 May 2012 12:26:43 +1200
From: Simon Knopp <simon.knopp@pg.canterbury.ac.nz>
Subject: Status of gstreamer video capture/encoding
To: "General mailing list for gumstix users."
	<gumstix-users@lists.sourceforge.net>, linux-media@vger.kernel.org
Message-id: <497D0E3C-3068-4E0C-AE16-625323D66402@pg.canterbury.ac.nz>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am trying to understand the current state of video capture and encoding using gstreamer for kernels >= 2.6.39 on an OMAP3530. 

Currently on 2.6.34 (omap3-2.6.34-caspapx) I use essentially:
	v4l2src ! TIVidenc1 codecName=h264enc ! rtph264pay ! udpsink

1)  As far as I understand, 'yavta' is currently the only way to capture from media-ctl-based cameras -- gstreamer's v4l2src doesn't work for these cameras. Is this correct? 

2)  I have read that 'subdevsrc' or 'mcsrc' is capable of doing this [1], though I'm not sure whether they're somehow meego-specific. Has anyone tried these source elements on a Gumstix Overo? 

3)  As far as using the DSP for encoding video, Last I heard no one had done it yet [2]. Has anyone had success with either 'gst-ti', 'gst-dsp', or 'gst-openmax' [3,4,5] on 3.x kernels? 

Thanks in advance,
Simon.


[1]: http://www.spinics.net/lists/linux-media/msg41227.html
[2]: http://gumstix.8.n6.nabble.com/Caspa-Camera-on-2-6-39-Kernel-tp571619p4557013.html
[3]: http://processors.wiki.ti.com/index.php/GstTIPlugin_Elements#TIVidenc1
[4]: http://code.google.com/p/gst-dsp/
[5]: http://freedesktop.org/wiki/GstOpenMAX

