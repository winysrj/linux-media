Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0G4EILt000664
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 23:14:18 -0500
Received: from cnc.isely.net (cnc.isely.net [64.81.146.143])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0G4E4Qv016766
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 23:14:05 -0500
Date: Thu, 15 Jan 2009 22:14:03 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0901151803l7402174dr410f9368158e9579@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901152156530.19203@cnc.isely.net>
References: <20090115163348.5da9932a@tuvok>
	<09CD2F1A09A6ED498A24D850EB10120817E30B7506@Colmatec004.COLMATEC.INT>
	<20090115175121.25c4bdaa@tuvok> <496FB713.5020609@draigBrady.com>
	<20090115235511.1ea5fdd5@tuvok>
	<d9def9db0901151540y21f05a9ey5d937256f0fb80ae@mail.gmail.com>
	<20090116012721.415902aa@tuvok>
	<d9def9db0901151659s462aa0a9ke8ab769eaa741f36@mail.gmail.com>
	<20090116025554.566bdb92@tuvok>
	<d9def9db0901151803l7402174dr410f9368158e9579@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Video4Linux list <video4linux-list@redhat.com>
Subject: Re: How to identify USB-video-devices
Reply-To: Mike Isely <isely@pobox.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 16 Jan 2009, Markus Rechberger wrote:

> On Fri, Jan 16, 2009 at 2:55 AM, Carsten Meier <cm@trexity.de> wrote:
> > Am Fri, 16 Jan 2009 01:59:51 +0100
> > schrieb "Markus Rechberger" <mrechberger@gmail.com>:
> >

   [...]

> >>
> >> could it be that video0 is no usb device - or something else?
> >> The usb-core framework should give you the information about the
> >> serial id not the driver.
> >>
> >> $ ls /sys/bus/usb/devices/*/id* /sys/bus/usb/devices/*/serial | while
> >> read a; do cat $a; done
> >> 0c15 <- product
> >> 04fc <- vendor
> >> 00000CFD49 <- usb serial id
> >> 008e
> >> 0ccd
> >> 080702001788
> >> 6377
> >> 058f
> >> 920321111113
> >> 0000 <- nothing attached here
> >> 0000
> >> 0000:00:02.0
> >> 0000
> >> 0000
> >> 0000:00:02.1
> >>
> >> $ lsusb
> >> Bus 002 Device 008: ID 0ccd:008e TerraTec Electronic GmbH
> >> Bus 002 Device 003: ID 058f:6377 Alcor Micro Corp.
> >> Bus 002 Device 002: ID 04fc:0c15 Sunplus Technology Co., Ltd
> >> Bus 002 Device 001: ID 0000:0000
> >> Bus 001 Device 001: ID 0000:0000
> >>
> >> I use kernel 2.6.24.21 here; but the sysfs entries have been available
> >> for quite some time already.
> >>
> >> Markus
> >
> > Yes, it is a pvr-usb-device with an mpeg-encoder which resides
> > under /sys/class/pvrusb2/. And exactly this difference shows that it
> > should be solved by the driver's bus_info-string and not by programming
> > this logic into an app.
> >
> > OK, I'm done for today. I'm arguing this for two full days now. :(
> >
> 
> I understand, it should be fixed in the driver yes.
> 

Markus:

Of course he's talking about the pvrusb2 driver.  This thread first 
started last week on the pvrusb2 mailing list and when Mauro rejected 
the resulting patch to adjust bus_info (something I also initially 
rejected but was convinced otherwise later), the discussion came here.

In an earlier reply you said that the usb-core should be responsible for 
the serial number.  Well in this case that's impossible.  For Hauppauge 
devices handled by this driver, the serial number is not in the USB 
config data, but held in a non-standard private device-resident I2C ROM 
that is read by the tveeprom module in v4l-dvb and made directly 
available to the pvrusb2 driver itself.  The information is not 
available as USB configuration data so there's no way for the USB core 
ever learn of the device's serial number.  Basically the vendor has set 
things up so that the serial number is intrinsic to the device instance 
itself not the particular connection mechanism (e.g. USB).

Of course, with all that said, I do agree that it would be very useful 
for that serial number to be available to udev (and thus it becomes 
visible in the sorts of ways that Mauro was suggesting).  I'm reasonably 
certain this is done by the pvrusb2 driver stuffing it into a magic 
kobject that is linked into a magic location.  But the last time I tried 
to figure this out, I came up completely empty.  Right now I don't know 
how to do this, and the LDD3 is too old apparently to describe it.  
Honestly there's probably more digging I can do but I've got other 
higher priority issues to contend with and since the bus_info strategy 
is off the table, this problem is still left unsolved.

I do find it disheartening that the querycap command can return all 
sorts of info about the device and it's too bad no allowance was ever 
made there to also include some sort of specific device-tagging unique 
(for a given device type) identifier, such as a serial number.  Carsten 
is trying to do something that should in concept be simple, but the 
response he's getting involves a lot of complexity instead :-(

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
