Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59489 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2GUQgg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 12:36:36 -0400
Message-ID: <500ADA89.6090508@iki.fi>
Date: Sat, 21 Jul 2012 19:36:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FEECA65.9090205@kolumbus.fi> <4FF0307E.50408@iki.fi> <4FF32A2B.7010607@kolumbus.fi>
In-Reply-To: <4FF32A2B.7010607@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Morjens!

I am now working with that suspend/resume/power-management, as I got LNA 
issues resolved.

On 07/03/2012 08:21 PM, Marko Ristola wrote:
>
> Moikka Antti.
>
>
> On 07/01/2012 02:11 PM, Antti Palosaari wrote:
>> Moikka Marko,
>>
> -- snip --
>>
>> Hmm, I did some initial suspend / resume changes for DVB USB when I
>> rewrote it recently. On suspend, it just kills all ongoing urbs used
>> for streaming. And on resume it resubmit those urbs in order to resume
>> streaming. It just works as it doesn't hang computer anymore. What I
>> tested applications continued to show same television channels on resume.
>>
>> The problem for that solution is that it does not have any power
>> management as power management is DVB-core responsibility. So it
>> continues eating current because chips are not put sleep and due to
>> that those DVB-core changes are required.
>
> I think that runtime (RT) frontend power saving is a different thing.
> It isn't necessarily suspend/resume thing.

Yes it is different thing (DVB-core runtime power-management). But as 
there is currently implemented .init() and .sleep() callbacks both 
frontend and tuner for power management I don't see why not to use those 
for suspend and resume too.

> I implemented runtime Frontend power saving in 2007 on that patch I
> referenced.
> I used dvb-core's existing functionality. Maybe this concept is
> applicable for you too.
>
> I added into Mantis bridge device initialization following functions:
> +                       mantis->fe->ops.tuner_ops.sleep =
> mantis_dvb_tuner_sleep;
> +                       mantis->fe->ops.tuner_ops.init =
> mantis_dvb_tuner_init;
> tuner_ops.{sleep,init} modification had to be the last one.
>
> I maintained in mantis->has_power the frontend's power status.
> Maybe I could have read the active status from PCI context too.
>
> The concept was something like:
> - dvb-core has responsibility to call tuner_ops.sleep() and
> tuner_ops.init() when applicable.
> - Mantis PCI Bridge driver (or specific USB driver) has responsibility
>    to provide sleep and init implementations for the specific device.
> - Mantis bridge device will do the whole task of frontend power
> management, by calling Frontend's
>    tear down / initialization functions when necessary.

I looked it and reads your discussion too. That code seem never ended up 
for Mantis.

But the idea is just basically same: use existing sleep() calls to put 
device sleep on suspend and on resume use init() to wake-up again. You 
stored existing parameters inside driver state and retuned using those 
when set_frontend() get NULL as a parameter. Things has changed a little 
after that and now those parameters are stored already in dvb-frontend 
cache - which means a little less work for driver.

>>> - What changes encrypted channels need?
>>
>> I think none?



So after all, what I think currently, is:
* bridge sets and forwards .suspend() callback to dvb-core
* bridge sets and forwards .resume() callback to dvb-core
* on suspend, dvb-core puts device sleep
* on resume, dvb-core wake-ups device and inits tune (parameters are in 
cache already)

Clearly, put hardware sleep similarly as in case frontend is in sleep, 
but keep userland interface alive (frontend, demux, etc).


There is a quite lot of documentation to learn and overall whole Kernel 
power-managent is very complex. Fortunately driver implementation is 
very simple most cases. Also as changing DVB-core is needed it should be 
extremely care not make any regressions.

regards
Antti

-- 
http://palosaari.fi/


