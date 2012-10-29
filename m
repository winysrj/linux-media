Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65089 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2J2RXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 13:23:30 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so5557764vbb.19
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 10:23:29 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2012 12:23:29 -0500
Message-ID: <CALLhW=76TG1sFXHmukJ+JN12j9CdbRLMzJdiOvrdorUehrts0g@mail.gmail.com>
Subject: tidspbridge: ARM common zImage?
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26 October 2012 13:00, Tony Lindgren <tony@atomide.com> wrote:
...
>> > I would also like to move the tidspbridge to the DMA API, but I think we'll
>> > need to move step by step there, and using the OMAP IOMMU and IOVMM APIs as an
>> > intermediate step would allow splitting patches in reviewable chunks. I know
>> > it's a step backwards in term of OMAP IOMMU usage, but that's in my opinion a
>> > temporary nuisance to make the leap easier.
>>
>> Since tidspbridge is in staging I guess it's not a problem, though it
>> sounds to me like using the correct API in the first place is going to
>> make less churn.
>
> Not related to these patches, but also sounds like we may need to drop
> some staging/tidspbridge code to be able to move forward with the
> ARM common zImage plans. See the "[GIT PULL] omap plat header removal
> for v3.8 merge window, part1" thread for more info.

I was trying to find some more info on this, but only found one patch
for tidspbridge to delete an include... it seems that I must try with
these patches and see what explodes since we heavily abuse prcm code
too.

Thanks,

Omar
