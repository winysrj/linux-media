Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52397 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab3LUQGf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Dec 2013 11:06:35 -0500
Message-ID: <52B5BC85.4070803@iki.fi>
Date: Sat, 21 Dec 2013 18:06:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Guest <info@are.ma>, linux-media@vger.kernel.org
CC: Bud R <knightrider@are.ma>, mchehab@redhat.com,
	hdegoede@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T)
 cards
References: <1387494851-28215-1-git-send-email-guest@puma.are.ma>
In-Reply-To: <1387494851-28215-1-git-send-email-guest@puma.are.ma>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.12.2013 01:14, Guest wrote:
> From: Bud R <knightrider@are.ma>
>
> *** Is this okay? ***

No, that is huge patch bomb with a lot of things that should be 
implement differently.

First of all lets take a look of hardware in a level what chips there is 
and how those are connected.

MaxLinear MxL301RF multimode silicon RF tuner
Sharp QM1D1C0042 satellite silicon RF tuner
Toshiba TC90522 ISDB-S/T demodulator
Altera Cyclone IV FPGA, PCI-bridge

* Cyclone IV is FPGA, runs custom device vendor specific logic.
* TC90522 can stream multiple TS, ISDB-S and ISDB-T, at same time. I am 
not sure if that device could do it, but it should be taken into account 
when implementing demod driver.


>
> A DVB driver for Earthsoft PT3 (ISDB-S/T) receiver PCI Express cards, based on
> 1. PT3 chardev driver
> 	https://github.com/knight-rider/ptx/tree/master/pt3_drv
> 	https://github.com/m-tsudo/pt3
> 2. PT1/PT2 DVB driver
> 	drivers/media/pci/pt1
>
> It behaves similarly as PT1 DVB, plus some tuning enhancements:
> 1. in addition to the real frequency:
> 	ISDB-S : freq. channel ID
> 	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
> 2. in addition to TSID:
> 	ISDB-S : slot#
>
> Feature changes:
> - dropped DKMS & standalone compile
> - dropped verbosity (debug levels), use single level -DDEBUG instead
> - changed SNR (.read_snr) to CNR (.read_signal_strength)
> - moved FE to drivers/media/dvb-frontends
> - moved demodulator & tuners to drivers/media/tuners

Those are not moved.

> - translated to standard (?) I2C protocol
> - dropped unused features
>
> The full package (buildable as standalone, DKMS or tree embedded module) is available at
> https://github.com/knight-rider/ptx/tree/master/pt3_dvb
>
> Signed-off-by: Bud R <knightrider@are.ma>
>
> ---
>   drivers/media/dvb-frontends/Kconfig      |  10 +-
>   drivers/media/dvb-frontends/Makefile     |   2 +
>   drivers/media/dvb-frontends/mxl301rf.c   | 332 ++++++++++++++
>   drivers/media/dvb-frontends/mxl301rf.h   |  27 ++

drivers/media/tuners/

>   drivers/media/dvb-frontends/pt3_common.h |  95 ++++
>   drivers/media/dvb-frontends/qm1d1c0042.c | 413 ++++++++++++++++++
>   drivers/media/dvb-frontends/qm1d1c0042.h |  34 ++

drivers/media/tuners/

>   drivers/media/dvb-frontends/tc90522.c    | 724 +++++++++++++++++++++++++++++++
>   drivers/media/dvb-frontends/tc90522.h    |  48 ++
>   drivers/media/pci/Kconfig                |   2 +-
>   drivers/media/pci/Makefile               |   1 +
>   drivers/media/pci/pt3/Kconfig            |  10 +
>   drivers/media/pci/pt3/Makefile           |   6 +
>   drivers/media/pci/pt3/pt3.c              | 543 +++++++++++++++++++++++
>   drivers/media/pci/pt3/pt3.h              |  23 +
>   drivers/media/pci/pt3/pt3_dma.c          | 335 ++++++++++++++
>   drivers/media/pci/pt3/pt3_dma.h          |  48 ++
>   drivers/media/pci/pt3/pt3_i2c.c          | 183 ++++++++
>   drivers/media/pci/pt3/pt3_i2c.h          |  30 ++


> +EXPORT_SYMBOL(mxl301rf_set_freq);
> +EXPORT_SYMBOL(mxl301rf_set_sleep);

You should bind "attach" tuner directly to the DVB frontend.


> +EXPORT_SYMBOL(qm1d1c0042_set_freq);
> +EXPORT_SYMBOL(qm1d1c0042_set_sleep);
> +EXPORT_SYMBOL(qm1d1c0042_tuner_init);


> +EXPORT_SYMBOL(tc90522_attach);
> +EXPORT_SYMBOL(tc90522_init);
> +EXPORT_SYMBOL(tc90522_set_powers);


First of all that driver should be converted to Kernel DVB driver model. 
It works something like:
You have a PCI driver (pt3). Then you call from attach(TC90522) from pt3 
in order to get frontend. After that you attach tuner to frontend 
calling attach(MxL301RF) or/and attach(QM1D1C0042).

In that case it is a little bit tricky as you have a *physically* single 
demod and 2 RF tuners. But what I looked that demod has itself 2 demods 
integrated to one package which could even operate same time. So, it 
means you have to register 2 frontends, one for ISDB-S and one for 
ISDB-T and attach correct tuner per frontend.

I know some developers may prefer to registering 2 multimode frontends 
"as a newer single frontend model" and then select operating mode using 
delivery-system command. Anyhow, that makes some extra headache as you 
should switch RF tuner per selected frontend standard. IMHO better to 
forgot fuss about single frontend model in that case and switch to older 
model where is two different standard frontends registered.


regards
Antti

-- 
http://palosaari.fi/
