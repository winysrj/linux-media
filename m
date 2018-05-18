Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:51328 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbeERKgA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 06:36:00 -0400
Subject: Re: [PATCH v3 03/12] media: ov5640: Remove the clocks registers
 initialization
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <20180517085405.10104-4-maxime.ripard@bootlin.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <0de04d7b-9c75-3e4e-4cf9-deaedeab54a4@zonque.org>
Date: Fri, 18 May 2018 12:35:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180517085405.10104-4-maxime.ripard@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> Part of the hardcoded initialization sequence is to set up the proper clock
> dividers. However, this is now done dynamically through proper code and as
> such, the static one is now redundant.
> 
> Let's remove it.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---

[...]

> @@ -625,8 +623,8 @@ static const struct reg_value ov5640_setting_30fps_1080P_1920_1080[] = {
>   	{0x3a0d, 0x04, 0, 0}, {0x3a14, 0x03, 0, 0}, {0x3a15, 0xd8, 0, 0},
>   	{0x4001, 0x02, 0, 0}, {0x4004, 0x06, 0, 0}, {0x4713, 0x03, 0, 0},
>   	{0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> -	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0}, {0x3035, 0x11, 0, 0},
> -	{0x3036, 0x54, 0, 0}, {0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},
> +	{0x3824, 0x02, 0, 0}, {0x5001, 0x83, 0, 0},
> +	{0x3c07, 0x07, 0, 0}, {0x3c08, 0x00, 0, 0},

This is the mode that I'm testing with. Previously, the hard-coded 
registers here were:

  OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
  OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0x54
  OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x07

Your new code that calculates the clock rates dynamically ends up with 
different values however:

  OV5640_REG_SC_PLL_CTRL1 (0x3035) = 0x11
  OV5640_REG_SC_PLL_CTRL2 (0x3036) = 0xa8
  OV5640_REG_SC_PLL_CTRL3 (0x3037) = 0x03

Interestingly, leaving the hard-coded values in the array *and* letting 
ov5640_set_mipi_pclk() do its thing later still works. So again it seems 
that writes to registers after 0x3035/0x3036/0x3037 seem to depend on 
the values of these timing registers. You might need to leave these 
values as dummies in the array. Confusing.

Any idea?


Thanks,
Daniel
