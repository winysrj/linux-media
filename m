Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:61774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0J3BKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 21:10:06 -0400
Message-ID: <4CCB7061.1020400@redhat.com>
Date: Fri, 29 Oct 2010 23:09:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: h.ordiales@gmail.com
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Igor M. Liplianin" <liplianin@me.by>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: V4L/DVB/IR patches pending merge
References: <4CC25F60.7050106@redhat.com> <AANLkTimEQPK-HvM7BPrMt4LH=x2Gq7tCZfq0trzmkAcU@mail.gmail.com>
In-Reply-To: <AANLkTimEQPK-HvM7BPrMt4LH=x2Gq7tCZfq0trzmkAcU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-10-2010 21:02, Hernán Ordiales escreveu:
> 2010/10/23 Mauro Carvalho Chehab <mchehab@redhat.com>:
>> This is the list of patches that weren't applied yet. I've made a big effort starting
>> last weekend to handle everything I could. All pull requests were addressed. There are still
>> 43 patches on my queue.
>>
>> Please help me to clean the list.
>>
>> This is what we have currently:
> [snip]
>>                == Waiting for Patrick Boettcher <pboettcher@dibcom.fr> review ==
>>
>> May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>
>> Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
>> Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
>>
>> The first patch is probably broken.
>>
>> Hernán,
>> Could you please re-generate it?
> 
> Yes, i'm sending it as attachment (regenerated agaisnt trunk, 15168 revision)

Don't rebase against the mercurial tree. It is completely outdated. Use my git
tree, instead:

	http://git.linuxtv.org/media_tree.git

The IR should go to a separate file, and there's no need anymore to pass any parameter
to the driver, as the IR table now specifies the protocol, and the driver automatically
switches to NEC protocol, on devices using a NEC table.

Cheers,
Mauro
