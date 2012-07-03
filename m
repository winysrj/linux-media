Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49376 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCRVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 13:21:50 -0400
Message-ID: <4FF32A2B.7010607@kolumbus.fi>
Date: Tue, 03 Jul 2012 20:21:47 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	htl10@users.sourceforge.net
Subject: Re: DVB core enhancements - comments please?
References: <4FEBA656.7060608@iki.fi> <4FEECA65.9090205@kolumbus.fi> <4FF0307E.50408@iki.fi>
In-Reply-To: <4FF0307E.50408@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Moikka Antti.


On 07/01/2012 02:11 PM, Antti Palosaari wrote:
> Moikka Marko,
>
-- snip --
>
> Hmm, I did some initial suspend / resume changes for DVB USB when I rewrote it recently. On suspend, it just kills all ongoing urbs used for streaming. And on resume it resubmit those urbs in order to resume streaming. It just works as it doesn't hang computer anymore. What I tested applications continued to show same television channels on resume.
>
> The problem for that solution is that it does not have any power management as power management is DVB-core responsibility. So it continues eating current because chips are not put sleep and due to that those DVB-core changes are required.

I think that runtime (RT) frontend power saving is a different thing.
It isn't necessarily suspend/resume thing.

I implemented runtime Frontend power saving in 2007 on that patch I referenced.
I used dvb-core's existing functionality. Maybe this concept is applicable for you too.

I added into Mantis bridge device initialization following functions:
+                       mantis->fe->ops.tuner_ops.sleep = mantis_dvb_tuner_sleep;
+                       mantis->fe->ops.tuner_ops.init = mantis_dvb_tuner_init;
tuner_ops.{sleep,init} modification had to be the last one.

I maintained in mantis->has_power the frontend's power status.
Maybe I could have read the active status from PCI context too.

The concept was something like:
- dvb-core has responsibility to call tuner_ops.sleep() and tuner_ops.init() when applicable.
- Mantis PCI Bridge driver (or specific USB driver) has responsibility
   to provide sleep and init implementations for the specific device.
- Mantis bridge device will do the whole task of frontend power management, by calling Frontend's
   tear down / initialization functions when necessary.

>
>> - What changes encrypted channels need?
>
> I think none?
>
>
> regards
> Antti
>


Regards,
Marko
