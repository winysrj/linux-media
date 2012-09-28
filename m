Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51995 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab2I1QTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 12:19:40 -0400
Message-ID: <5065CE04.6040306@iki.fi>
Date: Fri, 28 Sep 2012 19:19:16 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: tda18271 driver power consumption
References: <500C5B9B.8000303@iki.fi> <CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com> <500F1DC5.1000608@iki.fi> <CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com> <CAOcJUbzJjBBMcLmeaOCsJRz44KVPqZ_sGctG8+ai=n1W+9P9xA@mail.gmail.com> <500F4140.1000202@iki.fi> <CAOcJUbzF8onCqoxv-xkZY3YUiUjgjokkstB5eSX8YKELYDrjag@mail.gmail.com> <CAOcJUbw4O_rHCN6PgXc7=XU5ZToTB3QqAWLPUPhW-TZZVZ9X5w@mail.gmail.com> <20120927161940.0f673e2e@redhat.com> <5064B01E.4070802@iki.fi> <CAOcJUbxhgwhMJuAF0sfbC-ddDFOawGBFekwdhQbcJ5z2-eaxYg@mail.gmail.com> <5064C741.1060306@iki.fi> <CAOcJUbxRP-7P-qrRsfP4RV4JHTi2Sc_5HuVtkWwhnBGW3K5OXw@mail.gmail.com> <20120928084337.1db94b8c@redhat.com>
In-Reply-To: <20120928084337.1db94b8c@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2012 02:43 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 27 Sep 2012 17:58:24 -0400
> Michael Krufky <mkrufky@linuxtv.org> escreveu:
>
>> On Thu, Sep 27, 2012 at 5:38 PM, Antti Palosaari <crope@iki.fi> wrote:
>>> On 09/28/2012 12:20 AM, Michael Krufky wrote:
>
>>> Mike, There is other problem too. PCTV 520e, which is Em28xx + DRX-K +
>>> TDA18271, fails to attach tuner now. Tuner is wired behind DRX-K I2C bus.
>>> TDA18271 driver does very much I/O during attach and I2C error is raised
>>> during attach now. Earlier it worked as DRX-K firmware was downloaded before
>>> tuner was attached, but now both DRX-K fw download and tuner attach happens
>>> same time leading that error.
>>
>> Why is the DRX-K firmware downloading at the same time as tuner
>> attach?  Shouldn't the demod attach be finished before the tuner
>> attach begins?
>
> Michael,
>
> What happens is that udev changes forced drivers to load firmware asynchronously,
> as, otherwise, udev won't load any firmware at all. Also, there's no warranty that
> the firmware will be loaded on 2 seconds or so (Anti's hack were to add a 2 seconds
> wait after drxk atttach, to wait for firmware load).

IMHO whole current DRX-K FW is broken by design.
1) if fw is not really needed it should not be loaded on attach() 
instead first use case at .init()
2) if fw is needed then it must be loaded and wait chip is up and 
running and after that return from attach()

When you done it asynchronously like that, there is big you hit more 
problems depending on hardware configuration etc.

I explained that earlier too. But lets take more "real world" example.

There is USB DVB-S device. USB-bridge needs first firmware in order to 
offer I2C adapter. We need USB-bridge I2C-adapter to probe demodulator 
which sits on bridge I2C-bus. After demodulator is found we need to 
download firmware fir demodulator in order to find out tuner. Tuner sits 
behind demod I2C-bus. OK, download fw and start demod => get access for 
demod I2C-bus. Then probe used tuner. Download FW for tuner in order to 
get access for tuner GPIOs which are in that case controlled by tuner 
firmware. Finally there is LNB voltage controller which is controlled by 
tuner GPIO. We ask tuner firmware to disable LNB voltage supply.

Quite worst possible scenario, but highly possible. And it cannot be 
performed until firmware are loaded for each chip one by one.

The only place this kind "asynchronous" hack is allowed is bridge driver 
- leaving the rest as those are. And my real opinion is that this kind 
of functionality does not belong to drivers at all but somewhere more 
lower levels like USB/PCI core routines.

> What I suspect is that tda18271 init is being interruped in the middle, by the
> drxk firmware load. If this is the case, the solution is clean and quick: just
> use the new i2c_lock_adapter() way to lock the I2C bus to tda18271 during the
> critical part of the code where the register init happens.
>
>

regards
Antti
-- 
http://palosaari.fi/
