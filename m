Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:39756 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1B1QJ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 11:09:59 -0500
Message-ID: <4D6BC8D4.3080001@linuxtv.org>
Date: Mon, 28 Feb 2011 17:09:56 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Mariusz Bialonczyk <manio@skyboo.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK
 FAILED" issue
References: <4D3358C5.5080706@skyboo.net> <4D6B88DD.4040500@skyboo.net> <201102281741.26950.liplianin@me.by>
In-Reply-To: <201102281741.26950.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Igor,

On 02/28/2011 04:41 PM, Igor M. Liplianin wrote:
> В сообщении от 28 февраля 2011 13:37:01 автор Mariusz Bialonczyk написал:
>> On 2011-01-16 21:44, Mariusz Bialonczyk wrote:
>>> Fixing the very annoying tunning issue. When switching from DVB-S2 to
>>> DVB-S, it often took minutes to have a lock.
>>>
>>  > [...]
>>>
>>> The patch is changing the frontend from stv0900 to stv090x.
>>> The card now works much more reliable. There is no problem with switching
>>> from DVB-S2 to DVB-S, tunning works flawless.
>>
>> Igor, can I get your ACK on this patch?
>>
>> regards,
> Never. 
> Think first what you are asking for.

for those who aren't involved in the development of these drivers, may I
ask you what's the problem with this patch?

Regards,
Andreas
