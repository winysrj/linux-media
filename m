Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36846 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbZBURcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 12:32:08 -0500
Message-ID: <49A03A94.9030008@iki.fi>
Date: Sat, 21 Feb 2009 19:32:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dmitri Belimov via Mercurial <d.belimov@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix I2C bridge error in zl10353
References: <E1LHmrf-0004LH-VV@www.linuxtv.org>
In-Reply-To: <E1LHmrf-0004LH-VV@www.linuxtv.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
This patch breaks devices using tuner behind zl10353 i2c-gate.
au6610:
Sigmatek DVB-110 DVB-T USB2.0

gl861:
MSI Mega Sky 55801 DVB-T USB2.0
A-LINK DTU DVB-T USB2.0

Probably some other too.

I think it is better to disable i2c-gate setting callback to NULL after 
demod attach like dtv5100 does this.

Also .no_tuner is bad name what it does currently. My opinion is that 
current .no_tuner = 1 should be set as default, because most 
configuration does not this kind of slave tuner setup where tuner is 
programmed by demod.
Change no_tuner to slave_tuner and set slave_tuner = 1 only when needed 
(not many drivers using that).

Here is small scheme to clear tuner cotrolling issues.
http://www.otit.fi/~crope/v4l-dvb/controlling_tuner.txt

regards
Antti

Patch from Dmitri Belimov wrote:
> The patch number 10151 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	v4l-dvb-maintainer@linuxtv.org
> 
> ------
> 
> From: Dmitri Belimov  <d.belimov@gmail.com>
> Fix I2C bridge error in zl10353
> 
> 
> Fix I2C bridge error in zl10353 if no tunner attached to internal I2C
> bus of zl10353 chip.
> 
> When set enable bridge from internal I2C bus to the main I2C bus
> (saa7134) the main I2C bus stopped very hardly. No any communication. In
> our next board we solder additional resistors to internal I2C bus.
> 
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> ---
> 
>  linux/drivers/media/dvb/frontends/zl10353.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff -r 166b13cf6fcd -r 24e51eac4234 linux/drivers/media/dvb/frontends/zl10353.c
> --- a/linux/drivers/media/dvb/frontends/zl10353.c	Wed Nov 12 15:04:28 2008 +0000
> +++ b/linux/drivers/media/dvb/frontends/zl10353.c	Tue Dec 23 06:50:09 2008 +0000
> @@ -598,7 +598,14 @@ static int zl10353_init(struct dvb_front
>  
>  static int zl10353_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
>  {
> +	struct zl10353_state *state = fe->demodulator_priv;
>  	u8 val = 0x0a;
> +
> +	if (state->config.no_tuner) {
> +		/* No tuner attached to the internal I2C bus */
> +		/* If set enable I2C bridge, the main I2C bus stopped hardly */
> +		return 0;
> +	}
>  
>  	if (enable)
>  		val |= 0x10;
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/24e51eac4234f118d51b386c6e3168e8d8f461ae
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits


-- 
http://palosaari.fi/
