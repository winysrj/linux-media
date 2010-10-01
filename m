Return-path: <mchehab@pedra>
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:18796 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab0JAIMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 04:12:07 -0400
Message-ID: <4CA5963C.3070202@Free.fr>
Date: Fri, 01 Oct 2010 10:05:16 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <201009301956.50154.yann.morin.1998@anciens.enib.fr> <4CA4F640.7030206@iki.fi> <201009302309.58546.yann.morin.1998@anciens.enib.fr> <4CA505C9.1040400@iki.fi>
In-Reply-To: <4CA505C9.1040400@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 09/30/2010 11:48 PM, Antti Palosaari wrote:
> Moi Yann
>
> On 10/01/2010 12:09 AM, Yann E. MORIN wrote:
>> Antti, All,
>>
>> On Thursday 30 September 2010 22:42:40 Antti Palosaari wrote:
>>> On 09/30/2010 08:56 PM, Yann E. MORIN wrote:
>>>> OK. The number of supported devices is already 9 in all sections, so
>>>> I guess
>>>> I'll have to add a new entry in the af9015_properties array, before
>>>> I can
>>>> add a new device, right?
>>> Actually you are using too old code as base. You should take latest GIT
>>> media tree and 2.6.37 branch.
>>
>> I'm using the latest tree from:
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>>
>> Is that OK?
>
> No, it is too old. Correct tree is staging/v2.6.37 at:
> http://git.linuxtv.org/media_tree.git

Antti,

just a side comment: the web pages at http://linuxtv.org are, how could 
I say it politely, confusing.

The cvs page are still there but speak about mercurial. The hg page 
speak about git and points to the wrong repository

V4L-DVB repository (http://git.linuxtv.org/v4l-dvb.git)	Git repository 
with V4L/DVB patches for next kernels 	Mauro Carvalho Chehab 	RSS


>> Anyway, before you get action and push this patch, Eric helped in the
>> testing
>> so far. Maybe he'll want to add his tested-by?

I would prefer to have better web pages for the project ;-)

Thanks for the good work anyway,

--eric
