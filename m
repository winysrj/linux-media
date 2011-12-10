Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33802 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1LJNJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:09:10 -0500
Message-ID: <4EE359F3.1090009@iki.fi>
Date: Sat, 10 Dec 2011 15:09:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com> <4EE346E0.7050606@iki.fi> <4EE354DA.6060006@gmail.com>
In-Reply-To: <4EE354DA.6060006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/2011 02:47 PM, Mauro Carvalho Chehab wrote:
> On 10-12-2011 09:47, Antti Palosaari wrote:
>> Hello Manu,
>> That patch looks now much acceptable than the older for my eyes, since
>> you removed that .set_state() (change from .set_params() to
>> .set_state()) I criticized. Thanks!
>>
>>
>> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>>> static int cxd2820r_set_frontend(struct dvb_frontend *fe,
>> [...]
>>> + switch (c->delivery_system) {
>>> + case SYS_DVBT:
>>> + ret = cxd2820r_init_t(fe);
>>
>>> + ret = cxd2820r_set_frontend_t(fe, p);
>>
>>
>> Anyhow, I don't now like idea you have put .init() calls to
>> .set_frontend(). Could you move .init() happen in .init() callback as
>> it was earlier?
>
> Changing .init() to happen at set_frontend() actually makes sense for me ;)
>
> Why didn't you like this change?

Because there is already callback named .init() just for that as I 
guess. .init() differs from .set_frontend() as init is called only once 
when device is opened whilst .set_frontend() is called every time when 
tuning request is done.

Anyhow, it is up to decision remove .init() from the frontends callbacks 
as we can live without.

regards
Antti

-- 
http://palosaari.fi/
