Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:54410 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1FCMeY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 08:34:24 -0400
Message-ID: <4DE8D4CD.7070708@iki.fi>
Date: Fri, 03 Jun 2011 15:34:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Steve Kerrison <steve@stevekerrison.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
References: <4DDD69AE.3070606@iki.fi> <4DE63E43.1090208@redhat.com>
In-Reply-To: <4DE63E43.1090208@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/01/2011 04:27 PM, Mauro Carvalho Chehab wrote:
> Em 25-05-2011 17:42, Antti Palosaari escreveu:
>> Antti Palosaari (7):
>>        em28xx-dvb: add module param "options" and use it for LNA
>
> That patch is ugly, for several reasons:
>
> 1) we don't want a generic "options" parameter, whose meaning changes from
>     device to devices;

I agree it is not proper solution, but in my mind it is better to offer 
some solution than no solution at all.

> 2) what happens if someone has two em28xx devices plugged?

It depends depends devices, currently only nanoStick T2 only looks that 
param, other just ignore. If there is two nanoStics then both have same 
LNA settings.

That's just like same behaviour as for example remote controller 
polling. Or for example DiBcom driver LNA, since it does have similar 
module param already. Will you you commit it if I rename it similarly as 
DiBcom?

> 3) the better would be to detect if LNA is needed, or to add a DVBS2API
>     call to enable/disable LNA.

True, but it needs some research. There is many hardware which gets 
signal input from demod or tuner and makes some fine tune according to 
that. We need to define some new callbacks for demod and tuner in order 
to do this kind of actions.
Or just add new LNA param to API use it manually.


regards,
Antti


-- 
http://palosaari.fi/
