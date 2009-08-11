Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:54971 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZHKNTJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 09:19:09 -0400
Received: from [10.11.11.141] (host81-151-5-7.range81-151.btcentralplus.com [81.151.5.7])
	by mail.youplala.net (Postfix) with ESMTPSA id 89F7DD880C7
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 15:12:05 +0200 (CEST)
Subject: Re: [linux-dvb] problem: Hauppauge Nova TD500
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <4A8169D0.3030008@dockerz.net>
References: <4A8169D0.3030008@dockerz.net>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 14:11:54 +0100
Message-Id: <1249996315.30127.3.camel@youkaida>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-08-11 at 13:53 +0100, Tim Docker wrote:
> Hi,
> 
> I'm trying to diagnose a problem with a mythtv setup based upon a 
> hauppauge nova td 500. I've had the setup for some months - it seemed
> to 
> work reasonably reliably initially, but over the last few weeks I've
> had 
> consistent problems with the tuner card entering a state where it is 
> unable to receive a signal. I was seeing multiple errors via dmesg of 
> the form:
> 
> [27317.617958] DiB0070 I2C write failed
> 
> Web trawling suggested that this could be resolved with an updated 
> driver - I did this yesterday, with the latest version from
> mercurial, 
> obtained and built as per the instructions here:
> 
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers 
> 
> 
> I installed this over the top of the 2.6.27-14-generic kernel from
> the 
> mythbuntu distribution, and manually installed the 1.20 firmware.
> 
> In 24 uptime hours I haven't seen any I2C errors, but unfortunately,
> it 
> has still entered some state where I can't received a signal. 
> Mysteriously, there doesn't appear to be any relevant errors or
> messages 
> in dmesg. From the log snippet below, you can see that no signal is 
> being returned by tzap, but if I unload and reload the modules, 
> everything comes back to life.
> 
> I'd really appreciate any tips or pointers on what might be going
> wrong 
> here.

This problem is most probably caused by the tuner being in USB suspend
when MythTV wants to use it too quickly.

Either disable usb suspend in your kernel, or tell mythtv to take wait
some more before tuning.

I told MythTV to wait some more, and all is fine.

http://www.youplala.net/linux/home-theater-pc#toc-not-losing-one-of-the-nova-t-500s-tuners

Nico


