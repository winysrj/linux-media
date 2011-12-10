Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:40210 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LJNSs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:18:48 -0500
Received: by qadb15 with SMTP id b15so3546559qad.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 05:18:47 -0800 (PST)
Message-ID: <4EE35C33.20203@gmail.com>
Date: Sat, 10 Dec 2011 11:18:43 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com> <4EE346E0.7050606@iki.fi> <4EE354DA.6060006@gmail.com> <4EE359F3.1090009@iki.fi>
In-Reply-To: <4EE359F3.1090009@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 11:09, Antti Palosaari wrote:
> On 12/10/2011 02:47 PM, Mauro Carvalho Chehab wrote:
>> On 10-12-2011 09:47, Antti Palosaari wrote:
>>> Hello Manu,
>>> That patch looks now much acceptable than the older for my eyes, since
>>> you removed that .set_state() (change from .set_params() to
>>> .set_state()) I criticized. Thanks!
>>>
>>>
>>> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>>>> static int cxd2820r_set_frontend(struct dvb_frontend *fe,
>>> [...]
>>>> + switch (c->delivery_system) {
>>>> + case SYS_DVBT:
>>>> + ret = cxd2820r_init_t(fe);
>>>
>>>> + ret = cxd2820r_set_frontend_t(fe, p);
>>>
>>>
>>> Anyhow, I don't now like idea you have put .init() calls to
>>> .set_frontend(). Could you move .init() happen in .init() callback as
>>> it was earlier?
>>
>> Changing .init() to happen at set_frontend() actually makes sense for me ;)
>>
>> Why didn't you like this change?
>
> Because there is already callback named .init() just for that as I guess. .init() differs from .set_frontend() as init is called only once when device is opened whilst .set_frontend() is called every time when tuning request is done.
>
> Anyhow, it is up to decision remove .init() from the frontends callbacks as we can live without.

IMO, it makes sense to not do any init before set_frontend on most devices.
An obvious exception would be if is there any device where the capabilities need
to be discovered at runtime.

Regards,
Mauro
