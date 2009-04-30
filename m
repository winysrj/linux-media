Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:36824 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZD3KsN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 06:48:13 -0400
Received: from [134.32.138.73] (unknown [134.32.138.73])
	by mail.youplala.net (Postfix) with ESMTPSA id 0797BD880AC
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 12:48:00 +0200 (CEST)
Subject: Re: Nova-T 500 does not survive reboot
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <loom.20090430T101124-541@post.gmane.org>
References: <1241068523.4632.8.camel@youkaida>
	 <loom.20090430T101124-541@post.gmane.org>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 11:47:18 +0100
Message-Id: <1241088438.5237.16.camel@acropora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-04-30 at 10:16 +0000, Eduard Huguet wrote:
> Nicolas Will <nico <at> youplala.net> writes:
> 
> > 
> > Hello all,
> > 
> > I am running an hg clone from a few days ago with firmware 1.20 on a
> > 64-bit Ubuntu Intrepid (2.6.27 kernel).
> > 
> > I have noticed that for some time now the card/driver/firmware
> > combination does not like warm reboots.
> > 
> > If I reboot the system and try to use any Nova-T 500 tuner, I
> > immediately get the mt2060 I2C errors.
> > 
> > If I completely shut down the system, remove the power, then reboot, all
> > is fine.
> > 
> > I have missed most of the linux-media traffic, I was still stuck on
> > linux-dvb. Have I missed some discussions about this?
> > 
> > Thanks!
> > 
> > Nico
> Hi, Nicholas
> 
> I posted the very same thing 3 days ago:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4973

Argh, I missed it (I don't really like gmame's archiving... I will need
to get used to it).

I have the same :


Apr 29 22:42:41 favia kernel: [   72.272045] ehci_hcd 0000:07:01.2: force halt; handhake ffffc20000666814 00004000 00000000 -> -110


then


Apr 29 22:43:02 favia kernel: [   92.900094] mt2060 I2C write failed
Apr 29 22:43:02 favia kernel: [   92.905830] mt2060 I2C write failed (len=2)
Apr 29 22:43:02 favia kernel: [   92.905835] mt2060 I2C write failed (len=6)
Apr 29 22:43:02 favia kernel: [   92.905838] mt2060 I2C read failed
Apr 29 22:43:02 favia kernel: [   92.912552] mt2060 I2C read failed
Apr 29 22:43:02 favia kernel: [   92.920572] mt2060 I2C read failed
Apr 29 22:43:02 favia kernel: [   92.928552] mt2060 I2C read failed
Apr 29 22:43:02 favia kernel: [   92.936554] mt2060 I2C read failed
Apr 29 22:43:02 favia kernel: [   92.944552] mt2060 I2C read failed
...............

and at one point I get the following before I shut down


Apr 29 22:44:27 favia kernel: [  177.818215] dvb-usb: could not submit URB no. 0 - get them all back
Apr 29 22:44:27 favia kernel: [  177.818222] dvb-usb: error while enabling fifo.




> 
> 
> This is something that has been occuring lately, since some months ago. I don't
> know when exactly was this bug introduced, but it has been in HG for a couple of
> months at least. I can remenber that other guy posted about this issue some time
> ago, but I can't find the link.


I'm with that too. I was just really busy at the time to dig into it.



> 
> 
> And for what I see, Janne Grunau is also having problems with the card. See what
> he have just posted...:
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4973


I saw that one too, it arrived as I subscribed to the proper list.

I'm not directly concerned now, but I will be facing this too when I
will want to upgrade my system to the current Ubuntu release.


Soooooo...

What can I/we do to help track/fix this?

I'm game for a bit of testing, within reason, though, at the system is
in production.

Do you know if the issue is the same with a Nova-TD stick? If it is,
then I could be able to use debugging as an excuse to buy one, and then
add 2 tuners to the system when all is done :o)

Nico
http://www.youplala.net/linux/home-theater-pc/

