Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:59283 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1LLMnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 07:43:05 -0500
Message-ID: <4EE5F6D4.4050500@linuxtv.org>
Date: Mon, 12 Dec 2011 13:43:00 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com> <4EE346E0.7050606@iki.fi> <CAHFNz9+WEJHhJoUywwzCF=Jv7TRY9xG2rKuRxP=Ff0jvq40SSA@mail.gmail.com>
In-Reply-To: <CAHFNz9+WEJHhJoUywwzCF=Jv7TRY9xG2rKuRxP=Ff0jvq40SSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.12.2011 05:28, Manu Abraham wrote:
> On Sat, Dec 10, 2011 at 5:17 PM, Antti Palosaari <crope@iki.fi> wrote:
>> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>>>
>>>  static int cxd2820r_set_frontend(struct dvb_frontend *fe,
>>
>> [...]
>>>
>>> +       switch (c->delivery_system) {
>>> +       case SYS_DVBT:
>>> +               ret = cxd2820r_init_t(fe);
>>
>>
>>> +               ret = cxd2820r_set_frontend_t(fe, p);
>>
>>
>>
>> Anyhow, I don't now like idea you have put .init() calls to .set_frontend().
>> Could you move .init() happen in .init() callback as it was earlier?
> 
> This was there in the earlier patch as well. Maybe you have a
> new issue now ? ;-)
> 
> ok.
> 
> The argument what you make doesn't hold well, Why ?
> 
> int cxd2820r_init_t(struct dvb_frontend *fe)
> {
> 	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
> }
> 
> 
> int cxd2820r_init_c(struct dvb_frontend *fe)
> {
> 	ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
> }
> 
> 
> Now, you might like to point that, the Base I2C address location
> is different comparing DVB-T/DVBT2 to DVB-C
> 
> So, If you have the init as in earlier with a common init, then you
> will likely init the wrong device at .init(), as init is called open().
> So, this might result in an additional register write, which could
> be avoided altogether.  One register access is not definitely
> something to brag about, but is definitely a small incremental
> difference. Other than that this register write doesn't do anything
> more than an ADC_START. So starting the ADC at init doesn't
> make sense. But does so when you want to select the right ADC.
> So definitely, this change is an improvement. Also, you can
> compare the time taken for the device to tune now. It is quite
> a lot faster compared to without this patch. So you or any other
> user should be happy. :-)
> 
> 
> I don't think that in any way, the init should be used at init as
> you say, which sounds pretty much incorrect.

Maybe the function names should be modified to avoid confusion with the
init driver callback.

Regards,
Andreas
