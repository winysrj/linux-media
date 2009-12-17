Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.london.02.net ([82.132.130.150]:33127 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765418AbZLQVol (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 16:44:41 -0500
Received: from mansell (82.132.130.219) by mail.o2.co.uk (8.0.013.3) (authenticated as sijones2006)
        id 4AF809CF0A0BD368 for linux-media@vger.kernel.org; Thu, 17 Dec 2009 21:44:40 +0000
Message-ID: <26868954.256771261086280478.JavaMail.defaultUser@defaultHost>
Date: Thu, 17 Dec 2009 21:44:40 +0000 (GMT)
From: <sijones2006@o2.co.uk>
Reply-To: <sijones2006@o2.co.uk>
To: <linux-media@vger.kernel.org>
Subject: Re: Cinergy 2400i - Micronas APB 7202A Open Sourced!
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


sijones2006@o2.co.uk writes:
> 
>
> The PCI-e bridge (MICRONAS APB 7202A) has now an open source 
> driver. 
>
> It is available here git://projects.vdr-developer.org/mediapointer-
> dvb-
>
> s2.git 
>
> could this now be pulled into the main V4L source? as it has been 
>
> brought upto date with the current DVB tree.
> 
>
>The driver cannot be pulled in 'as is' for various reasons, but we 
> are
>
>currently preparing the driver to make it ready for inclusion into 
> the
>
>master HG repository/kernel.
> 
> Is there a repository that I can use to build / test this? and is 
the 
> tuner supported as well??

>I am not sure about the git repo but the original release included
drivers for the cards on the market (dual DVBS2 by DigitalDevices, 
Terratec Cinergy and an ATSC card) and all prototype cards.
Since most of the driver was written in 2005 it is a little 
"behind" regarding kernel API changes and available in-kernel drivers 
for 
tuners and demods. But you should be able to get hints from it
to adapt it to the current kernel/DVB repo. 


Thanks for your reply, when I looked through the original source code 
I can't see a driver for the tuner THOMSON DTT 75202A, is included in 
the code but named something else?

When I load the ngene module, should it say anything more than the 
copyright notice in the kernel logs?
