Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40990 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3JLLUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 07:20:53 -0400
Message-ID: <52593091.2080209@gmail.com>
Date: Sat, 12 Oct 2013 13:20:49 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	pawel@osciak.com, javier.martin@vista-silicon.com,
	m.szyprowski@samsung.com, shaik.ameer@samsung.com,
	arun.kk@samsung.com, k.debski@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC 6/7] exynos-gsc: Use mem-to-mem ioctl helpers
References: <1379076986-10446-1-git-send-email-s.nawrocki@samsung.com> <1379076986-10446-7-git-send-email-s.nawrocki@samsung.com> <5249495A.6010101@xs4all.nl>
In-Reply-To: <5249495A.6010101@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/2013 11:50 AM, Hans Verkuil wrote:
> On 09/13/2013 02:56 PM, Sylwester Nawrocki wrote:
>> >  Simplify the driver by using the m2m ioctl and vb2 helpers.
>> >
>> >  TODO: Add setting of default initial format.
>
> So this patch can't be applied yet.

Indeed, it's just an RFC series, I wanted it to give an overview of
how much code can be eliminated with those helpers and posted this
series regardless of availability of the pre-requisite cleanups,
which I might or might not have time to prepare.

Anyway I've already written those missing patches and these may be
included in the final series, as soon as people Ack and test the
patches where I couldn't test myself.

> Other than that it looks good, but I won't ack it since it introduces a regression
> as long as the TODO isn't addressed.

Thanks, whole series updated to follow.

--
Regards,
Sylwester
