Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34427 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbcDEVTP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 17:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1604052255200.10633@axis700.grange>
References: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
	<1458002427-3063-3-git-send-email-horms+renesas@verge.net.au>
	<Pine.LNX.4.64.1604052255200.10633@axis700.grange>
Date: Tue, 5 Apr 2016 23:19:13 +0200
Message-ID: <CAMuHMdWMJsPMuV+7BEye1-fWEJV+C_bwfMOpnHwnZ8qr8ZMoYA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] media: soc_camera: rcar_vin: add device tree
 support for r8a7792
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Simon Horman <horms+renesas@verge.net.au>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tue, Apr 5, 2016 at 10:56 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 15 Mar 2016, Simon Horman wrote:
>> Simply document new compatibility string.
>> As a previous patch adds a generic R-Car Gen2 compatibility string
>> there appears to be no need for a driver updates.
>>
>> By documenting this compat string it may be used in DTSs shipped, for
>> example as part of ROMs. It must be used in conjunction with the Gen2
>> fallback compat string. At this time there are no known differences between
>> the r8a7792 IP block and that implemented by the driver for the Gen2
>> fallback compat string. Thus there is no need to update the driver as the
>> use of the Gen2 fallback compat string will activate the correct code in
>> the current driver while leaving the option for r8a7792-specific driver
>> code to be activated in an updated driver should the need arise.
>>
>> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Strictly speaking, I see an ack from Geert to patch 1/2, but I don't see
> one for this patch 2/2. Have I missed it or did Geert mean to ack the
> whole series and forgot to mention that?

Sorry, apparently I replied with the "sting" comment and my ack to Simon only,
not to all.

Hence FTR:
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
