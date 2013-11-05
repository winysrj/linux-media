Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:38534 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KEEVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 23:21:48 -0500
MIME-Version: 1.0
In-Reply-To: <5270503C.8070200@gmail.com>
References: <5261967E.6010001@samsung.com>
	<20131028201136.6f66d3f7@samsung.com>
	<526EFC06.70101@gmail.com>
	<20131029105426.0969741c.m.chehab@samsung.com>
	<5270503C.8070200@gmail.com>
Date: Tue, 5 Nov 2013 09:51:47 +0530
Message-ID: <CALt3h78rZou7i4riQ=-aMnO4e0bsV22C7MNWDSt-UukpKsj1Zg@mail.gmail.com>
Subject: Re: [GIT PULL FOR 3.13] Exynos5 SoC FIMC-IS imaging subsystem driver
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
	Grant Likely <grant.likely@linaro.org>,
	Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sorry for the delayed response as I was on leave.
I will address the comments from Mark today itself and post those DT
binding patches.

Regards
Arun

On Wed, Oct 30, 2013 at 5:48 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 10/29/2013 01:54 PM, Mauro Carvalho Chehab wrote:
> [...]
>
>> Yeah, it seems that we've waited for a long time to get an ack there.
>>
>> So, let's do this:
>>
>> Please send a new version with Mark's comments. Also, please split Doc
>> changes from the code changes on the new series. I'll wait for a couple
>> days for DT people to review it. If we don't have any reply, I'll review
>> and apply it for Kernel 3.13, if I don't see anything really weird on it.
>
>
> Ok, I will make sure all DT binding documentation is in separate patches,
> actually only one patch needs to be reworked.
>
> Since Mark already reviewed the FIMC-IS and the S5K4E5 image sensor DT
> binding patches the only one which may need further review is this one:
> https://patchwork.linuxtv.org/patch/20237
>
> Arun, could you send us the updated series ? Unfortunately I might not be
> able to find time to address those comments myself until Friday.
>
> --
> Thanks,
> Sylwester
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
