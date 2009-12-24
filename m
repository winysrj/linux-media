Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:34742 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZLXQpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 11:45:10 -0500
Message-ID: <4B339A8F.8020201@freenet.de>
Date: Thu, 24 Dec 2009 17:45:03 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: =?UTF-8?B?QWxqYcW+IFBydXNuaWs=?= <prusnik@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
References: <4B1D6194.4090308@freenet.de>	 <1261578615.8948.4.camel@slash.doma> <200912231753.28988.liplianin@me.by>	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com> <1261611901.8948.37.camel@slash.doma>
In-Reply-To: <1261611901.8948.37.camel@slash.doma>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aljaž Prusnik schrieb:
> On sre, 2009-12-23 at 23:24 +0400, Manu Abraham wrote:
>   
>>> Aljaz, do you have the module mantis.ko?
>>>       
>> There was a build issue when i posted the link originally, but it had
>> been fixed..
>>
>> manu@manu-04:/stor/work/merge/v4l-dvb/v4l> ls *.ko |grep mantis
>> mantis_core.ko
>> mantis.ko
>>
>>     
>
> Yup, I have both of them. I just compiled http://jusst.de/hg/v4l-dvb
> again and the result is (depmode -a was run):
>
> - ir-common.ko is under drivers/media/common (not drivers/media/IR like
> Igor suggested but that is probably because it's a different
> repository).
> - mantis.ko and mantis_core.ko are under drivers/media/dvb/mantis
>
>   
Aljaž, thanks for the "reply". As Manu said above there was a build problem.
As said already in this Thread, I downloaded version 2315248f648c, which
compiles fine and
has all modules for the 2033 DVB-C.

Rüdiger


