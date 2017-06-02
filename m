Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41186 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBN1c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 09:27:32 -0400
Subject: Re: [PATCH 0/3] tc358743: minor driver fixes
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
 <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl>
 <CAAoAYcPWK1bLYSJDwM_Bp8szNkhXN38KRsx9j0xNWXwCH9qk3Q@mail.gmail.com>
Cc: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <99d7eba3-c5a8-ade3-54bc-18eb27ef0255@xs4all.nl>
Date: Fri, 2 Jun 2017 15:27:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAAoAYcPWK1bLYSJDwM_Bp8szNkhXN38KRsx9j0xNWXwCH9qk3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/17 15:03, Dave Stevenson wrote:
> Hi Hans.
> 
> On 2 June 2017 at 13:35, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 06/02/17 14:18, Dave Stevenson wrote:
>>> These 3 patches for TC358743 came out of trying to use the
>>> existing driver with a new Raspberry Pi CSI-2 receiver driver.
>>
>> Nice! Doing that has been on my todo list for ages but I never got
>> around to it. I have one of these and using the Raspberry Pi with
>> the tc358743 would allow me to add a CEC driver as well.
> 
> It's been on my list for a while too! It's working, but just the final
> clean ups needed.
> I've got 1 v4l2-compliance failure still outstanding that needs
> digging into (subscribe_event), rebasing on top of the fwnode tree,
> and a couple of config things to tidy up. RFC hopefully next week.
> I'm testing with a demo board designed here at Pi Towers, but there
> are others successfully testing it using the auvidea.com B101 board.
> 
> Are you aware of the HDMI modes that the TC358743 driver has been used with?
> The comments mention 720P60 at 594MHz, but I have had to modify the
> fifo_level value from 16 to 110 to get VGA60 or 576P50 to work. (The
> value came out of Toshiba's spreadsheet for computing register
> settings). It increases the delay by 2.96usecs at 720P60 on 2 lanes,
> so not a huge change.
> Is it worth going to the effort of dynamically computing the delay, or
> is increasing the default acceptable?

I see that the fifo_level value of 16 was supplied by Philipp Zabel, so
I have CC-ed him as I am not sure where those values came from. This driver
is also used in a Cisco product, but we use platform_data for that. Here are
our settings that we use for reference:

        static struct tc358743_platform_data tc358743_pdata = {
                .refclk_hz = 27000000,
                .ddc5v_delay = DDC5V_DELAY_100_MS,
                .fifo_level = 300,
                .pll_prd = 4,
                .pll_fbd = 122,
                /* CSI */
                .lineinitcnt = 0x00001770,
                .lptxtimecnt = 0x00000005,
                .tclk_headercnt = 0x00001d04,
                .ths_headercnt = 0x00000505,
                .twakeup = 0x00004650,
                .ths_trailcnt = 0x00000004,
                .hstxvregcnt = 0x00000005,
                /* HDMI PHY */
                .hdmi_phy_auto_reset_tmds_detected = true,
                .hdmi_phy_auto_reset_tmds_in_range = true,
                .hdmi_phy_auto_reset_tmds_valid = true,
                .hdmi_phy_auto_reset_hsync_out_of_range = true,
                .hdmi_phy_auto_reset_vsync_out_of_range = true,
                .hdmi_detection_delay = HDMI_MODE_DELAY_25_MS,
        };

I believe these are all calculated from the Toshiba spreadsheet.

Frankly, I have no idea what they mean :-)

I am fine with increasing the default if Philipp is OK as well. Since
Cisco uses a value of 300 I would expect that 16 is indeed too low.

Regards,

	Hans

> 
>>> A couple of the subdevice API calls were not implemented or
>>> otherwise gave odd results. Those are fixed.
>>>
>>> The TC358743 interface board being used didn't have the IRQ
>>> line wired up to the SoC. "interrupts" is listed as being
>>> optional in the DT binding, but the driver didn't actually
>>> function if it wasn't provided.
>>>
>>> Dave Stevenson (3):
>>>   [media] tc358743: Add enum_mbus_code
>>>   [media] tc358743: Setup default mbus_fmt before registering
>>>   [media] tc358743: Add support for platforms without IRQ line
>>
>> All looks good, I'll take this for 4.12.
> 
> Thanks.
> 
>> Regards,
>>
>>         Hans
>>
>>>
>>>  drivers/media/i2c/tc358743.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 58 insertions(+), 1 deletion(-)
>>>
>>
