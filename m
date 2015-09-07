Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34667 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbbIGL5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Sep 2015 07:57:51 -0400
Date: Mon, 7 Sep 2015 08:57:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ronald Tallent <ron@tallent.ws>
Cc: linux-media@vger.kernel.org
Subject: Re: Call for help: em28xx: new board id [1f4d:1abe]
Message-ID: <20150907085746.4fac0033@recife.lan>
In-Reply-To: <1441583930.27835.25.camel@Amy>
References: <1441567008.5526.8.camel@Amy>
	<20150906165354.7f6f0c96@recife.lan>
	<1441583930.27835.25.camel@Amy>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Sep 2015 18:58:50 -0500
Ronald Tallent <ron@tallent.ws> escreveu:

> Hey Mauro,
> 
> Thanks for the reply. Relieved to know I'm not invisible. =)
> 
> I'm a total noob to linux driver issues, so if I'm  posting this in the
> wrong area, please forgive me. I only posted here because this is where
> linuxtv.org said to go to ask for help. Until now all my hardware has
> just worked. So big thanks to all the people who made that happen! But
> this EasyCap board is kind of kicking my butt.
> 
> You are correct, when I plug this USB device in video capture device is
> not detected and so does not work. As I understand it, all the drivers
> needed to make this Easycap work in linux already exist and are used by
> various forms of Easycap devices already.
> 
> The em2860 USB video bridge chip should be supported by the "em28xx"
> kernel modules, and the Trident SAA7115H chip should be supported by the
> "saa7115" module. My best guess is that the card vendor:product id
> [1f4d:1abe] is simply not "attached" to those drivers or known by those
> drivers so when I plug this USB device in, video drivers are not loaded.
> But my assessment of the situation might be completely off here.
> 
> Couple questions...
> 
> First, if nobody know what to do with the information I've posted, why
> does linuxtv.org/wiki instruct me to post this information here, exactly
> this way? Not a big issue really, just quite confusing.

Feel free to improve the documentation ;)
Just remember that the documentation there should be generic enough for
people having different boards, specially if you're looking into a
generic section of the Wiki.

> Secondly, if all the drivers already exist, what do I need to do to get
> them to "attach" to my hardware? 

Because of two things:

- the USB ID is used to identify the driver that will be used. If
  the driver doesn't know the USB ID, it won't be loaded.

- each hardware is wired on a different way. The saa7113 have 4 different
  video inputs (if I remember correctly). Also, there are several pins used
  on most video hardware called GPIO. They're used to power on and reset the
  other devices. The power on/reset sequence is board-specific.

> Is there some place I can go to learn
> how to do that fairly quickly? Is anyone in this board knowledgeable
> about how that can easily be done? I am competent enough with linux that
> I can perform the steps necessary if I know what those steps are. This
> is new territory for me though.

Wiki is your friend. Also look at other posts on the ML from other
people that had to do the same.

> 
> Any help anyone can offer would be greatly appreciated! =)
> 
> Thanks,
> --Ronald
> 
> 
> 
> On Sun, 2015-09-06 at 16:53 -0300, Mauro Carvalho Chehab wrote:
> > Hi Ronald,
> > 
> > Well, probably nobody knows what to do with that ;)
> > 
> > If I understood well your post, video didn't work, right?
> > 
> > So, either you or someone else with the same hardware as you have would
> > need to make it work and send a patch to the mailing list adding support
> > for this new ID.
> > 
> > Probably, it is just either a GPIO or the video input that it is wrong.
> > In order to fix it, you would either need some help from the manufacturer
> > or to sniff the USB message exchanges from the original driver and check
> > the settings for saa7113 and em28xx. The wiki has some info about how
> > to do it.
> > 
> > Regards,
> > Mauro
> > 
> > 
> > Em Sun, 06 Sep 2015 14:16:48 -0500
> > Ronald Tallent <ron@tallent.ws> escreveu:
> > 
> > > Hi, 
> > > 
> > > This is my third attempt to post this information to mailing list in a
> > > little over a week. Am I invisible? Can nobody see my messages? I have
> > > precisely followed the instructions posted on
> > > linuxtv.org/wiki/index.php/Em28xx_devices#How_to_validate_my_vendor.2Fproduct_id_at_upstream_kernel.3F
> > > trying to get my hardware validated. What else do I need to do?  Can
> > > someone answer please and help me. 
> > > 
> > > Thanks,
> > > --Ronald
> > > 
> > > 
> > > I've tested my USB easycap device (Geniatech iGrabber) in Ubuntu
> > > 14.04.
> > > 
> > > Make: Geniatech
> > > Model: iGrabber for MAC
> > > Vendor/Product ID: [1f4d:1abe]
> > > Product website: www.geniatech.com/pa/igrabber.asp
> > > 
> > > Tests Made:
> > > - Audio Capture [worked]
> > > - Video Capture [device not detected]
> > > - DVB [does not have DVB]
> > > 
> > > Tested by:
> > > ron@tallent.ws
> > > 
> > > 
> > > Detailed information on device and system below for reference:
> > > 
> > > uname -a:
> > > 3.13.0-62-generic #102-Ubuntu SMP Tue Aug 11 14:29:36 UTC 2015 x86_64 
> > > x86_64 x86_64 GNU/Linux
> > > 
> > > dmesg:
> > > [] usb 3-3.3: new high-speed USB device number 8 using xhci_hcd
> > > [] usb 3-3.3: New USB device found, idVendor=1f4d, idProduct=1abe
> > > [] usb 3-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> > > [] usb 3-3.3: Product: USB Device
> > > [] usbcore: registered new interface driver snd-usb-audio
> > > 
> > > lsusb:
> > > Bus 003 Device 008: ID 1f4d:1abe G-Tek Electronics Group 
> > > 
> > > Hardware: 
> > > Opened the case and found the following text printed on the board:
> > >    HandyCap
> > >    v1.51
> > >    2007-4-24
> > > 
> > > Three chips on board are:
> > > 1: empia
> > >    EM2860
> > >    P8367-010
> > >    201036-01AG
> > > 
> > > 2: Trident
> > >    SAA7113H
> > >    C2P409.00 02
> > >    A5G11152
> > > 
> > > 3: eMPIA
> > >    Technology
> > >    EMP202
> > >    UT11958
> > >    1027
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
