Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59022 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1LLNlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 08:41:23 -0500
Message-ID: <4EE60480.9050006@iki.fi>
Date: Mon, 12 Dec 2011 15:41:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 09/10] CXD2820r: Query DVB frontend delivery capabilities
References: <CAHFNz9+=T5XGok+LvhVqeSVdWt=Ng6wgXqcHdtdw19a+whx1bw@mail.gmail.com>	<4EE346E0.7050606@iki.fi>	<CAHFNz9+WEJHhJoUywwzCF=Jv7TRY9xG2rKuRxP=Ff0jvq40SSA@mail.gmail.com>	<4EE5F6D4.4050500@linuxtv.org> <CAHFNz9+e-9D+a9DcAHSaDjQW1j8=XHcdxnW6Bjm2RPtQkFd-OQ@mail.gmail.com>
In-Reply-To: <CAHFNz9+e-9D+a9DcAHSaDjQW1j8=XHcdxnW6Bjm2RPtQkFd-OQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2011 02:55 PM, Manu Abraham wrote:
> On Mon, Dec 12, 2011 at 6:13 PM, Andreas Oberritter<obi@linuxtv.org>  wrote:
>> On 12.12.2011 05:28, Manu Abraham wrote:
>>> On Sat, Dec 10, 2011 at 5:17 PM, Antti Palosaari<crope@iki.fi>  wrote:
>>>> On 12/10/2011 06:44 AM, Manu Abraham wrote:
>>>>>
>>>>>   static int cxd2820r_set_frontend(struct dvb_frontend *fe,
>>>>
>>>> [...]
>>>>>
>>>>> +       switch (c->delivery_system) {
>>>>> +       case SYS_DVBT:
>>>>> +               ret = cxd2820r_init_t(fe);
>>>>
>>>>
>>>>> +               ret = cxd2820r_set_frontend_t(fe, p);
>>>>
>>>>
>>>>
>>>> Anyhow, I don't now like idea you have put .init() calls to .set_frontend().
>>>> Could you move .init() happen in .init() callback as it was earlier?
>>>
>>> This was there in the earlier patch as well. Maybe you have a
>>> new issue now ? ;-)

You mean I didn't mentioned it when you send first version? Sorry, I 
didn't looked it very carefully since I first meet stuff that was not 
related whole thing, I mean there was that code changing from 
.set_params() to .set_state(). And I stopped reading rest of the patch.


>>>
>>> ok.
>>>
>>> The argument what you make doesn't hold well, Why ?
>>>
>>> int cxd2820r_init_t(struct dvb_frontend *fe)
>>> {
>>>        ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
>>> }
>>>
>>>
>>> int cxd2820r_init_c(struct dvb_frontend *fe)
>>> {
>>>        ret = cxd2820r_wr_reg(priv, 0x00085, 0x07);
>>> }
>>>
>>>
>>> Now, you might like to point that, the Base I2C address location
>>> is different comparing DVB-T/DVBT2 to DVB-C
>>>
>>> So, If you have the init as in earlier with a common init, then you
>>> will likely init the wrong device at .init(), as init is called open().
>>> So, this might result in an additional register write, which could
>>> be avoided altogether.  One register access is not definitely
>>> something to brag about, but is definitely a small incremental
>>> difference. Other than that this register write doesn't do anything
>>> more than an ADC_START. So starting the ADC at init doesn't
>>> make sense. But does so when you want to select the right ADC.
>>> So definitely, this change is an improvement. Also, you can
>>> compare the time taken for the device to tune now. It is quite
>>> a lot faster compared to without this patch. So you or any other
>>> user should be happy. :-)
>>>
>>>
>>> I don't think that in any way, the init should be used at init as
>>> you say, which sounds pretty much incorrect.
>>
>> Maybe the function names should be modified to avoid confusion with the
>> init driver callback.
>
>
> On another tangential thought, Is it really worth to wrap that single
> register write with another function name ?
>
> instead of the current usage; ie,
>
> ret = cxd2820r_wr_reg(priv, 0x00085, 0x07); /* Start ADC */
>
> within set_frontend()
>
> in set_frontend(), another thing that's wrapped up similarly is
> the set_frontend() within the search() callback, which causes
> another set of confusions within the driver.

Actually there was was a lot more code first but because I ran problems 
selsys needed for T/T2 init was not known at the time .init() was called 
I moved those set_frontend. I left that in a hope I can later fix 
properly adding more stuff back to init.

That is not functionality issue, it is issue about naming callbacks and 
what is functionality of each callback.
As for these days it have been in my understanding initialization stuff 
are done in .init() and leave as less as possible code to 
.set_frontend(). Leaving set_frontend() handle only tuning requests and 
reconfigure IF control etc. And if you look most demod drivers there is 
rather similar logic used.

So I would like to ask what is meaning of:
.attach()
* create FE
* no HW init
* as less as possible HW I/O, mainly reading chip ID and nothing more

.init()
* do nothing here?
* download firmware?

.set_frontend()
* program tuner
* init demod?
* tune demod
* download firmware?

.sleep()
* put device sleep mode
* powersave


After all it is just fine for me apply that patch, but I would like to 
get clear idea what is meaning of every single callback we have. And if 
we really end up .init() is not needed and all should be put to 
.set_frontend() when possible it means I have to change all my demod 
drivers and maybe tuner drivers too.

regards
Antti


-- 
http://palosaari.fi/
