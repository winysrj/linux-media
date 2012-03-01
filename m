Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50472 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab2CAGrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 01:47:16 -0500
Received: by pbcup15 with SMTP id up15so522147pbc.19
        for <linux-media@vger.kernel.org>; Wed, 29 Feb 2012 22:47:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 29 Feb 2012 23:41:50 -0700
Message-ID: <CAOQJi0jWyz3toed1veDhCRPDQqnrgBKg6uooifGwTPPscR33nQ@mail.gmail.com>
Subject: audio is not working
From: Steven Dahlin <linux.sldahlin@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am running an athlon ii 945 with a hauppauge wintv 1600 capture
card.  I have a version of mythtv installed (0.24) in which I
downloaded the latest V4L-DVB Device Drivers from
git://linuxtv.org/media_build.git, built them, and then installed.
Everything is up to date with the software packages.  The video
records perfectly fine but the audio is missing.  The backend log has
the following indicators of problems:

2012-02-29 22:30:28.722 AFD Warning: ScanATSCCaptionStreams() called with no PMT
2012-02-29 22:30:28.763 AFD: Opened codec 0x7f7180007f30,
id(MPEG2VIDEO) type(Video)
2012-02-29 22:30:28.797 AFD: codec MP2 has 2 channels
2012-02-29 22:30:28.830 AFD: Opened codec 0x7f718000abe0, id(MP2) type(Audio)
2012-02-29 22:30:28.951 [mpeg2video @ 0x7f719986c700]warning: first
frame is no keyframe
2012-02-29 22:30:29.016 [mpeg2video @ 0x7f719986c700]warning: first
frame is no keyframe
2012-02-29 22:35:12.770 [mpeg2video @ 0x7f719986c700]00 motion_type at 28 10
2012-02-29 22:35:12.815 [mpeg2video @ 0x7f719986c700]Warning MVs not available
2012-02-29 22:35:12.859 [mp2 @ 0x7f719986c700]incomplete frame
2012-02-29 22:35:12.899 AFD Error: Unknown audio decoding error

In the syslog I am seeing entries (a log of them) like this:

Feb 29 22:29:56 bifrosttv kernel: [ 1154.739451] cx18-0: Skipped
encoder IDX, MDL 442, 2 times - it must have dropped out of rotation
Feb 29 22:29:56 bifrosttv kernel: [ 1154.739459] cx18-0: Skipped
encoder IDX, MDL 443, 2 times - it must have dropped out of rotation
Feb 29 22:29:56 bifrosttv kernel: [ 1154.739465] cx18-0: Skipped
encoder IDX, MDL 444, 2 times - it must have dropped out of rotation
Feb 29 22:29:56 bifrosttv kernel: [ 1154.739472] cx18-0: Could not
find MDL 438 for stream encoder IDX
Feb 29 22:29:56 bifrosttv kernel: [ 1154.739478] cx18-0: Could not
find MDL 441 for stream encoder IDX
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736285] cx18-0: Skipped
encoder IDX, MDL 444, 1 times - it must have dropped out of rotation
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736325] cx18-0: Could not
find MDL 441 for stream encoder IDX
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736335] cx18-0: Could not
find MDL 442 for stream encoder IDX
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736431] cx18-0: Could not
find MDL 443 for stream encoder IDX
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736437] cx18-0: Could not
find MDL 444 for stream encoder IDX
Feb 29 22:30:00 bifrosttv kernel: [ 1158.736475] cx18-0: Could not
find MDL 442 for stream encoder IDX

Does anyone have suggestions or ideas I can try?
