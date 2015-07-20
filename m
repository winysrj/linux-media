Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51870 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbbGTQfa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 12:35:30 -0400
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
To: Steven Toth <stoth@kernellabs.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
 <55AD0617.7060007@iki.fi>
 <CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
Cc: tonyc@wincomm.com.tw, Linux-Media <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55AD234E.5010904@iki.fi>
Date: Mon, 20 Jul 2015 19:35:26 +0300
MIME-Version: 1.0
In-Reply-To: <CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/20/2015 06:00 PM, Steven Toth wrote:
> On Mon, Jul 20, 2015 at 10:30 AM, Antti Palosaari <crope@iki.fi> wrote:
>> On 07/19/2015 01:21 AM, Steven Toth wrote:
>>>
>>> http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275
>>>
>>> Patches above are available for test.
>>>
>>> Antti, note the change to SI2168 to add support for enabling and
>>> disabling the SI2168 transport bus dynamically.
>>>
>>> I've tested with a combo card, switching back and forward between QAM
>>> and DVB-T, this works fine, just remember to select a different
>>> frontend as we have two frontends on the same adapter,
>>> adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.
>>>
>>> If any testers have the ATSC or DVB-T, I'd expect these to work
>>> equally well, replease report feedback here.
>>
>>
>> That does not work. I added debug to see what it does and result is that
>> whole si2168_set_ts_mode() function is called only once - when frontend is
>> opened first time. I used dvbv5-scan.
>
> That works very reliably for me, in the 4.2 rc kernel, when using
> azap, tzap and dvbtraffic. They're v3 api's of course, but dvb-core
> should take care of the differences. Specifically, dvb_frontend.c
> dvb_frontend_open() and dvb_frontend_release().
>
> With additional debug added, I clearly saw the syncronization and
> acquiring and releasing (via ts_bus_control) of the bus, with each
> demodulator.
>
>>
>> I am not sure why you even want to that. Is it because of 2 demods are
>> connected to same TS bus? So you want disable always another? Or is is just
>> power-management, as leaving TS active leaks potentially some current.
>
> Two demods are on the same bus, so we need to disable the non-active
> demod, to ensure the active demodulator can correctly drive the
> transport interface.
>
>>
>> Anyway, if you want control TS as runtime why you just don't add TS disable
>> to si2168_sleep()? If you enable TS on si2168_init() then correct place to
>> disable it is si2168_sleep().
>
> That's what dvb-core does, today in:
>
> dvb_frontend_open()
> ....
> if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl) {
> if ((ret = fe->ops.ts_bus_ctrl(fe, 1)) < 0)
> goto err0;
>
> and in dvb_frontend_release()...
>
> if (fe->ops.ts_bus_ctrl)
> fe->ops.ts_bus_ctrl(fe, 0);
>
> The first user of the device ensures ts_bus_control is called when its
> enabled, bring the demodulator on to the bus.
> The last user of the device ensures ts_bus_control is called when the
> device is no longer required.
>
> Why build tristating mode control into the demod specific driver when
> its been supported in the core for a long time?
>
> It won't prevent multiple callers from opening two different frontends
> (0/1) at the same time, but lack of shared resource management has
> been the case on dvb-core (and v4l2) for quite a while.
>
> If you have use case that isn't working, I'm happy to discuss.

Look at the em28xx driver and you will probably see why it does not work 
as expected. For my eyes, according to em28xx driver, it looks like that 
bus control is aimed for bridge driver. You or em28xx is wrong.

regards
Antti

-- 
http://palosaari.fi/
