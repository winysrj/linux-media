Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:51258 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3EUOrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 10:47:08 -0400
Received: by mail-la0-f44.google.com with SMTP id fr10so789736lab.31
        for <linux-media@vger.kernel.org>; Tue, 21 May 2013 07:47:06 -0700 (PDT)
Message-ID: <519B88E8.3040101@cogentembedded.com>
Date: Tue, 21 May 2013 18:47:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: phil.edworthy@renesas.com
CC: vladimir.barinov@cogentembedded.com, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, matsu@igel.co.jp, mchehab@redhat.com
Subject: Re: [PATCH v5] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201305180101.11383.sergei.shtylyov@cogentembedded.com> <OFC9B7B505.2CDF0AA3-ON80257B71.00291B65-80257B71.002952EB@eu.necel.com> <519A1FFC.6000304@cogentembedded.com> <OF0ABE628B.1C271A20-ON80257B72.002ED824-80257B72.003627CD@LocalDomain> <OF7D5F7F7E.CF4ED120-ON80257B72.0042ED42-80257B72.004332EB@eu.necel.com>
In-Reply-To: <OF7D5F7F7E.CF4ED120-ON80257B72.0042ED42-80257B72.004332EB@eu.necel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 21-05-2013 16:13, phil.edworthy@renesas.com wrote:

>>>>> Subject: [PATCH v5] V4L2: soc_camera: Renesas R-Car VIN driver

>>>>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>>>>> Add Renesas R-Car VIN (Video In) V4L2 driver.

>>>>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

>>>> I've seen old patches that add VIN to the Marzen board, do you have an
>>>> updated version?

>>>      The last version of that patchset is 4, here it is archived:

>>> http://marc.info/?l=linux-sh&m=136865481429756
>>> http://marc.info/?l=linux-sh&m=136865499029807
>>> http://marc.info/?l=linux-sh&m=136865509129843
>>> http://marc.info/?l=linux-sh&m=136865520029900

>> First of all, thank you for your work on this driver.

>> I have tried your patches on the Marzen board using an Expansion
>> Board with an OmniVision 10635 camera (progressive BT656), using an
>> out-of-tree driver. There appears to be an issue with the interrupt
>> handling compared to my original driver.

>> I realise that you don't have the Marzen Expansion Board & don't
>> have an ov10635 camera. However, unfortunately, I don't have much
>> time that I can spend on this. Do any of the boards you have use a
>> progressive camera?

    No. Is there any way you can send us that expansion board? It seems
the only way we can get some progress on this issue.

> Oops, the comments about the captured image contents are my fault.
> However, the unhandled irq after stopping capture is still an issue.

    Thanks for letting us know.

> Regards
> Phil

WBR, Sergei

