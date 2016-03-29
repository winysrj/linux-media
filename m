Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51697 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727AbcC2H3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 03:29:08 -0400
Subject: Re: [PATCHv14 03/18] dts: exynos4412-odroid*: enable the HDMI CEC
 device
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
 <1458911416-47981-4-git-send-email-hverkuil@xs4all.nl>
 <CAJKOXPdpkE5OdNEAVTsbQrjpZZgwDgY2=g9ocM0rFaOU-N=pEw@mail.gmail.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56FA2EB9.5040204@xs4all.nl>
Date: Tue, 29 Mar 2016 09:28:57 +0200
MIME-Version: 1.0
In-Reply-To: <CAJKOXPdpkE5OdNEAVTsbQrjpZZgwDgY2=g9ocM0rFaOU-N=pEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

On 03/29/2016 08:28 AM, Krzysztof Kozlowski wrote:
> On Fri, Mar 25, 2016 at 10:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> Add a dts node entry and enable the HDMI CEC device present in the Exynos4
>> family of SoCs.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 4 ++++
>>  1 file changed, 4 insertions(+)
> 
> Applied for v4.7 with a little bit different subject and the new node
> put in alphabetical order. Please don't include your original patch in
> your tree because any merging will probably end with having these
> nodes twice.

Thanks for merging these three via your tree. I've dropped these three patches
from my tree to avoid any merge issues.

Regards,

	Hans

> 
> https://git.kernel.org/cgit/linux/kernel/git/krzk/linux.git/log/?h=next/dt
> (but tell me if you need to base on this so I would prepare a tag)
> 
> Best regards,
> Krzysztof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
