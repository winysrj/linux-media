Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47460 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3JTSZ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 14:25:28 -0400
Message-ID: <5264200E.5060706@gmail.com>
Date: Sun, 20 Oct 2013 20:25:18 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Arun Kumar K <arun.kk@samsung.com>,
	Pawel Osciak <posciak@google.com>,
	Inki Dae <inki.dae@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH v4 1/4] [media] exynos-scaler: Add new driver for Exynos5
 SCALER
References: <1380889594-10448-1-git-send-email-shaik.ameer@samsung.com> <1380889594-10448-2-git-send-email-shaik.ameer@samsung.com> <5260F7F3.20802@samsung.com> <CAOD6ATqPrt8FsTFA-YR8-AJDrwFmQ=vYCGYO_bVi3rt-Ra7Ocg@mail.gmail.com>
In-Reply-To: <CAOD6ATqPrt8FsTFA-YR8-AJDrwFmQ=vYCGYO_bVi3rt-Ra7Ocg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 10/20/2013 02:33 PM, Shaik Ameer Basha wrote:
> On Fri, Oct 18, 2013 at 5:57 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com>  wrote:
>> >  Hi,
>> >
>> >  I have couple minor comments. These could be addressed in follow up
>> >  patches, it you won't manage to do it today. Sorry for being late with
>> >  this.
>
> Sorry for the late reply.
>
> Currently I am on travel and I don't have the environment to rebase
> and test this driver.
> I will address your comments in follow up patches.
>
> Can you please queue this driver to your branch and send a pull
> request for 3.13 ?

The driver seems to be in quite a good shape now and I think it would
have been bad not to merge it in this release. I'll let Kamil handle
it as he's a sub-maintainer of the v4l2 mem-to-mem drivers.

Regards,
Sylwester
