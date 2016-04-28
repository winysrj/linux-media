Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34232 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbcD1IAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 04:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <7242073.I0M81bb6ct@avalon>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1461620198-13428-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<20160428025429.GA11679@rob-hp-laptop>
	<7242073.I0M81bb6ct@avalon>
Date: Thu, 28 Apr 2016 10:00:10 +0200
Message-ID: <CAMuHMdXHYGTNSV-7JAo8Fp_q3z-WPcJEB7CuenaRuhZJABxc0A@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] dt-bindings: Add Renesas R-Car FCP DT bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Rob Herring <robh@kernel.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 28, 2016 at 8:36 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> > b/Documentation/devicetree/bindings/media/renesas,fcp.txt new file mode
>> > 100644
>> > index 000000000000..0c72ca24379f
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> > @@ -0,0 +1,31 @@
>> > +Renesas R-Car Frame Compression Processor (FCP)
>> > +-----------------------------------------------
>> > +
>> > +The FCP is a companion module of video processing modules in the Renesas
>> > R-Car +Gen3 SoCs. It provides data compression and decompression, data
>> > caching, and +conversion of AXI transactions in order to reduce the
>> > memory bandwidth. +
>> > +There are three types of FCP whose configuration and behaviour highly
>> > depend +on the module they are paired with.
>>
>> 3 types?, but I only see one compatible and no relationship with said
>> module described.
>
> The bindings currently support a single type, as that's all the driver
> currently supports and I'm not comfortable merging bindings without at least
> one test implementation. Should I clarify that with something as "These DT
> bindings currently support the "FCP for Video" type only" ?

Yes please.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
