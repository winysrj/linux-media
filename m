Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45042 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3ASI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 20:18:08 -0400
Message-ID: <5270503C.8070200@gmail.com>
Date: Wed, 30 Oct 2013 01:18:04 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
	Grant Likely <grant.likely@linaro.org>,
	Arun Kumar K <arun.kk@samsung.com>,
	Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [GIT PULL FOR 3.13] Exynos5 SoC FIMC-IS imaging subsystem driver
References: <5261967E.6010001@samsung.com> <20131028201136.6f66d3f7@samsung.com> <526EFC06.70101@gmail.com> <20131029105426.0969741c.m.chehab@samsung.com>
In-Reply-To: <20131029105426.0969741c.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/2013 01:54 PM, Mauro Carvalho Chehab wrote:
[...]
> Yeah, it seems that we've waited for a long time to get an ack there.
>
> So, let's do this:
>
> Please send a new version with Mark's comments. Also, please split Doc
> changes from the code changes on the new series. I'll wait for a couple
> days for DT people to review it. If we don't have any reply, I'll review
> and apply it for Kernel 3.13, if I don't see anything really weird on it.

Ok, I will make sure all DT binding documentation is in separate patches,
actually only one patch needs to be reworked.

Since Mark already reviewed the FIMC-IS and the S5K4E5 image sensor DT
binding patches the only one which may need further review is this one:
https://patchwork.linuxtv.org/patch/20237

Arun, could you send us the updated series ? Unfortunately I might not be
able to find time to address those comments myself until Friday.

--
Thanks,
Sylwester
