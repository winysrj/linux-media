Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37175 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756023AbdD1KGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 06:06:02 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and
 ADV7482
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <1493317564-18026-5-git-send-email-kbingham@kernel.org>
 <05b07c91-c41a-a3ae-d660-06eff84cd453@cogentembedded.com>
 <CAMuHMdUWzXvYJsB02kqebrqzkoQs+NSM_Xo3tsFX=DOfst=m0w@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <6b133106-a590-c286-135e-031214340910@ideasonboard.com>
Date: Fri, 28 Apr 2017 11:05:56 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUWzXvYJsB02kqebrqzkoQs+NSM_Xo3tsFX=DOfst=m0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/04/17 11:04, Geert Uytterhoeven wrote:
> On Fri, Apr 28, 2017 at 10:52 AM, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
>> On 4/27/2017 9:26 PM, Kieran Bingham wrote:
>>> --- a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
>>> +++ b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
>>
>> [...]
>>>
>>> @@ -387,6 +403,50 @@
>>>         };
>>>  };
>>>
>>> +&i2c4 {
>>> +       status = "okay";
>>> +
>>> +       clock-frequency = <100000>;
>>> +
>>> +       video_receiver@70 {
>>
>>
>>    Hyphens are preferred in the node names.
> 
> Definitely: make W=1 dtbs


Thanks guys, - I didn't know about that one.
I'll update my build script so it's always in place :)

--
Regards

Kieran


> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
