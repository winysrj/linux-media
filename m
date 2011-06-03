Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:40002 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1FCN3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 09:29:48 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QSURe-0000Gb-FI
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 15:29:46 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jun 2011 15:29:46 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 03 Jun 2011 15:29:46 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [GIT PULL FOR 2.6.40] PCTV nanoStick T2 290e (Sony CXD2820R DVB-T/T2/C)
Date: Fri, 03 Jun 2011 15:29:31 +0200
Message-ID: <8762onxcuc.fsf@nemi.mork.no>
References: <4DDD69AE.3070606@iki.fi> <4DE63E43.1090208@redhat.com>
	<4DE8D4CD.7070708@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti Palosaari <crope@iki.fi> writes:
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
> I agree it is not proper solution, but in my mind it is better to
> offer some solution than no solution at all.
>
>> 2) what happens if someone has two em28xx devices plugged?
>
> It depends depends devices, currently only nanoStick T2 only looks
> that param, other just ignore. If there is two nanoStics then both
> have same LNA settings.
>
> That's just like same behaviour as for example remote controller
> polling. Or for example DiBcom driver LNA, since it does have similar
> module param already. Will you you commit it if I rename it similarly
> as DiBcom?
>
>> 3) the better would be to detect if LNA is needed, or to add a DVBS2API
>>     call to enable/disable LNA.
>
> True, but it needs some research. There is many hardware which gets
> signal input from demod or tuner and makes some fine tune according to
> that. We need to define some new callbacks for demod and tuner in
> order to do this kind of actions.
> Or just add new LNA param to API use it manually.


Or option 
4) just enable the LNA unconditionally.  

I did some testing in my environment, and I was unable to tune anything
on either DVB-T or DVB-C without the LNA enabled.  I'm of course aware
that this depends on your signal, but have you actually seen a real life
signal where tuning fails with the LNA enabled and works without it?

I do believe that my DVB-C signal at least is pretty strong.



Bjørn

