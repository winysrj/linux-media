Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56593 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbZLWU0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 15:26:12 -0500
Received: by fxm25 with SMTP id 25so2329861fxm.21
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 12:26:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B327726.2080705@freenet.de>
References: <4B1D6194.4090308@freenet.de> <1261578615.8948.4.camel@slash.doma>
	 <200912231753.28988.liplianin@me.by>
	 <1261586462.8948.23.camel@slash.doma> <4B3269AE.6080602@freenet.de>
	 <1a297b360912231124v6e31c9e6ja24d205f6b5dc39@mail.gmail.com>
	 <4B327726.2080705@freenet.de>
Date: Thu, 24 Dec 2009 00:26:09 +0400
Message-ID: <1a297b360912231226j704e2c92jd9bb04cf23275829@mail.gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
From: Manu Abraham <abraham.manu@gmail.com>
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
Cc: =?UTF-8?Q?Alja=C5=BE_Prusnik?= <prusnik@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 24, 2009 at 12:01 AM, Ruediger Dohmhardt
<ruediger.dohmhardt@freenet.de> wrote:
> Manu Abraham schrieb:
>> Hello Ruediger,
>>
>> On Wed, Dec 23, 2009 at 11:04 PM, Ruediger Dohmhardt
>> <ruediger.dohmhardt@freenet.de> wrote:
>>
>>> Aljaž Prusnik schrieb:
>>>
>>>> If using the http://jusst.de/hg/v4l-dvb tree, everything compiles ok,
>>>> module loads, but there is no remote anywhere (there is an IR folder
>>>> with the ir-common.ko file, under common there is not).
>>>>
>>>>
>>>>
>>> Aljaz, do you have the module mantis.ko?
>>>
>>> Ruediger
>>>
>>>
>>
>> There was a build issue when i posted the link originally, but it had
>> been fixed..
>>
>>
> Yupp, it works now!
>
> I just downloaded version 2315248f648c. It compiles fine on Suse 11.1 and
> it works here with vdr-1.7.10 and xineliboutput (from CVS).
>
> However, as Aljaž also noted, the driver does not "autoload".
> I need to do modprobe mantis.ko.
>
> Manu, this used to work, but I do not remember when the "autoload was lost".


Have you run depmod ?

Regards,
Manu
