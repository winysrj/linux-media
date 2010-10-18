Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41170 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0JRI6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 04:58:03 -0400
Received: by iwn35 with SMTP id 35so923537iwn.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 01:58:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010151417.38508.laurent.pinchart@ideasonboard.com>
References: <AANLkTikq8pmOpGn1N4xbiB2nmsNzrC4wzcD0_HUJpZ1J@mail.gmail.com>
	<201010151417.38508.laurent.pinchart@ideasonboard.com>
Date: Mon, 18 Oct 2010 10:58:02 +0200
Message-ID: <AANLkTi=Lck0P+YS3qX+aTK-g+jPmg3BkhHNoWOVXZcX9@mail.gmail.com>
Subject: Re: OMAP 3530 ISP driver segfaults
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2010/10/15 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Friday 15 October 2010 13:59:24 Bastian Hecht wrote:
>> Hello ISP driver developers,
>>
>> after the lastest pull of branch 'devel' of
>> git://gitorious.org/maemo-multimedia/omap3isp-rx51 I get a segfault
>> when I register my ISP_device.
>> The segfault happens in isp.c in line
>>      isp->iommu = iommu_get("isp");
>>
>> I noticed that with the new kernel the module iommu is loaded
>> automatically after booting while it wasn't in before my pull (my old
>> pull is about 3 days old).
>> Tell me what kind of further info you need. Btw, I run an Igepv2.
>
> Can you make sure that both the omap-iommu and iommu2 modules are loaded
> before omap3-isp.ko ?

Hello Laurent,

that did the trick! Don't get dependencies checked at load time? I
mean undefined functions lead to load errors. I just want to learn to
be prepared next time. So was it some data structure that gets
properly initilized by iommu2 so that insmod cannot see the error?

Thanks for enlightenment,

 Bastian


> --
> Regards,
>
> Laurent Pinchart
>
