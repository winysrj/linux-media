Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50572 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdEQOiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 10:38:02 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 1/2] v4l: subdev: tolerate null in
 media_entity_to_v4l2_subdev
References: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2a3a6d999502db1b6a47706b4da92d396075b22b.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdU8Pz=pApw4x0j+iVc0jHagQbv02UCphidmLMNb5tAGFg@mail.gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kbingham@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <dac6e043-a51e-b7ad-ffa4-722bb7785958@ideasonboard.com>
Date: Wed, 17 May 2017 15:37:57 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU8Pz=pApw4x0j+iVc0jHagQbv02UCphidmLMNb5tAGFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 17/05/17 15:25, Geert Uytterhoeven wrote:
> Hi Kieran,
> 
> On Wed, May 17, 2017 at 4:13 PM, Kieran Bingham <kbingham@kernel.org> wrote:
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -829,7 +829,7 @@ struct v4l2_subdev {
>>  };
>>
>>  #define media_entity_to_v4l2_subdev(ent) \
>> -       container_of(ent, struct v4l2_subdev, entity)
>> +       ent ? container_of(ent, struct v4l2_subdev, entity) : NULL
> 
> Due to the low precedence level of the ternary operator, you want
> to enclose this in parentheses.

Thanks Geert - That's quick to respin ;)

--
Kieran

> 
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
