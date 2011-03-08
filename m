Return-path: <mchehab@pedra>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:56314 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab1CHRtG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 12:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=DYfXubPH0fkwFQSHHqW64tQ11K-yKCfx9PVMv@mail.gmail.com>
References: <4D6D219D.7020605@matrix-vision.de>
	<201103022018.23446.laurent.pinchart@ideasonboard.com>
	<4D6FBC7F.1080500@matrix-vision.de>
	<AANLkTikAKy=CzTqEv-UGBQ1EavqmCStPNFZ5vs7vH5VK@mail.gmail.com>
	<4D70F985.8030902@matrix-vision.de>
	<AANLkTinSJpjPXWHWduLbRSmb=La3sv82ufwgsq-uR7S2@mail.gmail.com>
	<AANLkTi=8Sss-5xfgPmgx=J_T__=hrC1rQU-xBOdKC8Ve@mail.gmail.com>
	<4D74D94F.7040702@matrix-vision.de>
	<AANLkTikokA2hGMYA3vfBOxa0jPr0tjbLfYW603+zicry@mail.gmail.com>
	<AANLkTikzAjUrec+c6zcSCx6auaR9QvbWwwTbXpGYuOoZ@mail.gmail.com>
	<AANLkTi=KncNfW0NEEoV+mrT_Ft2j-c=rQG=qbeR6tLQK@mail.gmail.com>
	<4D75F343.8090505@maxwell.research.nokia.com>
	<AANLkTi=DYfXubPH0fkwFQSHHqW64tQ11K-yKCfx9PVMv@mail.gmail.com>
Date: Tue, 8 Mar 2011 11:49:04 -0600
Message-ID: <AANLkTin7SgyN=23rp4a3sPpURLDewR68OScWJC2QGfPD@mail.gmail.com>
Subject: Re: [PATCH] omap: iommu: disallow mapping NULL address
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Michael Jones <michael.jones@matrix-vision.de>,
	Hiroshi.DOYU@nokia.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 3:55 AM, David Cohen <dacohen@gmail.com> wrote:
> Hi Fernando,
>
> On Tue, Mar 8, 2011 at 11:13 AM, Sakari Ailus
> <sakari.ailus@maxwell.research.nokia.com> wrote:
>> Guzman Lugo, Fernando wrote:
>>> On Mon, Mar 7, 2011 at 1:19 PM, David Cohen <dacohen@gmail.com> wrote:
>>>> On Mon, Mar 7, 2011 at 9:17 PM, Guzman Lugo, Fernando
>>>> <fernando.lugo@ti.com> wrote:
>>>>> On Mon, Mar 7, 2011 at 7:10 AM, Michael Jones
>>>>> <michael.jones@matrix-vision.de> wrote:
>>>>>> From e7dbe4c4b64eb114f9b0804d6af3a3ca0e78acc8 Mon Sep 17 00:00:00 2001
>>>>>> From: Michael Jones <michael.jones@matrix-vision.de>
>>>>>> Date: Mon, 7 Mar 2011 13:36:15 +0100
>>>>>> Subject: [PATCH] omap: iommu: disallow mapping NULL address
>>>>>>
>>>>>> commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb allowed mapping
>>>>>> the NULL address if da_start==0.  Force da_start to exclude the
>>>>>> first page.
>>>>>
>>>>> what about devices that uses page 0? ipu after reset always starts
>>>>> from 0x00000000 how could we map that address??
>>>>
>>>> from 0x0? The driver sees da == 0 as error. May I ask you why do you want it?
>>>
>>> unlike DSP that you can load a register with the addres the DSP will
>>> boot, IPU core always starts from address 0x00000000, so if you take
>>> IPU out of reset it will try to access address 0x0 if not map it,
>>> there will be a mmu fault.
>>
>> I think the driver for IPU (what is it, btw.?) must map the NULL address
>> explicitly. It cannot rely on automatic allocation of the NULL address
>> by the iommu even if it was the first allocation.
>
> That's an interesting question. My first thought was "it's not
> automatic allocation", because it seems you know the specific 'da' IPU
> needs. But then, looking into the driver's API, the automatic
> allocation is defined whether the argument da == 0 (automatic
> allocation) or da != 0 (fixed da). So, by default, the IOMMU driver
> does not see da == 0 as valid address for fixed da. Then, why only
> automatic allocation should use such address? My second point is: if
> you're using automatic allocation, you *cannot* rely on specific da to
> be used, as it would be up to IOMMU driver to choose. So, doesn't
> matter the option, your driver seems to be wrong, unless I'm missing
> something. If you were using fixed da passing da = 0, you were just
> being lucky that it was the first request and automatic allocation
> returned da == 0.

yes, the driver is wrong, it should use only flag IOVMF_DA_ANON to get
an automatic address. it has to be changed too.

Regards,
Fernando.

> IMO either first page is not allowed at all or OMAP's IOMMU API should
> change the way it checks if it's fixed da or not.
>
> Kind regards,
>
> David
>
>>
>> --
>> Sakari Ailus
>> sakari.ailus@maxwell.research.nokia.com
>>
>
