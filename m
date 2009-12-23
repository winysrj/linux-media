Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:33043 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbZLWUBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 15:01:47 -0500
Message-ID: <4B327726.2080705@freenet.de>
Date: Wed, 23 Dec 2009 21:01:42 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: =?UTF-8?B?QWxqYcW+IFBydXNuaWs=?= <prusnik@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
References: <4B1D6194.4090308@freenet.de> <1261578615.8948.4.camel@slash.doma>	 <200912231753.28988.liplianin@me.by>	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de> <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
In-Reply-To: <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham schrieb:
> Hello Ruediger,
>
> On Wed, Dec 23, 2009 at 11:04 PM, Ruediger Dohmhardt
> <ruediger.dohmhardt@freenet.de> wrote:
>   
>> Aljaž Prusnik schrieb:
>>     
>>> If using the http://jusst.de/hg/v4l-dvb tree, everything compiles ok,
>>> module loads, but there is no remote anywhere (there is an IR folder
>>> with the ir-common.ko file, under common there is not).
>>>
>>>
>>>       
>> Aljaz, do you have the module mantis.ko?
>>
>> Ruediger
>>
>>     
>
> There was a build issue when i posted the link originally, but it had
> been fixed..
>
>   
Yupp, it works now!

I just downloaded version 2315248f648c. It compiles fine on Suse 11.1 and
it works here with vdr-1.7.10 and xineliboutput (from CVS).

However, as Aljaž also noted, the driver does not "autoload".
I need to do modprobe mantis.ko.

Manu, this used to work, but I do not remember when the "autoload was lost".


Ciao Ruediger D.

