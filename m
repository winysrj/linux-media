Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34818 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdFNLdy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 07:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <51d9d2d7-de34-9ed3-5fa1-4db7cbcec47a@ideasonboard.com>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <7d4b2333912ad23e62dbb8cc3792ad70e9cc1702.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdWVrqArGasrW8F8KOjRfRzFqQ_5hCskP30zGrTrxJ75hQ@mail.gmail.com> <51d9d2d7-de34-9ed3-5fa1-4db7cbcec47a@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 14 Jun 2017 13:33:52 +0200
Message-ID: <CAMuHMdX_9Li+hfeLem1PnPht3mf8ggkPk0h01b8mQN_2dpCo=w@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] arm64: dts: renesas: salvator-x: Add ADV7482 support
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, Jun 14, 2017 at 11:43 AM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> On 14/06/17 10:39, Geert Uytterhoeven wrote:
>> On Tue, Jun 13, 2017 at 2:35 AM, Kieran Bingham <kbingham@kernel.org> wrote:
>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> Provide ADV7482, and the needed connectors
>>>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Thanks for your patch!
>>
>>> v4:
>>>  - dt: Rebase to dts/renesas/salvator-x.dtsi
>>>  - dt: Use AIN0-7 rather than AIN1-8
>>>
>>>  arch/arm64/boot/dts/renesas/salvator-x.dtsi | 123 +++++++++++++++++++++-
>>
>> I believe all of this applies to both Salvator-X and Salvator-XS?
>>
>> Hence it should be applied to salvator-common.dtsi instead of salvator-x.dtsi.
>
> Hrm ... I don't have a salator-common.dtsi ... I'll need a new rebase.

It's always a good idea to base your Renesas DT patches on Simon's latest
devel branch.

> But it sounds logical :)

Good :-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
