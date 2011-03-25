Return-path: <mchehab@pedra>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58788 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1CYPVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <4D8BC915.60400@gmx.de>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
 <AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>
 <AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
 <20110323081820.5b37d169@jbarnes-desktop> <AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com>
 <AANLkTi=Yc0Pg9uCZcTei45PLbERutoRc7XyoFghwS=KV@mail.gmail.com> <4D8BC915.60400@gmx.de>
From: "K, Mythri P" <mythripk@ti.com>
Date: Fri, 25 Mar 2011 20:51:31 +0530
Message-ID: <AANLkTinP3CUm3d8-RTG6NVniGh8MEwJ-unkggwZwpiZb@mail.gmail.com>
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Corbin Simpson <mostawesomedude@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Florian,

<snip>
>
>> So why should this be a common library? Most kernel code doesn't need
>> it. Or is there a serious need for video input to parse EDIDs?
>
> It's true that most kernel code does not need it as it is only useful for
> display output systems (and only the ones that can be connected to something
> sending EDID data) but it would be good anyway.
> Because sharing code that should fulfill the same purpose is always a good
> idea. But of course only if the scope is clearly limited as we don't want to
> end up with a mess that nobody dares touching again as it became to complex.
> So I totally agree that we should share the common stuff we all need and
> adding the extras one needs in the subsystem/driver.
> This is good because it looks like we'll have 3 display subsystems within
> the kernel for a long future and with a common library the same patch would
> not need to be done 3 times but only once. Or even more often if drivers
> have there private EDID implementation which I just throw out of mine to
> replace it later with a common one.
>

Precisely my point . Also if there are some bad TV models which
doesn't adhere to standard EDID, It would help to add quirks.
Anyone out there want to help me split the DRM code ? As i don't want
DRMer's to fret over changed code :).

Thanks and regards,
Mythri.
> Regards,
>
> Florian Tobias Schandinat
>
