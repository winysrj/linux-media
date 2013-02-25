Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab3BYWVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Feb 2013 17:21:19 -0500
Date: Mon, 25 Feb 2013 19:20:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sri Deevi <Srinivasa.Deevi@conexant.com>
Cc: Joseph Yasi <joe.yasi@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jay Guillory <Jay.Guillory@conexant.com>,
	Steven Toth <stoth@linuxtv.org>
Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
Message-ID: <20130225192044.662b8a1d@redhat.com>
In-Reply-To: <2590d8e3-a2cc-4fd9-917b-3549ef368195@cnxthub2.bbnet.ad>
References: <CADzA9okNTohmDwxbQNri4y8Gb-=BksugMSiCNaGMzFQXDyLu7g@mail.gmail.com>
	<1361675795.27602.9.camel@deadeye.wl.decadent.org.uk>
	<20130224092216.3627110f@redhat.com>
	<CADzA9okDiHo3reO9+xmEXgvvwSsOQM2U69zpw=AwgkmEXGREPw@mail.gmail.com>
	<c23c2ddc-3edb-42d0-947a-96a89d6e2170@cnxthub2.bbnet.ad>
	<20130225060642.4fcb6f4e@redhat.com>
	<2590d8e3-a2cc-4fd9-917b-3549ef368195@cnxthub2.bbnet.ad>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Feb 2013 08:17:34 -0800
Sri Deevi <Srinivasa.Deevi@conexant.com> escreveu:

> Mauro,
> 
> Are you asking Hauppauge's version of ROM to be distributed with permissions ? 
> Please clarify. 
> 
> If that is the case, I may not be able to do that. 

I've no idea if Hauppauge customized it, or if they just bundled a Conexant
version of it. I suspect it was the last case, but maybe Michael or Steven
may have or check with someone else about the origin of that firmware
(85drv_29272/Driver85/hcw85enc.rom).

Regards,
Mauro

