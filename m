Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:36799 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045Ab0J2XYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 19:24:09 -0400
Message-ID: <4CCB5790.60904@iki.fi>
Date: Sat, 30 Oct 2010 02:24:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: h.ordiales@gmail.com
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Igor M. Liplianin" <liplianin@me.by>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L/DVB/IR patches pending merge
References: <4CC25F60.7050106@redhat.com> <AANLkTimEQPK-HvM7BPrMt4LH=x2Gq7tCZfq0trzmkAcU@mail.gmail.com>
In-Reply-To: <AANLkTimEQPK-HvM7BPrMt4LH=x2Gq7tCZfq0trzmkAcU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/30/2010 02:02 AM, Hernán Ordiales wrote:
> 2010/10/23 Mauro Carvalho Chehab<mchehab@redhat.com>:
>> This is the list of patches that weren't applied yet. I've made a big effort starting
>> last weekend to handle everything I could. All pull requests were addressed. There are still
>> 43 patches on my queue.
>>
>> Please help me to clean the list.
>>
>> This is what we have currently:
> [snip]
>>                 == Waiting for Patrick Boettcher<pboettcher@dibcom.fr>  review ==
>>
>> May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales<h.ordiales@gmail.com>
>> Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich<qy03fugy@stud.informatik.uni-erlangen.de>
>> Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich<qy03fugy@stud.informatik.uni-erlangen.de>
>>
>> The first patch is probably broken.
>>
>> Hernán,
>> Could you please re-generate it?
>
> Yes, i'm sending it as attachment (regenerated agaisnt trunk, 15168 revision)
>
> Cheers

Your keytable seems to be wrong since it have both keycode and its 
complement (which is used for error check normally). I think it is NEC 
remote? In that case address byte is typically same for all buttons.

Antti
-- 
http://palosaari.fi/
