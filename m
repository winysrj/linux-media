Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2369 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABUNU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 15:13:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: Move the deprecated et61x251 and sn9c102 to staging
Date: Sun, 2 Jan 2011 21:13:01 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Jean-Francois Moine" <moinejf@free.fr>
References: <201101012053.00372.hverkuil@xs4all.nl> <4D20A908.9020705@redhat.com> <4D20C4FB.9060906@redhat.com>
In-Reply-To: <4D20C4FB.9060906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101022113.01133.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On Sunday, January 02, 2011 19:33:31 Hans de Goede wrote:
> Hi,
> 
> One small correction to the sn9c102 sensor table, the
> mt9v111 sensor is handled by sonixj, so the table of
> bridge/sensor combi's supported by sn9c102, looks like this:
> 
> sn9c101/102:
> hv7131d
> mi0343 *
> ov7630
> pas106b
> pas202bcb
> tas5110c1b
> tas5110d
> tas5130d1b
> 
> sn9c103:
> hv7131r *
> mi0360 *
> ov7630
> pas202bcb
> 
> sn9c105/120:
> hv7131r
> mi0360
> mt9v111
> ov7630
> ov7660
> 
> So only 3 raw bayer + custom compression models supported by
> sn9c102 are not supported by gspca_sonixb, and all jpeg models
> are supported by gspca_sonixj. Porting the 3 remaining models
> over should be relatively easy, but I (I more or less maintain
> the sonixb driver) really need hardware access to ensure things
> stay working.
> 
> Second correction, I was looking at an old tree and failed to
> notice that the zc0301 driver has already bitten the dust
> (good!).

Thank you for your very helpful answer.

Can you make a patch removing all the bogus usb IDs from these drivers?
And anything else that you think it bogus for that matter. Once that's
done we should see if we will move it to staging.

Based on what you said, I'm in favor of that.

Best regards and a Happy New Year!

	Hans

