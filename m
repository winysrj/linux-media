Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab1AKT56 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 14:57:58 -0500
Message-ID: <4D2CD262.2070601@redhat.com>
Date: Tue, 11 Jan 2011 19:57:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com>
In-Reply-To: <4D21FDC1.7000803@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-01-2011 14:48, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> Please pull from our tree for the following items:
> 
> 4. s5p-fimc driver conversion to Videbuf2 and multiplane ext. and various
>    driver updates and bugfixes,
> 5. Siliconfile NOON010PC30 sensor subdev driver,

Those patches seem ok. I have just a couple comments about them. See bellow.

After having them solved, please send the patches against my vb2 test tree:

	git://linuxtv.org/mchehab/experimental.git vb2_test

I've tested already vb2 with vivi. I'll be testing them now with saa7134.
After testing it, I'll give you a feedback about vb2 and, if ok, I'll merge
both multiplane and vb2 on my main tree.

> Hyunwoong Kim (5):
>       [media] s5p-fimc: fix the value of YUV422 1-plane formats

I don't have an arm cross-compilation handy, but... that means that, before this 
patch, compilation were broken? If so, please, don't do that, as it breaks bisect. 
Instead, merge the patch withthe one that broke compilation.

> Pawel Osciak (8):
>       v4l: Add multi-planar API definitions to the V4L2 API

Where are the corresponding DocBook changes?

Thanks,
Mauro
