Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1GWPJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 11:09:08 -0400
Message-ID: <4E2AE40F.7030108@infradead.org>
Date: Sat, 23 Jul 2011 12:09:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stas Sergeev <stsp@list.ru>
CC: linux-media@vger.kernel.org
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru>
In-Reply-To: <4E2ACAAD.4050602@list.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-07-2011 10:20, Stas Sergeev escreveu:
> 23.07.2011 17:06, Mauro Carvalho Chehab wrote:
>>> I would suggest fixing all such an apps, even if we
>>> are not going to change that in the driver.
>> If application needs to change due to a patch, this is a
>> regression,
> I said "even if we are not going to change that in the
> driver", which, imho, removes any ambiguity from my
> phrase.
> 
>>> But how can scantv (or anything else) rely on the
>>> fact that the board was muted when that app starts?
>>> I guess it can't, and mutes it explicitly first, no?
>> Even if it mutes, every time a channel is changed, it
>> will be unmuted, if you put such unmute logic at
>> VIDIOC_S_FREQUENCY.
> As I said, I propose the automute state to be a separate,
> _third_ state. mute/unmute/automute.
> Automute state is only set initially, but if the app
> explicitly sets any other state, it is no longer affected.
> Since an app can't rely on the state before it was
> started, it should set the mute state explicitly first.
> In this case, it will not be autounmuted after tuning.

Hard to tell about your solution without seeing a patch.

Not sure if this will be consistent, especially if PA
restarts for whatever reason (X restart? manual restart?).

Anyway, we're discussing a lot for a kernel fix for PA,
while the right thing to do is to fix PA itself.

Mauro.
