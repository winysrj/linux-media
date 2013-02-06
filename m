Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3BFLV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:21:26 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHS00GE1Q7L3A21@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 20:21:24 +0900 (KST)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Received: from [10.90.8.56] by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MHS00AVPQ7N1Q70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Feb 2013 20:21:24 +0900 (KST)
Message-id: <51123CC2.1020607@samsung.com>
Date: Wed, 06 Feb 2013 20:21:38 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>, kgene.kim@samsung.com,
	patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	sw0312.kim@samsung.com,
	=?UTF-8?B?J+yLrOykgOyYgSc=?= <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery support
 for G2D
References: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
 <1360128584-23167-2-git-send-email-sachin.kamat@linaro.org>
 <02a301ce043c$1b12d150$513873f0$%dae@samsung.com>
 <CAK9yfHyZrwdJV-Ct8Fby0uX1htHpAmJvCnX3VRYJSsey=L5HFA@mail.gmail.com>
 <02af01ce0447$37c26940$a7473bc0$%dae@samsung.com>
In-reply-to: <02af01ce0447$37c26940$a7473bc0$%dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2013년 02월 06일 17:51, Inki Dae wrote:
> 
> 
>> -----Original Message-----
>> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
>> Sent: Wednesday, February 06, 2013 5:03 PM
>> To: Inki Dae
>> Cc: linux-media@vger.kernel.org; dri-devel@lists.freedesktop.org;
>> devicetree-discuss@lists.ozlabs.org; k.debski@samsung.com;
>> s.nawrocki@samsung.com; kgene.kim@samsung.com; patches@linaro.org; Ajay
>> Kumar
>> Subject: Re: [PATCH v2 2/2] drm/exynos: Add device tree based discovery
>> support for G2D
>>
>> On 6 February 2013 13:02, Inki Dae <inki.dae@samsung.com> wrote:
>>>
>>> Looks good to me but please add document for it.
>>
>> Yes. I will. I was planning to send the bindings document patch along
>> with the dt patches (adding node entries to dts files).
>> Sylwester had suggested adding this to
>> Documentation/devicetree/bindings/media/ which contains other media
>> IPs.
> 
> I think that it's better to go to gpu than media and we can divide Exynos
> IPs into the bellow categories,
> 
> Media : mfc
> GPU : g2d, g3d, fimc, gsc
> Video : fimd, hdmi, eDP, MIPI-DSI

Hm, here is another considering point. Some device can be used as one of
two sub-system. For example g2d can be used as V4L2 driver or DRM
driver. And more specific case, multiple fimc/gsc deivces can be
separately used as both drivers: two fimc devices are used as V4L2
driver and other devices are used as DRM driver.
Current discussion, without change of build configuration, device can be
only used as one driver.

So I want to discuss about how we can bind device and driver just with
dts configuration.

IMO, there are two options.

First, driver usage is set on configurable node.
	g2d: g2d {
		compatible = "samsung,exynos4212-g2d";
                ...
                *subsystem = "v4l2"* or *subsystem = "drm"*
	};
Node name and type is just an example to describe.
With this option, driver which is not matched with subsystem node should
return with fail during its probing.

Second, using dual compatible strings.
	g2d: g2d {
		*compatible = "samsung,exynos4212-v4l2-g2d"; or
                compatible = "samsung,exynos4212-v4l2-g2d";*
                ...
	};
String is just an example so don't mind if it is ugly. Actually, with
this option, compatible string has non HW information. But this option
does not need fail in probing.

I'm not sure these options are fit to DT concept. Please let me know if
anyone has idea.

Best Regards,
- Seung-Woo Kim

> 
> And I think that the device-tree describes hardware so possibly, all
> documents in .../bindings/drm/exynos/* should be moved to proper place also.
> Please give  me any opinions.
> 
> Thanks,
> Inki Dae
> 
>>
>>>
>>> To other guys,
>>> And is there anyone who know where this document should be added to?
>>> I'm not sure that the g2d document should be placed in
>>> Documentation/devicetree/bindings/gpu, media, drm/exynos or arm/exynos.
>> At
>>> least, this document should be shared with the g2d hw relevant drivers
>> such
>>> as v4l2 and drm. So is ".../bindings/gpu" proper place?
>>>
>>
>>
>> --
>> With warm regards,
>> Sachin
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
