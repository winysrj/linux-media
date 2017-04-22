Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36032 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1042660AbdDVHXT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Apr 2017 03:23:19 -0400
Received: by mail-lf0-f42.google.com with SMTP id c80so53812343lfh.3
        for <linux-media@vger.kernel.org>; Sat, 22 Apr 2017 00:23:19 -0700 (PDT)
Date: Sat, 22 Apr 2017 09:23:16 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Patrick Doyle <wpdster@gmail.com>, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: Looking for device driver advice
Message-ID: <20170422072316.GW28868@bigcity.dyn.berto.se>
References: <CAF_dkJAwwj0mpOztkTNTrDC1YQkgh=HvZGh=tv3SYsuvUzTb+g@mail.gmail.com>
 <2ea495f2-022d-a9ee-11a0-28fbcba5db57@xs4all.nl>
 <20170416105121.GC7456@valkosipuli.retiisi.org.uk>
 <20170416174220.GC28868@bigcity.dyn.berto.se>
 <20170418074635.GE7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170418074635.GE7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-04-18 10:46:36 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Sun, Apr 16, 2017 at 07:42:20PM +0200, Niklas Söderlund wrote:
> > Hi,
> > 
> > On 2017-04-16 13:51:21 +0300, Sakari Ailus wrote:
> > > Hi Hans and Patrick,
> > > 
> > > On Wed, Apr 12, 2017 at 01:37:33PM +0200, Hans Verkuil wrote:
> > > > Hi Patrick,
> > > > 
> > > > On 04/10/2017 10:13 PM, Patrick Doyle wrote:
> > > > > I am looking for advice regarding the construction of a device driver
> > > > > for a MIPI CSI2 imager (a Sony IMX241) that is connected to a
> > > > > MIPI<->Parallel converter (Toshiba TC358748) wired into a parallel
> > > > > interface on a Soc (a Microchip/Atmel SAMAD2x device.)
> > > > > 
> > > > > The Sony imager is controlled and configured via I2C, as is the
> > > > > Toshiba converter.  I could write a single driver that configures both
> > > > > devices and treats them as a single device that just happens to use 2
> > > > > i2c addresses.  I could use the i2c_new_dummy() API to construct the
> > > > > device abstraction for the second physical device at probe time for
> > > > > the first physical device.
> > > > > 
> > > > > Or I could do something smarter (or at least different), specifying
> > > > > the two devices independently via my device tree file, perhaps linking
> > > > > them together via "port" nodes.  Currently, I use the "port" node
> > > > > concept to link an i2c imager to the Image System Controller (isc)
> > > > > node in the SAMA5 device.  Perhaps that generalizes to a chain of
> > > > > nodes linked together... I don't know.
> > > > 
> > > > That would be the right solution. Unfortunately the atmel-isc.c driver
> > > > (at least the version in the mainline kernel) only supports a single
> > > > subdev device. At least, as far as I can see.
> > 
> > I also think that two subdevices implemented in two separate drivers is 
> > the way to go. As it really is two different pieces of hardware,
> > right?
> > 
> > > 
> > > There have been multiple cases recently where the media pipeline can have
> > > sub-devices controlled by more than two drivers. We need to have a common
> > > approach on how we do handle such cases.
> > 
> > I agree that a common approach to the problem of when one subdevices can 
> > be controlled by more then one driver is needed. In this case however I 
> > think something else also needs to be defined. If I understand Hans and 
> > Patrick the issues is not that the hardware can be controlled by more 
> > then one driver. Instead it is that the atmel-isc.c driver only probes 
> > DT for one subdevice, so implementing it as more then one subdevices is 
> > problematic. If I misunderstand the problem please let me know.
> 
> The pipeline is (again, unless I'm mistaken):
> 
> sensor -> csi2-parallel converter -> SoC
> 
> So not very much unlike it's elsewhere.
> 
> > 
> > If I understand the problem correctly it could be solved by modifying 
> > the atmel-isc.c driver to look for more then one subdevice in DT. But a 
> > common approach for drivers to find and bind arbitrary number of 
> > subdevices would be better, finding an approach that also solves the 
> > case where one subdevice can be used by more then one driver would be 
> > better still. If this common case also could cover the case where one DT 
> > node represents a driver which registers more then one subdevice which 
> > then can be used by different other drivers I would be very happy and a 
> > lot of my headaches would go away :-)
> > 
> > > 
> > > For instance, how is the entire DT graph parsed or when and how are the
> > > device nodes created?
> > > 
> > > Parsing the graph should probably be initiated by the master driver but
> > > instead implemented in the framework as it's a non-trivial task and common
> > > to all such drivers. Another equestion is how do we best support this also
> > > on existing drivers.
> > 
> > I agree that the master device probably should initiate the DT graph 
> > parsing and if possible there should be as much support as possible in 
> > the framework. One extra consideration here is that there might be more 
> > then one master device which uses the same subdevices. I have such cases 
> 
> Good point. I.e. you have two source pads that are connected to two
> different master devices?

No, I have one source pad which is connected to more then one master 
devices. The source pad carries CSI-2 streams so different master 
devices will receive different virtual channels, or better still 
different master devices can receive the same virtual channel but apply 
different scaling/conversions on the stream before it reaches the 
/dev/videoX node.

> 
> > today where different instances of the same driver use the same set of 
> > subdevices.
> 
> Is this the intended state of matters? Or do I miss something? :-)

Yes, it is the goal to be able to represent all hardware configurations 
in the media graph.

Currently the master devices is different instances of the same driver, 
rcar-vin. So the solution right now is that the first VIN creates a 
media device, finds all upstream subdevices and adds them to the media 
graph. Later instances of the rcar-vin driver will simply join the media 
device and this way gain access to the shard subdevices.

This works but creates a complex logic to share subdevices. If more then 
one master device could find the same subdevices I believe this logic 
could be simplified and maybe more functionality could be put in the 
V4L2 core.

> 
> > 
> > > 
> > > I actually have a small documentation patch on handling streaming control in
> > > such cases as there are choices now to be made not thought about when the
> > > sub-device ops were originally addeed. I'll cc you to that.
> > > 
> > > We do have a similar case currently in i.MX6, Nokia N9 (OMAP3) and on some
> 
> I meant to say Nokia N900, not N9.

Nice, I have a N900 :-)

> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
