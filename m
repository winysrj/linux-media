Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40937 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbcCSIPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 04:15:42 -0400
Subject: Re: [PATCHv13 01/17] dts: exynos4*: add HDMI CEC pin definition to
 pinctrl
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
 <1458310036-19252-2-git-send-email-hans.verkuil@cisco.com>
 <20160319025040.GA7289@kozik-lap>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>, krzk@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56ED0AA3.1000601@xs4all.nl>
Date: Sat, 19 Mar 2016 09:15:31 +0100
MIME-Version: 1.0
In-Reply-To: <20160319025040.GA7289@kozik-lap>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2016 03:50 AM, Krzysztof Kozlowski wrote:
> On Fri, Mar 18, 2016 at 03:07:00PM +0100, Hans Verkuil wrote:
>> From: Kamil Debski <kamil@wypas.org>
>>
>> Add pinctrl nodes for the HDMI CEC device to the Exynos4210 and
>> Exynos4x12 SoCs. These are required by the HDMI CEC device.
>>
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos4210-pinctrl.dtsi | 7 +++++++
>>  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 7 +++++++
>>  2 files changed, 14 insertions(+)
> 
> Hi Hans,
> 
> I see you have been carrying these three patches for a long time.
> Initially I thought that there are some dependencies... but maybe there
> are not?
> 
> Can I take these Exynos DTS patches to samsung-soc?

That would be very nice!

BTW, it would be nice if someone from Samsung could try to improve the s5p
CEC driver from this patch series.

The problem is that it expects userspace to tell it the physical address,
which is read from the EDID. But the HDMI driver in the kernel already knows
this, so requiring userspace to handle this is not nice.

Basically the CEC driver needs to know when a new EDID has been read and
when the hotplug detect goes low (EDID has been lost).

If someone who actually knows the HDMI code could provide me with a patch,
then I can fix the CEC driver. I have an odroid to test with, so I can check
the code.

Regards,

	Hans
