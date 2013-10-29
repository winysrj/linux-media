Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab3J2OeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 10:34:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VbAMu-000735-GI
	for linux-media@vger.kernel.org; Tue, 29 Oct 2013 15:34:04 +0100
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Oct 2013 15:34:04 +0100
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 29 Oct 2013 15:34:04 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: ov3640 driver tested with media-ctl and yavta
Date: Tue, 29 Oct 2013 14:33:42 +0000 (UTC)
Message-ID: <loom.20131029T144420-408@post.gmane.org>
References: <loom.20131009T122055-332@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tom <Bassai_Dai <at> gmx.net> writes:

> 
> Hello,
> I tried to use the ov3640 camera driver from Laurent Pinchart with the
> media-ctl and the yavta tools. I configured the pipeline as sensor -> ccdc
> ->memory. First I got problems with the CCDC module. it always said that the
> "ccdc won't become idle!", but it didn't restart by itself. So for testing I
> removed the waiting function which waits for the ccdc to become idle and
> tried again. Now I received some data from the buffers but the image is just
> black.
> Any idea what my problem could be?
> 
> Best Regards, Tom
> 
> 


Hello,

I still have the problem that I don't receive any image data when the
waiting function is commented in. I just get the "ccdc won't become idle"
output. when this function is commented out and the polarities within the
board-overo.c file are correct. I get some image data on which I can see the
right structure but wrong colors. 

Does anyone have an idea what the problem could be when the color is incorrect?

http://imageshack.us/photo/my-images/707/wkjf.png/

Regrads, Tom




