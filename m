Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:41274 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2KNUqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 15:46:14 -0500
Message-ID: <50A4030C.70306@sfr.fr>
Date: Wed, 14 Nov 2012 21:46:04 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: =?iso-8859-1?b?RnLpZOlyaWM=?= <fma@gbiloba.org>
CC: linux-media@vger.kernel.org, rjkm@metzlerbros.de,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Support for Terratec Cinergy 2400i DT in kernel 3.x
References: <201211131040.22114.fma@gbiloba.org> <50A2C0C4.9040607@sfr.fr>
	<201211140948.00913.fma@gbiloba.org>
In-Reply-To: <201211140948.00913.fma@gbiloba.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frédéric,

You are right, in the ngene initial commit
(dae52d009fc950b5c209260d50fcc000f5becd3c), no fw_version was set, so by
default the ngene_15.fw is selected.

But in the patch available here
http://wiki.ubuntuusers.de/_attachment?target=/Terratec_Cinergy_2400i_DT/ngene_p11.tar.gz,
fw_version = 17 was set in ngene_info_terratec struct.

Before submitting the ngene patch set i have done tests with all
available firmware without noticing any difference.

I really don't known what are the difference between ngene_15.fw and
ngene_17.fw

Perhaps Ralph or Mauro has the answer ?



On 14/11/2012 09:48, Frédéric wrote:
> Le mardi 13 novembre 2012, Patrice Chotard a écrit :
> 
>> Two patches have been already submitted and are available since v3.7-rc1
>>
>> media] ngene: add support for Terratec Cynergy 2400i Dual DVB-T  :
>> 397e972350c42cbaf3228fe2eec23fecf6a69903
>>
>> and
>>
>> media] dvb: add support for Thomson DTT7520X :
>> 5fb67074c6657edc34867cba78255b6f5b505f12
> 
> I had a look at your patches. I don't see the '.fw_version' param anymore in the 'ngene_info' 
> structure... Is it normal?
> 
