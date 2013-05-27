Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41869 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab3E0XVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 19:21:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Uh6j0-0000aF-3C
	for linux-media@vger.kernel.org; Tue, 28 May 2013 01:21:10 +0200
Received: from 5ad012fd.bb.sky.com ([5ad012fd.bb.sky.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 01:21:10 +0200
Received: from alxgomz by 5ad012fd.bb.sky.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 01:21:10 +0200
To: linux-media@vger.kernel.org
From: alxgomz <alxgomz@gmail.com>
Subject: Re: EM28xx - new device ID - Ion "Video Forever" USB capture dongle
Date: Mon, 27 May 2013 23:20:54 +0000 (UTC)
Message-ID: <loom.20130528T010242-622@post.gmane.org>
References: <51A1D475.5000106@philpem.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philip,

Thank you for sharing this bit of info. I just bought what I think to be the
very same device from local maplin too.
I have loaded it using your tweak.
Just like you the composite video input works just great, however I can't
get any sound captured using the RCA audio leads. 
The S-video doesn't work either :( (only one new v4l2 video source is
registred loading the device driver). 

I have done all my test using ffmpeg (and arecord to test audio only) but I
am quite confident the outcome would be the same with other programs.

When loading the driver with card=9, I can see in the log:

"em2860 #0: Sigmatel audio processor detected(stac 9752)"

I wonder how much "detection" there is here under the hood, as I suspect the
module param may have forced this (wrongly perhaps).
So as far as I am concerned, this ion thingy doesn't match exactly, the 9 card.
How can I gather more informations about that device?

Regards Alex.

