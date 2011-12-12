Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42862 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1LLE2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 23:28:19 -0500
Received: by wgbds13 with SMTP id ds13so7578521wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 20:28:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE346E0.7050606@iki.fi>
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com>
	<4EE346E0.7050606@iki.fi>
Date: Mon, 12 Dec 2011 09:58:17 +0530
Message-ID: <CAHFNz9+WEJHhJoUywwzCF=Jv7TRY9xG2rKuRxP=Ff0jvq40SSA@mail.gmail.com>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 10, 2011 at 5:17 PM, Antti Palosaari <crope@iki.fi> wrote:
> Hello Manu,
> That patch looks now much acceptable than the older for my eyes, since you
> removed that .set_state() (change from .set_params() to .set_state()) I
> criticized. Thanks!
>


:-)

>
> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>>
>>  static int cxd2820r_set_frontend(struct dvb_frontend *fe,
>
> [...]
>>
>> +       switch (c->delivery_system) {
>> +       case SYS_DVBT:
>> +               ret = cxd2820r_init_t(fe);
>
>
>> +               ret = cxd2820r_set_frontend_t(fe, p);
>
>
>
> Anyhow, I don't now like idea you have put .init() calls to .set_frontend().
> Could you move .init() happen in .init() callback as it was earlier?

This was there in the earlier patch as well. Maybe you have a
new issue now ? ;-)

ok.

The argument what you make doesn't hold well, Why ?

int cxd2820r_init_t(struct dvb_frontend *fe)
{
	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
}


int cxd2820r_init_c(struct dvb_frontend *fe)
{
	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
}


Now, you might like to point that, the Base I2C address location
is different comparing DVB-T/DVBT2 to DVB-C

So, If you have the init as in earlier with a common init, then you
will likely init the wrong device at .init(), as init is called open().
So, this might result in an additional register write, which could
be avoided altogether.  One register access is not definitely
something to brag about, but is definitely a small incremental
difference. Other than that this register write doesn't do anything
more than an ADC_START. So starting the ADC at init doesn't
make sense. But does so when you want to select the right ADC.
So definitely, this change is an improvement. Also, you can
compare the time taken for the device to tune now. It is quite
a lot faster compared to without this patch. So you or any other
user should be happy. :-)


I don't think that in any way, the init should be used at init as
you say, which sounds pretty much incorrect.
