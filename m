Return-path: <mchehab@pedra>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53818 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1CYNe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 09:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103242001460.21914@axis700.grange>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
 <AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>
 <AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
 <20110323081820.5b37d169@jbarnes-desktop> <AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com>
 <Pine.LNX.4.64.1103242001460.21914@axis700.grange>
From: "K, Mythri P" <mythripk@ti.com>
Date: Fri, 25 Mar 2011 19:04:05 +0530
Message-ID: <AANLkTikQdUYYRSG1ZNesgxQG+HhDJ-PY_wpwz3Mec-3V@mail.gmail.com>
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
	linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Gunnedi,

<snip>
>> > Dave's point is that we can't ditch the existing code without
>> > introducing a lot of risk; it would be better to start a library-ized
>> > EDID codebase from the most complete one we have already, i.e. the DRM
>> > EDID code.
>
> Does the DRM EDID-parser also process blocks beyond the first one and
> also parses SVD entries similar to what I've recently added to fbdev? Yes,
> we definitely need a common EDID parses, and maybe we'll have to collect
> various pieces from different implementations.
>
As far as I know , it does not parse SVD ,But it should not be that
difficult to add.
We could take the SVD parsing from your code . In the RFC i have
posted I parse for detailed timing and other VSDB blocks.
Also the parsing should be based on the extension type for  multiple
128 byte blocks.

Thanks and regards,
Mythri.

> Thanks
> Guennadi
>
