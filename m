Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:59712 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759357Ab2DYVkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 17:40:13 -0400
Received: from mat-laptop (unknown [81.57.151.96])
	by smtp6-g21.free.fr (Postfix) with ESMTP id D1DBA82250
	for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 23:40:05 +0200 (CEST)
Date: Wed, 25 Apr 2012 23:40:03 +0200
From: matthieu castet <castet.matthieu@free.fr>
To: linux-media@vger.kernel.org
Subject: Fw: tm6000 driver questions
Message-ID: <20120425234003.7b817ae8@mat-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



----- Message Transféré -----

Date: Wed, 25 Apr 2012 10:16:57 -0700
De: Vladimir Kerkez <vkerkez@gmail.com>
À: castet.matthieu@free.fr
Sujet: tm6000 driver questions

> Hello,
> 
> I would like to thank you for your outstanding work on the tm6000
> chipset. Because of you (and many other people) I now have a pal tv
> tuner I can use.
> 
> I just recently bought a mac book pro, how ever most of the drivers
> were not supported under the 3.2 kernel. I pulled down the latestest
> drivers for my Hauppauge 900H from linux tv (tm6000 edition).
> 
> I read the your patch changes that you have made here:
> http://patchwork.linuxtv.org/patch/8968/
> 
> One of the first things I noticed is that the firmware for the tm6000
> loads about 10-12 seconds faster, my tvtime starting at a normal
> speed ( it used to take up to 20 seconds to load ). Im assuming this
> is something you may have patched? If you did thanks so much!
> 
> However I am now running into a issue I never saw before with my
> tm6000 tuner. I noticed that in this new version of the driver the
> channel switching is a lot faster, but it seems to be causing  kernel
> panics. I believe the issues is that the channel switches so fast
> before the tuner gets a signal causing the kernel panic (the usb gets
> bad data and throws and emi).  This always happens when the channel
> is changed.
> 
> Here is a snippet of the kernel panic:
> 
> [ 4760.587553] xc2028 14-0061: xc2028_get_reg 0004 called
> [ 4760.591160] xc2028 14-0061: xc2028_get_reg 0008 called
> *[ 4760.633815] hub 2-0:1.0: port 4 disabled by hub (EMI?),
> re-enabling...* [ 4760.633827] usb 2-4: USB disconnect, device number
> 3 [ 4760.637748] xc2028 14-0061: Device is Xceive 0 version 2.0,
> firmware version 3.6
> [ 4760.637756] xc2028 14-0061: Read invalid device hardware
> information - tuner hung?
> [ 4760.650641] tm6000: IR URB failure: status: -71, length 0
> 
> Have you seen this issue? I would love to fix this and commit it to
> linux tv but, im still uncertain as to what changes need to be made.
> The drivers that do come with the 3.2 kernel work fine but however
> the firmware loading is taking forever (stable though when it is
> running).
> 
> Any information you may have to help me out here would be much
> appreciated. I am not working this weekend and was looking forward to
> take a peak at the driver. I'll let you know where I stand with this
> next week.
> 
> thank you so much for your hard work,
> 
> -Vladimir
