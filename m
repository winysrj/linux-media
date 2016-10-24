Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35618 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbcJXKBI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 06:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <1923730.zaykC4sXJR@avalon>
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1477299818-31935-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <CAMuHMdUGy0+bv-t=8HXeQf0BpoMJMNP85cd2tubQzD4Zj8X9Gw@mail.gmail.com> <1923730.zaykC4sXJR@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 24 Oct 2016 12:01:06 +0200
Message-ID: <CAMuHMdW9RhsvR8cDLWgGjqw+KzHC8A2L0S2JO1ymksaosv-iqg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] dt-bindings: Add Renesas R-Car FDP1 bindings
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Oct 24, 2016 at 11:46 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 24 Oct 2016 11:14:11 Geert Uytterhoeven wrote:
>> On Mon, Oct 24, 2016 at 11:03 AM, Laurent Pinchart wrote:
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/renesas,fdp1.txt

>> > +Optional properties:
>> > + - power-domains : power-domain property defined with a power domain
>> > specifier
>>                       "power domain"?
>>
>> > +                            to respective power domain.
>>
>> Still, too many power domains in one sentence?
>
> How about
>
>  - power-domains : reference to the power domain that the FDP1 belongs to, if
>    any.

Much better. Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
