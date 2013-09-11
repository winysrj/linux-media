Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40108 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3IKJgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 05:36:11 -0400
Message-id: <52303988.40100@samsung.com>
Date: Wed, 11 Sep 2013 11:36:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, posciak@google.com,
	Arun Kumar K <arun.kk@samsung.com>
Subject: Re: [PATCH v2 3/5] [media] exynos-mscl: Add m2m functionality for the
 M-Scaler driver
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
 <1376909932-23644-4-git-send-email-shaik.ameer@samsung.com>
 <521F4ACD.3020302@samsung.com>
 <CAOD6ATpnYsh+EqH8_d2Dk8Y5r1x8OHQESkBiZFU4kt0fsNFSFA@mail.gmail.com>
In-reply-to: <CAOD6ATpnYsh+EqH8_d2Dk8Y5r1x8OHQESkBiZFU4kt0fsNFSFA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 09/10/2013 02:37 PM, Shaik Ameer Basha wrote:
> Hi Sylwester,
> 
> Almost all of the comments are already addressed.
> Will try to post the v3 by tomorrow.
> 
> I have one doubt?
> Do I need to rebase this driver on m2m-helpers-v2 or once the driver
> is merged we can take this up?

Sorry, I didn't even post an RFC for those helpers, I'll try to do it
today. Nevertheless this is something that isn't yet in mainline nor
in any stable branch, so don't worry about it. It can be handled easily
by a follow up patch, it would be mostly code deletion anyway.

--
Regards,
Sylwester
