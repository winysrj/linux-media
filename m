Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35654 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162097AbdD1KEU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 06:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <05b07c91-c41a-a3ae-d660-06eff84cd453@cogentembedded.com>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <1493317564-18026-5-git-send-email-kbingham@kernel.org> <05b07c91-c41a-a3ae-d660-06eff84cd453@cogentembedded.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 28 Apr 2017 12:04:18 +0200
Message-ID: <CAMuHMdUWzXvYJsB02kqebrqzkoQs+NSM_Xo3tsFX=DOfst=m0w@mail.gmail.com>
Subject: Re: [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 10:52 AM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 4/27/2017 9:26 PM, Kieran Bingham wrote:
>> --- a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
>> +++ b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
>
> [...]
>>
>> @@ -387,6 +403,50 @@
>>         };
>>  };
>>
>> +&i2c4 {
>> +       status = "okay";
>> +
>> +       clock-frequency = <100000>;
>> +
>> +       video_receiver@70 {
>
>
>    Hyphens are preferred in the node names.

Definitely: make W=1 dtbs

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
