Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34893 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab3FAQT1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Jun 2013 12:19:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UioWb-0006Jp-Fe
	for linux-media@vger.kernel.org; Sat, 01 Jun 2013 18:19:25 +0200
Received: from 0278aee8.bb.sky.com ([0278aee8.bb.sky.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 01 Jun 2013 18:19:25 +0200
Received: from alxgomz by 0278aee8.bb.sky.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 01 Jun 2013 18:19:25 +0200
To: linux-media@vger.kernel.org
From: alxgomz <alxgomz@gmail.com>
Subject: Re: EM28xx - new device ID - Ion "Video Forever" USB capture dongle
Date: Sat, 1 Jun 2013 16:19:09 +0000 (UTC)
Message-ID: <loom.20130601T174621-733@post.gmane.org>
References: <51A1D475.5000106@philpem.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So latest news... It seems this USB dongle actually has an EM202 audio
processor instead of the Sigmatel reported in the logs.
I edited em28xx_audio_setup in em28xx-core.c accordingly and I can now
capture audio using the composite interfaces.
However joy didn't last really long as I soon realised audio capture didn't
worked as soon as I did open the video device at the same time.

To summarize:

ffmpeg -f v4l2 -i /dev/video1 /tmp/test.avi --> Works
ffmpeg -f alsa -i hw:1 /tmp/test/wav --> Works
ffmpeg -f v4l2 -i /dev/video1 -f alsa -i hw:1 /tmp/test.avi --> video OK but
no Audio

Regarding the S-Video that doesn't work I think it's just a matter of card
definition in em28xx-cards.c.... I will give a try several combination, nad
possibly update the wiki in case I end up to a satisfactory result.

In any case I'd be happy to have any insight regarding the problem when
audio doesn't work if video device is accessed at the same time.

