Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40280 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbcLORqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 12:46:38 -0500
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
To: Nicholas Mc Guire <der.herr@hofr.at>
References: <CGME20161213015743epcas3p19867fa74e5ffe2974364d317d9b494f6@epcas3p1.samsung.com>
 <1481594282-12801-1-git-send-email-hofrat@osadl.org>
 <ae02dfc1-39b9-f7f7-5168-d00e4ad75db7@samsung.com> <5277658.1FioEDcST1@avalon>
 <fe6f6e06-be7a-9a66-7723-7b37a0ae1675@samsung.com>
 <20161215011405.GB22190@osadl.at>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <32517dbe-f893-fb7e-e3e2-dca7f6ca5e7f@samsung.com>
Date: Thu, 15 Dec 2016 18:45:54 +0100
MIME-version: 1.0
In-reply-to: <20161215011405.GB22190@osadl.at>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2016 02:14 AM, Nicholas Mc Guire wrote:
> if its actually unused then it might be best to completely drop the code
> raher than fixing up dead-code. Is the EXYNOS the only system that had
> this device in use ? If it shold stay in then setting it to the above
> proposed 3000, 4000 would seem the most resonable to me as I asume this
> change would stay untested.

I agree, there little sense in modifying unused code which cannot be
tested anyway. The whole driver is a candidate for removal as it has
no users in mainline. AFAIK it had only been used on Exynos platforms.
I'd suggest to just drop the delay call, there are already usleep_range()
calls after the GPIO state change. IIRC the delay was needed to ensure
proper I2C bus operation after enabling the voltage level translator,
but I'm not 100% sure.

-- 
Thanks,
Sylwester
