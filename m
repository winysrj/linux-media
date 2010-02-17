Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab0BQXva (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 18:51:30 -0500
Message-ID: <4B7C80F5.5060405@redhat.com>
Date: Wed, 17 Feb 2010 21:51:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu> <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu> <4B7C303B.2040807@mailbox.hu>
In-Reply-To: <4B7C303B.2040807@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Istvan,

istvan_v@mailbox.hu wrote:
> The attached new patches contain all the previous changes merged, and
> are against the latest v4l-dvb revision.

Please provide your Signed-off-by. This is a basic requirement for your
driver to be accepted. Please read:
	http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

for instructions on how to submit a patch.

Cheers,
Mauro.

> 
> By the way, someone on a forum reported having a DTV1800 H card with
> a PCI ID of 107d:6f38. This seems to differ from the already supported
> DTV1800 H version (107d:6654) by having an XC4000 tuner instead of
> XC3028. From the Windows INF files it seems this card is very similar
> to the DTV2000 H Plus, but there is no GPIO for selecting antenna/cable
> input.
> 
> On 02/11/2010 08:16 PM, istvan_v@mailbox.hu wrote:
> 
>> Update: the following patch, which should be applied after the previous
>> ones, makes a few additional changes to the XC4000 driver:
>>   - adds support for DTV7
>>   - implements power management
>>   - adds a mutex and locking for tuner operations
>>   - some unused or unneeded code has been removed
>>
>> On 02/09/2010 06:35 PM, istvan_v@mailbox.hu wrote:
>>
>>> There are two separate patches for v4l-dvb revision 28f5eca12bb0: the
>>> first one adds the XC4000 driver, while the second one adds support for
>>> the Leadtek WinFast DTV2000H Plus card in the CX88 driver.
>>>
>>> http://www.sharemation.com/IstvanV/v4l/xc4000-28f5eca12bb0.patch
>>> http://www.sharemation.com/IstvanV/v4l/cx88-dtv2000h+-28f5eca12bb0.patch
>>>
>>> These new firmware files are more complete than the previous ones, but
>>> are not compatible with the original driver. Both version 1.2 and 1.4
>>> are available:
>>>
>>> http://www.sharemation.com/IstvanV/v4l/xc4000-1.2.fw
>>> http://www.sharemation.com/IstvanV/v4l/xc4000-1.4.fw
>>>
>>> The following simple utility was used for creating the firmware files.
>>>
>>> http://www.sharemation.com/IstvanV/v4l/xc4000fw.c


-- 

Cheers,
Mauro
