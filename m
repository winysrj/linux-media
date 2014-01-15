Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:44014 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaAOVzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 16:55:51 -0500
Message-ID: <52D703E2.7000103@tu-dortmund.de>
Date: Wed, 15 Jan 2014 22:55:46 +0100
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: Patch for TechnoTrend S2-4600
References: <52C9975A.2060900@tu-dortmund.de> <20140115144238.07f7261f@samsung.com>
In-Reply-To: <20140115144238.07f7261f@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

thanks for you reply.

Sorry, i was not aware of the fact that i have to ask the author. :-( 
They published it at bitbucket. Thus i thought it is okay to propose a 
patch.
In which kernel tree was it merged? The mainline one at kernel.org?

Regards,
Alex

On 01/15/2014 05:42 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 05 Jan 2014 18:33:14 +0100
> Alexander Lochmann <alexander.lochmann@tu-dortmund.de> escreveu:
>
>> Hi guys,
>>
>> i'm sending you a patch that adds support for the TechnoTrend S2-4600
>> DVB-S2 device to a 3.12 (5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52)
>> mainline kernel.
>> I just extracted the drivers for the two frontends (ds3103 and ts2202)
>> from [1] and added them to a mainline kernel. Furthermore, i modified
>> the dw2102 driver to support the new frontends (= copied the necessary
>> lines of code from the origin dw2102) . In addition, i attached a
>> firmware for the dw2102 extracted from [3].
>> I appreciate, if you review my patch and may integrate it into the
>> mainline tree.
> Hi Alexander,
>
> You can't simply extract those patches from some other tree and send, without
> the driver's author ack.
>
> Also, recently a driver for ts2202 and ds3103 was merged in the Kernel. It
> may not have the IDs for your device, but it shouldn't likely be hard to
> add support for it, if you have some programming skills.
>
> Regards,
> Mauro
>
>> Thank you!
>> Greetings
>> Alex
>>
>> [1]
>> https://bitbucket.org/liplianin/s2-liplianin-v37/get/67ce08afdbe7.tar.bz2
>> [2] http://www.tt-downloads.de/Linux/s2-TT4600-linux-20120815.tgz
>> [3] http://www.tt-downloads.de/Linux/linux_tt-connect_s2-4600.pdf
>

