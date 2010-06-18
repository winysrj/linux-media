Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62061 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab0FRNAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jun 2010 09:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <20100616075642.GA12255@atomide.com>
References: <201006091227.29175.laurent.pinchart@ideasonboard.com>
	<AANLkTilPWyHcoT6q1T-o-UMvcMSs2_If45f9UocVtrbl@mail.gmail.com>
	<A24693684029E5489D1D202277BE894455DDEC44@dlee02.ent.ti.com>
	<201006111707.34463.laurent.pinchart@ideasonboard.com>
	<AANLkTikdUanfxhkbb0sYZ-Yhd_9dVywv9Yj1a5DL18oN@mail.gmail.com>
	<20100616075642.GA12255@atomide.com>
Date: Fri, 18 Jun 2010 16:00:22 +0300
Message-ID: <AANLkTinF9icY0SSHAKcurjP3DX4h7mA9vlRK6ZaAoHdx@mail.gmail.com>
Subject: Re: Alternative for defconfig
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	"Nagarajan, Rajkumar" <x0133774@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 16, 2010 at 10:56 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Felipe Contreras <felipe.contreras@gmail.com> [100611 19:03]:
>> On Fri, Jun 11, 2010 at 6:07 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>> > My understanding is that Linus will remove all ARM defconfigs in 2.6.36,
>> > unless someone can convince him not to.
>>
>> Huh? I thought he was only threatening to remove them[1]. I don't
>> think he said he was going to do that without any alternative in
>> place.
>>
>> My suggestion[2] was to have minimal defconfigs so that we could do
>> $ cp arch/arm/configs/omap3_beagle_baseconfig .config
>> $ echo "" | make ARCH=arm oldconfig
>>
>> [1] http://article.gmane.org/gmane.linux.kernel/994194
>> [2] http://article.gmane.org/gmane.linux.kernel/995412
>
> Sounds like the defconfigs will be going though and we'll use
> some Kconfig based system that's still open. I believe Russell
> said he is not taking any more defconfig patches, so we should
> not merge them either.
>
> Anyways, we already have multi-omap mostly working for both
> mach-omap1 and mach-omap2.

Cool, that's a much better approach :)

Although it still doesn't solve the problem of default configuration
for certain boards... I doubt many people know how to enable USB,
audio, and so on. We would probably need some place to share
configuration samples and documentation.

-- 
Felipe Contreras
