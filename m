Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8384 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3CLNwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 09:52:44 -0400
Message-id: <513F3329.7050305@samsung.com>
Date: Tue, 12 Mar 2013 14:52:41 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [RFC 04/12] s5p-csis: Adding Exynos5250 compatibility
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
 <1362570838-4737-5-git-send-email-shaik.ameer@samsung.com>
 <513CEFA1.3030809@gmail.com>
 <CAOD6ATqa2QDsOmSe48zaOokdwb0cjuhoAigz1QBZm7hj-EE+rA@mail.gmail.com>
In-reply-to: <CAOD6ATqa2QDsOmSe48zaOokdwb0cjuhoAigz1QBZm7hj-EE+rA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 03/11/2013 07:58 AM, Shaik Ameer Basha wrote:
> Hi Sylwester,
> 
> On Mon, Mar 11, 2013 at 2:10 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>> On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
>>
>> Please don't leave the change log empty. I'll apply this patch.
>> I'm just wondering, if there aren't any further changes needed
>> to make the driver really working on exynos5250 ?
>>
> 
> There was nothing from driver side to change for making it work
> for Exynos5250. May be I need to update the S5P_INTMASK_EN_ALL
> to include all interrupts.

Yes, it might be a good idea squash that change into this patch,
i.e. the last patch form Arun's exynos5 fimc-is series. BTW, I'll
try to find a time to review the fimc-is patches this week.

Regards,
Sylwester
