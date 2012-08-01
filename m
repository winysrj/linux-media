Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31381 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2HAI2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 04:28:42 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8200I6QI8JDE60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 09:29:07 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8200M1PI7QE290@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 09:28:40 +0100 (BST)
Message-id: <5018E8B5.4050708@samsung.com>
Date: Wed, 01 Aug 2012 10:28:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: sungchun.kang@samsung.com
Cc: 'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, khw0178.kim@samsung.com,
	mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sy0816.kang@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	alim.akhtar@gmail.com, prashanth.g@samsung.com, joshi@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [PATCH v5 0/5] Add new driver for generic scaler
References: <1343742246-27579-1-git-send-email-shaik.ameer@samsung.com>
 <008301cd6fb8$38f1f8e0$aad5eaa0$%kang@samsung.com>
In-reply-to: <008301cd6fb8$38f1f8e0$aad5eaa0$%kang@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/2012 09:35 AM, Sungchun Kang wrote:
> I'm sorry to be so late.
> Basically, I wonder important one thing.
> What would you implement a device driver connected with gscaler.
> For example, fimc-lite, mipi-csis.
> As you know Exynos5 has local-path with gscaler
> MIPI-CSIS => Fimc-lite => Gscaler
> And, you should use media control framework.
> So, We made exynos folder, and implement drivers with mc.
> We use mdev that is virtual device driver for connecting gscaler, fimc-lite, mipi-csis with MC.
> This is camera path. 
> There are not only camera path but also rendering path.
> Gscaler => FIMD or TV
> Rendering path use mdev-0,
> Camera path use mdev-1.
> In conclusion, because we use to connect each other devices with MC, we made exynos folder.
> 
> And how you make to implement devices with MC?

As you may know, these patches only add mem-to-mem functionality,
which can be used together with the Exynos multi-format video codec.

Remaining features, as you listed, are planned to be added later,
in subsequent steps, after discussing it here on the mailing list.

I think it's much better approach, than coming up with a complete huge
driver with many API compliance issues. Especially that some drivers,
like MIPI-CSIS or FIMC-LITE are already in the mainline kernel.

As for the driver directory name, IMHO drivers/media/exynos is too
generic, s5p-fimc, s5p-jpeg, s5p-tv also cover some Exynos SoCs.

I don't think having drivers/media/exynos directory would be helpful
in anything.

Regards,
Sylwester
