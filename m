Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44249 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1LJMr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 07:47:26 -0500
Received: by qcqz2 with SMTP id z2so2747343qcq.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 04:47:25 -0800 (PST)
Message-ID: <4EE354DA.6060006@gmail.com>
Date: Sat, 10 Dec 2011 10:47:22 -0200
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com> <4EE346E0.7050606@iki.fi>
In-Reply-To: <4EE346E0.7050606@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 09:47, Antti Palosaari wrote:
> Hello Manu,
> That patch looks now much acceptable than the older for my eyes, since you removed that .set_state() (change from .set_params() to .set_state()) I criticized. Thanks!
>
>
> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>> static int cxd2820r_set_frontend(struct dvb_frontend *fe,
> [...]
>> + switch (c->delivery_system) {
>> + case SYS_DVBT:
>> + ret = cxd2820r_init_t(fe);
>
>> + ret = cxd2820r_set_frontend_t(fe, p);
>
>
> Anyhow, I don't now like idea you have put .init() calls to .set_frontend(). Could you move .init() happen in .init() callback as it was earlier?

Changing .init() to happen at set_frontend() actually makes sense for me ;)

Why didn't you like this change?

Regards,
Mauro