> 
> Regards,
> 
> Hans
> 
> On 01/02/2011 05:34 PM, Hans de Goede wrote:
> > Hi,
> >
> > On 01/02/2011 12:25 PM, Hans Verkuil wrote:
> >> On Sunday, January 02, 2011 11:41:31 Mauro Carvalho Chehab wrote:
> >>> Em 01-01-2011 17:53, Hans Verkuil escreveu:
> >>>> The subject says it all:
> >>>>
> >>>> If there are no objections, then I propose that the deprecated et61x251 and
> >>>> sn9c102 are moved to staging for 2.6.38 and marked for removal in 2.6.39.
> >>>
> >>> Nack.
> >>>
> >>> There are several USB ID's on sn9c102 not covered by gspca driver yet.
> >>
> >> Why are these drivers marked deprecated then?
> >>
> >
> > You'll have to look at me for the deprecation marking.
> >
> > I did this because they are unmaintained and buggy in some areas and thus really
> > should go away. Also note that looking at usb-id's is *not* useful with these
> > drivers as when Luca wrote them he simply included large lists of usb-id's without
> > the drivers actually being tested with cams with those id's. Usually when a bridge
> > supports a range of configurable id's, this is used to have one generic (win32)
> > driver and the usb product id indicates which sensor is used.
> >
> > I did a patch removing a whole bunch of usb-id's from the sn9c102 driver in the
> > past as we knew which sensors those id's corresponded with and Luca's driver never
> > supported these sensors, so the claiming of the usb-id's was bogus.
> >
> > However for many usb-id's claimed by the sn9c102 driver we don't know what sensor
> > they belong to (or if any devices with that id exists out there at all), so I left
> > them in to not cause regressions.
> >
> > So if we want to see where we stand wrt replacing Luca's old drivers with gspca
> > subdrivers, you should look at the list of supported sensors.
> >
> > I've made a list for all sn9c102 supported bridge + sensor combinations and
> > marked the ones which are not yet supported by gscpa:
> >
> > sn9c101/102:
> > hv7131d
> > mi0343 *
> > ov7630
> > pas106b
> > pas202bcb
> > tas5110c1b
> > tas5110d
> > tas5130d1b
> >
> > sn9c103:
> > hv7131r *
> > mi0360 *
> > ov7630
> > pas202bcb
> >
> > sn9c105/120:
> > hv7131r
> > mi0360
> > mt9v111 *
> > ov7630
> > ov7660
> >
> > So we have 3 models not yet supported in the sonixb driver (and sonixb
> > cams are quite rare now a days). And 1 model in the sonixj driver.
> >
> > Note btw that I've disabled all Luca's drivers (et61x251, sn9c102 and
> > zc0301) in Fedora kernels for several Fedora releases already and sofar
> > I've received one bug report about this, which is resolved now as I
> > recently added support for the hv7131d sensor to the sonixb driver
> > (thanks to said bug report).
> >
> > So all in all I believe that moving the sn9c102 driver to staging, or
> > at least remove all usb-id's which are a doublure with gspca's sonixb
> > and sonixj drivers is the right thing to do.
> >
> >>> It seems to me that et61x251 will also stay there for a long time, as there are
> >>> just two devices supported by gspca driver, while et61x251 supports 25.
> >>>
> >>> Btw, we currently have a conflict with this USB ID:
> >>> USB_DEVICE(0x102c, 0x6151),
> >>>
> >>> Both etoms and et61x251 support it, and there's no #if to disable it on one
> >>> driver, if both drivers are compiled. We need to disable it either at gspca_etoms
> >>> or at et61x251, in order to avoid users of having a random experience with this
> >>> device.
> >>
> >> Surely such devices should be removed from et61x251 or sn9c102 as soon as they are
> >> added to gspca?
> >
> > The problem is that the initial gspcav2 core + subdrivers as it entered the mainline
> > is derived from / a partial rewrite of the out of tree v4l1 gspca drivers / framework
> > as such the register init sequences for bridges + sensors were not all tested when
> > gspca entered the mainline so in the case of untested bridge + sensor combo's which
> > were already supported by Luca's mainline drivers, we added #ifdef's to use Luca's
> > drivers in case both are compiled in. As more and more people tested the gspca drivers
> > most of these #ifdef's were reversed to prefer the gspca sub drivers if both
> > were compiled in, one ubs-id at a time.
> >
> > Looking at both drivers, the gspca one supports both the tas5130 and pas106 sensors,
> > where as the et61x251 driver only supports the tas5130 sensor. The conflicting usb id
> > 102c:6151 is for a camera with the pas106 sensor, so the solution is to remove this
> > usb id from the et61x251 driver, as it does not support this id, despite claiming it.
> >
> > Looking closer at the et61x251 driver, one finds this beauty inside
> > et61x251_tas5130d1b.c, which is the only sensor module for the et61x251 driver:
> >
> > int et61x251_probe_tas5130d1b(struct et61x251_device* cam)
> > {
> > const struct usb_device_id tas5130d1b_id_table[] = {
> > { USB_DEVICE(0x102c, 0x6251), },
> > { }
> > };
> >
> > /* Sensor detection is based on USB pid/vid */
> > if (!et61x251_match_id(cam, tas5130d1b_id_table))
> > return -ENODEV;
> >
> > ...
> >
> > IOW the et61x251 driver, in classical Luca style if I may say so, only supports usb id
> > 102c:6251, despite claiming many many more. So moving forward we should:
> >
> > 1) Remove all bogus usb id's from the et61x251 driver, as trying to use any of these
> > devices with it will fail, as it won't be able to find a working sensor module
> > (I thought I did a patch for this once before, but either my memory is failing or
> > the patch got lost).
> >
> > 2) Since it then 100% overlaps with the etoms driver, move it to staging
> >
> > ###
> >
> > I notice that the zc0301 driver is missing from your list to move to staging, it
> > 100% overlaps with the gspca zc3xx driver. And where as the zc0301 driver
> > only claims to support 2 usb-id's (and 2 sensor types), the gspca zc3xx driver
> > supports 53 usb id's and 19 sensor types.
> >
> > Note that the zc3xx bridge is special in that the usb-id does not always uniquely
> > identify a bridge/sensor combo. One needs to do actual i2c bus probing to figure
> > out which sensor is attached (like with the ov51x / ovfx2 bridges)...
> >
> > And the zc0301 driver claims to support the 0ac8:303b, which is a generic
> > id, which may ship with many types of sensors, including many not supported by
> > the zc0301 driver, so effectively it only supports 1 usb-id properly.
> >
> > So the zc0301 driver should be moved to staging too IMHO.
> >
> > Regards,
> >
> > Hans
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
