Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45352
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcF1OsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 10:48:05 -0400
Date: Tue, 28 Jun 2016 11:48:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.8 v6] Add HDMI CEC framework
Message-ID: <20160628114800.6c60f764@recife.lan>
In-Reply-To: <3b58f2d3-221d-4323-b063-f36c1a89be29@xs4all.nl>
References: <3b58f2d3-221d-4323-b063-f36c1a89be29@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 25 Jun 2016 15:47:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi Mauro,
> 
> Here is the pull request for the HDMI CEC framework. The code of this pull
> request is identical to the v19 patch series and is against the media_tree cec
> topic branch.
> 

...

>  create mode 100644 drivers/media/platform/s5p-cec/Makefile
>  create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
>  create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
>  create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
>  create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
>  create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h

It doesn't seem right to keep those CEC drivers outside staging, while
the core is at staging. I'll move them to staging. It would be nice
to get the ack from DT maintainers before moving the s5p_cec back
to platform.

So, I'm adding a patch to the series doing that. Please don't
forget to move it back to platform by the time you submit the
patches moving cec core out of staging.

>  create mode 100644 drivers/media/platform/vivid/vivid-cec.c
>  create mode 100644 drivers/media/platform/vivid/vivid-cec.h

If vivid were a real driver, I would require the same, but as
it is just a software testing driver, I won't care.


Thanks,
Mauro
