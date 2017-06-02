Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:44662 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750813AbdFBOgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 10:36:08 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52Ea7Wk026855
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 15:36:07 +0100
Received: from mail-pf0-f197.google.com (mail-pf0-f197.google.com [209.85.192.197])
        by mx07-00252a01.pphosted.com with ESMTP id 2apxuyay0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 15:36:07 +0100
Received: by mail-pf0-f197.google.com with SMTP id h76so75955849pfh.15
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 07:36:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496412801.2358.15.camel@pengutronix.de>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
 <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl> <CAAoAYcPWK1bLYSJDwM_Bp8szNkhXN38KRsx9j0xNWXwCH9qk3Q@mail.gmail.com>
 <99d7eba3-c5a8-ade3-54bc-18eb27ef0255@xs4all.nl> <1496412801.2358.15.camel@pengutronix.de>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 2 Jun 2017 15:36:03 +0100
Message-ID: <CAAoAYcNsbKH4Yv9nvvKhX3AGGNcKLUPBdnRzAGRPk+Ep4=pYjA@mail.gmail.com>
Subject: Re: [PATCH 0/3] tc358743: minor driver fixes
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 June 2017 at 15:13, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> On Fri, 2017-06-02 at 15:27 +0200, Hans Verkuil wrote:
>> On 06/02/17 15:03, Dave Stevenson wrote:
>> > Hi Hans.
>> >
>> > On 2 June 2017 at 13:35, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >> On 06/02/17 14:18, Dave Stevenson wrote:
>> >>> These 3 patches for TC358743 came out of trying to use the
>> >>> existing driver with a new Raspberry Pi CSI-2 receiver driver.
>> >>
>> >> Nice! Doing that has been on my todo list for ages but I never got
>> >> around to it. I have one of these and using the Raspberry Pi with
>> >> the tc358743 would allow me to add a CEC driver as well.
>> >
>> > It's been on my list for a while too! It's working, but just the final
>> > clean ups needed.
>> > I've got 1 v4l2-compliance failure still outstanding that needs
>> > digging into (subscribe_event), rebasing on top of the fwnode tree,
>> > and a couple of config things to tidy up. RFC hopefully next week.
>> > I'm testing with a demo board designed here at Pi Towers, but there
>> > are others successfully testing it using the auvidea.com B101 board.
>> >
>> > Are you aware of the HDMI modes that the TC358743 driver has been used with?
>> > The comments mention 720P60 at 594MHz, but I have had to modify the
>> > fifo_level value from 16 to 110 to get VGA60 or 576P50 to work. (The
>> > value came out of Toshiba's spreadsheet for computing register
>> > settings). It increases the delay by 2.96usecs at 720P60 on 2 lanes,
>> > so not a huge change.
>> > Is it worth going to the effort of dynamically computing the delay, or
>> > is increasing the default acceptable?
>>
>> I see that the fifo_level value of 16 was supplied by Philipp Zabel, so
>> I have CC-ed him as I am not sure where those values came from.
>
> I've just chosen a small delay that worked reliably. For 4-lane 1080p60
> and for 2-lane 720p60 at 594 Mbps lane speed, the Toshiba spreadsheet
> believes that it is ok to decrease the FIFO delay all the way down to 0
> (it is not). I think it should be fine to delay transmission for a few
> microseconds unconditionally, I'll test this next week.

Thanks Philipp. Were 1080p60 and 720p60 the only modes you were really testing?

Did the 594Mbps lane speed come from a specific requirement somewhere?
The standard Pi only has 2 CSI2 lanes exposed, and 1080P30 RGB3 just
tips over into needing 3 lanes with the current link frequency. When I
can find a bit more time I was thinking that an alternate link
frequency would allow us to squeeze it in to 2 lanes. Obviously the
timing values need to be checked carefully, but it should all work and
allow support of multiple link frequencies.
(My calcs say that 1080p50 UYVY can fit down 2 lanes, but that
requires more extensive register mods).

>> This driver is also used in a Cisco product, but we use platform_data for that.
>> Here are our settings that we use for reference:
>>
>>         static struct tc358743_platform_data tc358743_pdata = {
>>                 .refclk_hz = 27000000,
>>                 .ddc5v_delay = DDC5V_DELAY_100_MS,
>>                 .fifo_level = 300,
>>                 .pll_prd = 4,
>>                 .pll_fbd = 122,
>>                 /* CSI */
>>                 .lineinitcnt = 0x00001770,
>>                 .lptxtimecnt = 0x00000005,
>>                 .tclk_headercnt = 0x00001d04,
>>                 .ths_headercnt = 0x00000505,
>>                 .twakeup = 0x00004650,
>>                 .ths_trailcnt = 0x00000004,
>>                 .hstxvregcnt = 0x00000005,
>>                 /* HDMI PHY */
>>                 .hdmi_phy_auto_reset_tmds_detected = true,
>>                 .hdmi_phy_auto_reset_tmds_in_range = true,
>>                 .hdmi_phy_auto_reset_tmds_valid = true,
>>                 .hdmi_phy_auto_reset_hsync_out_of_range = true,
>>                 .hdmi_phy_auto_reset_vsync_out_of_range = true,
>>                 .hdmi_detection_delay = HDMI_MODE_DELAY_25_MS,
>>         };
>>
>> I believe these are all calculated from the Toshiba spreadsheet.
>>
>> Frankly, I have no idea what they mean :-)
>>
>> I am fine with increasing the default if Philipp is OK as well. Since
>> Cisco uses a value of 300 I would expect that 16 is indeed too low.
>>
>> Regards,
>>
>>       Hans
>>
>> >
>> >>> A couple of the subdevice API calls were not implemented or
>> >>> otherwise gave odd results. Those are fixed.
>> >>>
>> >>> The TC358743 interface board being used didn't have the IRQ
>> >>> line wired up to the SoC. "interrupts" is listed as being
>> >>> optional in the DT binding, but the driver didn't actually
>> >>> function if it wasn't provided.
>> >>>
>> >>> Dave Stevenson (3):
>> >>>   [media] tc358743: Add enum_mbus_code
>> >>>   [media] tc358743: Setup default mbus_fmt before registering
>> >>>   [media] tc358743: Add support for platforms without IRQ line
>> >>
>> >> All looks good, I'll take this for 4.12.
>> >
>> > Thanks.
>> >
>> >> Regards,
>> >>
>> >>         Hans
>> >>
>> >>>
>> >>>  drivers/media/i2c/tc358743.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
>> >>>  1 file changed, 58 insertions(+), 1 deletion(-)
>> >>>
>> >>
>
> regards
> Philipp
>
