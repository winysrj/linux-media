Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1IZRcy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 13:32:54 -0400
Message-ID: <4E80B73F.5020804@redhat.com>
Date: Mon, 26 Sep 2011 14:32:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
References: <20110921135604.64363a2e@skate> <CAGoCfiyFbHcZO-Rz2VFr249NprqvhQhcSPBLHRj_Txs9gimYqA@mail.gmail.com> <20110922164508.395c2900@skate> <CAGoCfiy_RVbgq+3WTsC=ZrJsOfDYEWUov6meOU8=ShACBM7J2g@mail.gmail.com> <20110922172929.16df967f@skate> <20110923140404.5816c056@skate> <4E7D3D5A.6030008@redhat.com> <20110926101323.41708d64@skate>
In-Reply-To: <20110926101323.41708d64@skate>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-09-2011 05:13, Thomas Petazzoni escreveu:
> Hello Mauro,
> 
> Le Fri, 23 Sep 2011 23:15:54 -0300,
> Mauro Carvalho Chehab <mchehab@redhat.com> a écrit :
> 
>>> And still the result is the same: we get a first frame, and then
>>> nothing more, and we have a large number of error messages in the
>>> kernel logs.
>>
>> I don't think that this is related to the power manager anymore. It can
>> be related to cache coherency and/or to iommu support.
> 
> As you suspected, increasing PWR_SLEEP_INTERVAL didn't change anything.
> What do you suggest to track down the potential cache coherency issues ?

Take a look at the ML. The SoC people discussed a lot about cache
coherency problems and how to solve it. Videobuf2 has a better support
on embedded world. I would take a look on it and see what it does different
than other drivers. Maybe Jonathan Corbet patches for the ccic driver may
help you.

It is probably a good idea to change cx231xx to use videobuf2, in order to
fix this issue.

Thanks,
Mauro
> 
> Best regards,
> 
> Thomas

