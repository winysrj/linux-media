Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34824 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZD3KZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 06:25:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LzTRu-0003kQ-SC
	for linux-media@vger.kernel.org; Thu, 30 Apr 2009 10:25:03 +0000
Received: from 31.210.219.87.dynamic.jazztel.es ([87.219.210.31])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:25:02 +0000
Received: from eduardhc by 31.210.219.87.dynamic.jazztel.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 10:25:02 +0000
To: linux-media@vger.kernel.org
From: Eduard Huguet <eduardhc@gmail.com>
Subject: Re: Nova-T 500 does not survive reboot
Date: Thu, 30 Apr 2009 10:16:27 +0000 (UTC)
Message-ID: <loom.20090430T101124-541@post.gmane.org>
References: <1241068523.4632.8.camel@youkaida>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicolas Will <nico <at> youplala.net> writes:

> 
> Hello all,
> 
> I am running an hg clone from a few days ago with firmware 1.20 on a
> 64-bit Ubuntu Intrepid (2.6.27 kernel).
> 
> I have noticed that for some time now the card/driver/firmware
> combination does not like warm reboots.
> 
> If I reboot the system and try to use any Nova-T 500 tuner, I
> immediately get the mt2060 I2C errors.
> 
> If I completely shut down the system, remove the power, then reboot, all
> is fine.
> 
> I have missed most of the linux-media traffic, I was still stuck on
> linux-dvb. Have I missed some discussions about this?
> 
> Thanks!
> 
> Nico
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hi, Nicholas

I posted the very same thing 3 days ago:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4973


This is something that has been occuring lately, since some months ago. I don't
know when exactly was this bug introduced, but it has been in HG for a couple of
months at least. I can remenber that other guy posted about this issue some time
ago, but I can't find the link.


And for what I see, Janne Grunau is also having problems with the card. See what
he have just posted...:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4973

Best regards, 
  Eduard Huguet



