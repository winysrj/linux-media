Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51599 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1I1IZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:25:26 -0400
Received: by ywb5 with SMTP id 5so6155404ywb.19
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2011 01:25:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109281008310.30317@axis700.grange>
References: <Pine.LNX.4.64.1109281008310.30317@axis700.grange>
Date: Wed, 28 Sep 2011 17:25:24 +0900
Message-ID: <CANqRtoT7fpegZqqNuQ1HBoh-4w37RTkB3xO=iDzDGfxBb-UuCg@mail.gmail.com>
Subject: Re: acks needed
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Sep 28, 2011 at 5:11 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Paul, Magnus
>
> The following patches need your acks to allow the whole stack to go on
> time into 3.2 without breaking platforms even intermittently.
>
> [20/59] ARM: ap4evb: switch imx074 configuration to default number of lanes
> http://patchwork.linuxtv.org/patch/7514/
> [27/59] ARM: mach-shmobile: convert mackerel to mediabus flags
> http://patchwork.linuxtv.org/patch/7506/
> [28/59] sh: convert ap325rxa to mediabus flags
> http://patchwork.linuxtv.org/patch/7513/
> [49/59] sh: ap3rxa: remove redundant soc-camera platform data fields
> http://patchwork.linuxtv.org/patch/7517/
> [50/59] sh: migor: remove unused ov772x buswidth flag
> http://patchwork.linuxtv.org/patch/7516/
> [56/59] ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
> http://patchwork.linuxtv.org/patch/7523/

They all look fine to me, thanks. Please note that I have not
performed any kind of testing of the patches above, but as usual I
expect you to fix up eventual issues by yourself. =)

Acked-by: Magnus Damm <damm@opensource.se>
