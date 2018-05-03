Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:40601 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbeECOvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 10:51:22 -0400
Received: by mail-yb0-f175.google.com with SMTP id o80-v6so5258626ybc.7
        for <linux-media@vger.kernel.org>; Thu, 03 May 2018 07:51:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BoaO5L6r4bjRoL6B1wiC+GG+JFXn9+4CZsAUN6Wkz9zA@mail.gmail.com>
References: <CAPQseg2t1-LgmeuQBW2YXSwN26WKcJWakN2KCLfCjKZ_wJeWGw@mail.gmail.com>
 <1523629085.3396.10.camel@pengutronix.de> <CAPQseg29hJ+vdWxU3RkXtaeJki9209OjqvGOQQ-U45Z_vvjnnw@mail.gmail.com>
 <1523871020.5918.4.camel@pengutronix.de> <CAPQseg3qXkgU=1yvUXdh73XnGT-kcFWsBF6nDx6AMa+OV7w3nQ@mail.gmail.com>
 <1523954089.3612.1.camel@pengutronix.de> <CAPQseg1dtXk94b=emhJJHPtNvmW4mkCRLq-UkMjSzpz-45Do_g@mail.gmail.com>
 <1523968435.3612.8.camel@pengutronix.de> <CAPQseg3uECmWFnjpYW+=JYRHNxm70MA4f7=L3NSn1ZWYL83=nQ@mail.gmail.com>
 <CAOMZO5BoaO5L6r4bjRoL6B1wiC+GG+JFXn9+4CZsAUN6Wkz9zA@mail.gmail.com>
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Thu, 3 May 2018 16:51:21 +0200
Message-ID: <CAPQseg0ky7y9Y1yaVSaOYDhkr8CQTkHvzf9v3BC+1Z_eiqpbWw@mail.gmail.com>
Subject: Re: imx-media: MT9P031 Capture issues on IMX6
To: Fabio Estevam <festevam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Thu, Apr 19, 2018 at 7:08 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Thu, Apr 19, 2018 at 1:55 PM, Ibtsam Ul-Haq
> <ibtsam.haq.0x01@gmail.com> wrote:
>
>> I can see by using a logic analyzer that the PIXCLK does not look
>> nice. It looks similar to the issue mentioned here:
>> https://community.nxp.com/thread/454467
>>
>> except that in my case it looks pulled up instead of down.
>> However I do not yet have a clue what causes this.
>> VSYNC and HSYNC waveforms look ok, until the whole capture is stopped
>> due to the error, after 14 frames.
>> The relevant pinctrl settings in the dts are:
>>
>>     MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK    0x4001b0b0
>>     MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC        0x4001b0b0
>>     MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC        0x4001b0b0
>
> Not sure why you are setting the SION bit (bit 30) on the CSI pads.
>
> Does it work better if you do not set it?
>


Thanks for your response.
The SION bit was this way in the dts provided by the board manufacturer.
But now I have tried it with the SION bit cleared, unfortunately it
didn't make any difference.
There is a new board revision coming soon with several layout changes.
So currently I am waiting, in the hope that we don't waste time
debugging it if it were a hardware problem.


> For your reference: this is what we do on imx6qdl-sabresd.dtsi:
>
> MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x1b0b0
> MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x1b0b0
> MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x1b0b0
> MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x1b0b0
> MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x1b0b0
> MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x1b0b0
> MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x1b0b0
> MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x1b0b0
> MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x1b0b0
> MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x1b0b0
> MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x1b0b0

Best regards,
Ibtsam Haq
