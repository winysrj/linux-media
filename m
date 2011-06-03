Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab1FCOEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 10:04:46 -0400
Message-ID: <4DE8E9EF.9010804@redhat.com>
Date: Fri, 03 Jun 2011 11:04:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
References: <4DDD69AE.3070606@iki.fi> <4DE63E43.1090208@redhat.com> <4DE8D4CD.7070708@iki.fi>
In-Reply-To: <4DE8D4CD.7070708@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 09:34, Antti Palosaari escreveu:
> On 06/01/2011 04:27 PM, Mauro Carvalho Chehab wrote:
>> Em 25-05-2011 17:42, Antti Palosaari escreveu:
>>> Antti Palosaari (7):
>>>        em28xx-dvb: add module param "options" and use it for LNA
>>
>> That patch is ugly, for several reasons:
>>
>> 1) we don't want a generic "options" parameter, whose meaning changes from
>>     device to devices;
> 
> I agree it is not proper solution, but in my mind it is better to offer some solution than no solution at all.
> 
>> 2) what happens if someone has two em28xx devices plugged?
> 
> It depends depends devices, currently only nanoStick T2 only looks that param, other just ignore. If there is two nanoStics then both have same LNA settings.
> 
> That's just like same behaviour as for example remote controller polling. Or for example DiBcom driver LNA, since it does have similar module param already. Will you you commit it if I rename it similarly as DiBcom?
> 
>> 3) the better would be to detect if LNA is needed, or to add a DVBS2API
>>     call to enable/disable LNA.
> 
> True, but it needs some research. There is many hardware which gets signal input from demod or tuner and makes some fine tune according to that. We need to define some new callbacks for demod and tuner in order to do this kind of actions.
> Or just add new LNA param to API use it manually.

I would then just add a LNA option via DVBS2API to allow enabling/disabling it.
(LNA enabled seems to be the better default).

Modprobe parameters for things like that sucks.

Cheers,
Mauro
