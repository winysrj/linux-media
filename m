Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SH88QG009593
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 13:08:08 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7SH7sIF024645
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 13:07:55 -0400
Message-ID: <48B6DB6D.2000304@free.fr>
Date: Thu, 28 Aug 2008 19:07:57 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <48B3B8CD.9090503@hhs.nl> <200808262235.12292.hverkuil@xs4all.nl>
	<48B47511.4010008@hhs.nl>
In-Reply-To: <48B47511.4010008@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: What todo with cams which have 2 drivers?
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

Hans de Goede a écrit :
> Hans Verkuil wrote:
>>
>> In general I am getting worried by the lack of a common standard to
>> interface to sensor and controller drivers. I'm no expert on webcams, so
>> correct me if I'm wrong, but it seems to me that the correct design
>> would
>> be to have a generic API to these devices that can be used by the
>> various
>> USB or platform drivers.
>>
>> But for e.g. the mt9* sensors we have three that use the soc_camera
>> interface, one using the sn9c102 interface and I know of two more that
>> are not yet in v4l-dvb but that will use the v4l2-int-device.h
>> interface.
>> It's a mess in my opinion.
>>
>
> It is indeed, in my experience so far the easiest solution is to see
> the bridge and sensor (and this the whole cam) as one device. 80% of
> the per sensor code in a bridge driver is setting up the bridge to
> talk to the cam (there are various connections between the 2 possible
> and most bridges support multiple connection types) and 80% of the
> sensor code is configuring the sensor for a specific bridge (same
> story). The remaining 20% of sensor code is rather boring  (poking
> registers to set things like conteast and brightness) and since the
> sensor needs to be programmed to talk to the bridge in a bridge
> specific way there is little to gain from having seperate sensor
> drivers as those still need to be patched for a new bridge type before
> the sensor will work with a certain bridge.
>
> If you for example look at the attempting to be generic ovchipcam
> drivers in the current kernel tree, which contain code for the ov6xxx
> and ov7xxx sensors, then the attach routine contains the following:
>
>         switch (adap->id) {
>         case I2C_HW_SMBUS_OV511:
>         case I2C_HW_SMBUS_OV518:
>         case I2C_HW_SMBUS_W9968CF:
>                 PDEBUG(1, "Adapter ID 0x%06x accepted", adap->id);
>                 break;
>         default:
>                 PDEBUG(1, "Adapter ID 0x%06x rejected", adap->id);
>                 return -ENODEV;
>         }
>
> IOW this generic sensor code will only work with 3 know bridges and
> some of the code itself is bridge specific too, for example in ov6x30.c :
>
>         if (win->format == VIDEO_PALETTE_GREY) {
>                 if (c->adapter->id == I2C_HW_SMBUS_OV518) {
>                         /* Do nothing - we're already in 8-bit mode */
>                 } else {
>                         ov_write_mask(c, 0x13, 0x20, 0x20);
>                 }
>         } else {
>                 /* The OV518 needs special treatment. Although both
> the OV518
>                  * and the OV6630 support a 16-bit video bus, only the
> 8 bit Y
>                  * bus is actually used. The UV bus is tied to ground.
>                  * Therefore, the OV6630 needs to be in 8-bit multiplexed
>                  * output mode */
>
>                 if (c->adapter->id == I2C_HW_SMBUS_OV518) {
>                         /* Do nothing - we want to stay in 8-bit mode */
>                         /* Warning: Messing with reg 0x13 breaks OV518
> color */
>                 } else {
>                         ov_write_mask(c, 0x13, 0x00, 0x20);
>                 }
>         }
>
> I've done a comparison of code size between trying to use generic
> sensor code (which isn't that generic at all see above) and just
> putting sensor specific code into each bridge driver separately, see:
> http://marc.info/?l=linux-video&m=121645882518114&w=2
>
> So my conclusion (for now) is that trying to separate the sensor code
> out of the bridge drivers is not worth it. I plan to rewrite the
> ov511/ov518 driver for v4l2 using gspca (so that libv4l can be used to
> decode the special JPEG-ish format making these cams actually work).
> For this rewrite I will probably remove the ovcamchip stuff and just
> put sensor init and ctrl code in the bridge driver, probably resulting
> in a smaller driver.
>
OK and I started to convert the v4l1 w9968cf driver to v4l2, but I will
do as you, writing a simple gspca module.
>> I think it would be interesting to discuss this further with you in
>> Portland.
>
> Yes it would, I think we need to make an agenda what we want to
> discuss (both in the miniconf and outside of that).
>
Agreed.

Regards,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
