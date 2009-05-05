Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56565 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZEENYl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 09:24:41 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M1KdN-0008Bu-PW
	for linux-media@vger.kernel.org; Tue, 05 May 2009 13:24:33 +0000
Received: from 141.Red-80-39-79.staticIP.rima-tde.net ([80.39.79.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 May 2009 13:24:33 +0000
Received: from eduardhc by 141.Red-80-39-79.staticIP.rima-tde.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 05 May 2009 13:24:33 +0000
To: linux-media@vger.kernel.org
From: Eduard Huguet <eduardhc@gmail.com>
Subject: Re: Nova-T 500 does not survive reboot
Date: Tue, 5 May 2009 13:24:22 +0000 (UTC)
Message-ID: <loom.20090505T132219-451@post.gmane.org>
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

Hi, 
   Any news on this? I'd like to try the URB patch someone mentioned, but I
can't find the link.

Best regards, 
  Eduard