> 
> Michael,
> 
> If you can give me the details of when was the last time you got updates from Conexant, then I can try to help in this regard.
> 
> Thanks
> Sri
> 
> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com] 
> Sent: Monday, February 25, 2013 1:07 AM
> To: Sri Deevi
> Cc: Joseph Yasi; Ben Hutchings; linux-media@vger.kernel.org; David Woodhouse; Palash Bandyopadhyay; Michael Krufky; Andy Walls; Hans Verkuil
> Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
> 
> Em Sun, 24 Feb 2013 20:37:07 -0800
> "Sri Deevi" <Srinivasa.Deevi@conexant.com> escreveu:
> 
> > Mauro and All,
> > 
> > Apologies for delay in reply.
> > 
> > Whatever firmware works keep that one as reference. If you guys think the firmware from Hauppauge is latest, please keep that and I can get the required permissions as needed. 
> > 
> > Please do let me know whatever is the plan. Currently, there are no updates to this firmware as I know.
> 
> David merged yesterday at linux-firmware a patch from Ben that removes this firmware from the tree:
> 
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-enc.fw 
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-enc.fw
> 
> As this firmware is known to not work with the Hauppauge devices.
> 
> The better would be if you could give us permission to redistribute, instead, the firmware found on Hauppauge's site (Windows driver only version there):
> 	http://www.hauppauge.com/site/support/support_hvr1500.html
> With points to:
> 	http://hauppauge.lightpath.net/software/drivers/85drv_29272.zip
> 
> The firmware there is this one:
> 	-rw-rw-r-- 1 mchehab mchehab 376836 Mar 17  2006 85drv_29272/Driver85/hcw85enc.rom
> 	1cb3c48a6684126f5e503a434f2d636b  85drv_29272/Driver85/hcw85enc.rom
> 
> With matches with the one it is known to work with this hardware:
> 
> > > -r--r--r--   1 v4l v4l  376836 Fev 24 08:47 v4l-cx23885-enc.fw
> > > 1cb3c48a6684126f5e503a434f2d636b  v4l-cx23885-enc.fw
> 
> That would fix the main firmware issue.
> 
> Regards,
> Mauro
> 
> 
> > 
> > Thanks
> > Sri
> > 
> > -----Original Message-----
> > From: Joseph Yasi [mailto:joe.yasi@gmail.com]
> > Sent: Sunday, February 24, 2013 8:36 AM
> > To: Mauro Carvalho Chehab
> > Cc: Ben Hutchings; linux-media@vger.kernel.org; David Woodhouse; 
> > Palash Bandyopadhyay; Sri Deevi; Michael Krufky; Andy Walls; Hans 
> > Verkuil
> > Subject: Re: Firmware for cx23885 in linux-firmware.git is broken
> > 
> > On Sun, Feb 24, 2013 at 7:22 AM, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > > Em Sun, 24 Feb 2013 03:16:35 +0000
> > > Ben Hutchings <ben@decadent.org.uk> escreveu:
> > >
> > >> On Fri, 2013-02-22 at 19:30 -0500, Joseph Yasi wrote:
> > >> > Hi,
> > >> >
> > >> > I'm not sure the appropriate list to email for this, but the 
> > >> > v4l-cx23885-enc.fw file in the linux-firmware.git tree is incorrect.
> > >> > It is the wrong size and just a duplicate of the 
> > >> > v4l-cx23885-avcore-01.fw. The correct file can be extracted from 
> > >> > the
> > >> > HVR1800 drivers here: http://steventoth.net/linux/hvr1800/.
> > >>
> > >> This was previously requested
> > >> <http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/57816> but unfortunately it's not clear that it would be legal to redistribute firmware extracted from that driver (or the driver itself).
> > >
> > > (c/c Conexant developers, Andy and Hans)
> > >
> > > Let's see if we can once for all fix this issue. So, let me do a 
> > > summary of the firmware situation here.
> > >
> > > Basically, the firmwares at linux-kernel are the ones that Conexant 
> > > gave us license to re-distribute.
> > >
> > > According with Conexant, there's one firmware that it is the same 
> > > for two different chips. On their words:
> > >
> > >         "The Merlin firmware are the same for 418 and 416/7."
> > >
> > > The envolved Conexant firmwares are the ones used by cx23885-417.c, 
> > > cx231xx-417.c and cx25850.c:
> > >
> > > $ git grep v4l-cx23885-enc.fw drivers/media 
> > > drivers/media/pci/cx23885/cx23885-417.c:#define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
> > > drivers/media/usb/cx231xx/cx231xx-417.c:#define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
> > >
> > > $ grep "define.*FIRM" drivers/media/i2c/cx25840/cx25840-firmware.c
> > > #define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
> > > #define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
> > > #define CX25840_FIRMWARE "v4l-cx25840.fw"
> > >
> > > Those are the Conexant firmware files that we currently have at
> > > linux-firmware:
> > >
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx231xx-avcore-01.fw
> > > -rw-rw-r-- 1 v4l v4l 141200 Ago 10  2012 v4l-cx23418-apu.fw
> > > -rw-rw-r-- 1 v4l v4l 158332 Ago 10  2012 v4l-cx23418-cpu.fw
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23418-dig.fw
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-avcore-01.fw
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx23885-enc.fw
> > > -rw-rw-r-- 1 v4l v4l  16382 Ago 10  2012 v4l-cx25840.fw
> > >
> > > And those are their corresponding md5sum:
> > >
> > > 7d3bb956dc9df0eafded2b56ba57cc42  v4l-cx231xx-avcore-01.fw 
> > > 588f081b562f5c653a3db1ad8f65939a  v4l-cx23418-apu.fw
> > > b6c7ed64bc44b1a6e0840adaeac39d79  v4l-cx23418-cpu.fw
> > > 95bc688d3e7599fd5800161e9971cc55  v4l-cx23418-dig.fw 
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-avcore-01.fw 
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-enc.fw
> > > dadb79e9904fc8af96e8111d9cb59320  v4l-cx25840.fw
> > >
> > > So, yes, v4l-cx23885-avcore-01.fw and v4l-cx23885-enc.fw files are 
> > > identical on the official released firmwares, and both have 16K.
> > >
> > > Now, Hauppauge is using different firmwares for v4l-cx23885-enc.fw 
> > > and v4l-cx23885-avcore-01.fw. After extracting the firmware from 
> > > their zip file, we have:
> > >
> > > -r--r--r--   1 v4l v4l  376836 Fev 24 08:47 v4l-cx23885-enc.fw
> > > -r--r--r--   1 v4l v4l   16382 Fev 24 08:47 v4l-cx23885-avcore-01.fw
> > >
> > > With different checksums:
> > >
> > > b3704908fd058485f3ef136941b2e513  v4l-cx23885-avcore-01.fw 
> > > 1cb3c48a6684126f5e503a434f2d636b  v4l-cx23885-enc.fw
> > >
> > > So:
> > > 1) With regards to the encoder firmware for cx23885-417, both Conexant and
> > >    Hauppauge, provided a firmware with 16KB. Although they're different.
> > >    Not sure if they are just different versions, or if Hauppauge customized
> > >    it on their driver.
> > 
> > FYI, the v4l-cx23885-avcore-01.fw firmware file from the latest Hauppauge driver:
> > http://hauppauge.lightpath.net/software/drivers/85drv_29272.zip is the same as the current one in git:
> > a9f8f5d901a7fb42f552e1ee6384f3bb  v4l-cx23885-avcore-01.fw
> > 
> > but the v4l-cx23885-enc.fw file is still the same larger 372kB file:
> > 1cb3c48a6684126f5e503a434f2d636b  v4l-cx23885-enc.fw
> > 
> > > 2) With regards to the decoder firmware for cx25840 (actually, the
> > >    equivalent IP block inside cx23885), while Conexant provided us with
> > >    a 16KB firmware, and both decoder and encoder using the very same
> > >    firmware, Hauppauge's driver is shipped with a 372KB firmware.
> > >
> > 
> > >> For now, I think we should delete the current version.
> > >
> > > That seems to be the only approach left, if neither Conexant or 
> > > Hauppauge could help solving this dilema.
> > 
> > I agree with removing it from the tree for now. The card doesn't work with the current firmware encoder firmware in tree, and it's annoying to have the working version extracted from the driver overwritten everything a new linux-firmware package is pushed to the Ubuntu repositories.
> > 
> > Thanks,
> > Joe Yasi
> > 
> > Conexant E-mail Firewall (Conexant.Com) made the following annotations
> > ---------------------------------------------------------------------
> > ********************** Legal Disclaimer ****************************
> > 
> > "This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 
> > 
> > **********************************************************************
> > 
> > ---------------------------------------------------------------------
> > 
> 
> 


-- 

Cheers,
Mauro
