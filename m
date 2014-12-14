Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:55885 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLNTRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 14:17:15 -0500
Message-ID: <548DE233.3040002@southpole.se>
Date: Sun, 14 Dec 2014 20:17:07 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] rtl28xxu: swap frontend order for devices with slave
 demodulators
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <1418429925-16342-2-git-send-email-benjamin@southpole.se> <548BBA41.7000109@iki.fi> <548C1E53.10408@southpole.se> <548C4096.5030401@iki.fi> <548C8AEF.1090907@southpole.se> <548D44B5.5030706@iki.fi>
In-Reply-To: <548D44B5.5030706@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2014 09:05 AM, Antti Palosaari wrote:
> [...]
> I just tested that patch, and it behaves just like I expected - does 
> not work at all (because RTL2832 TS bypass will not be enabled anymore).
>
> Here is log, first with your patch, then I fixed it a little as diff 
> shows, and after that scan works. I wonder what kind of test you did 
> for it - or do you have some other hacks committed...

I tried running w_scan. I remember that I also tried with changing this:

case TUNER_RTL2832_R828D:
         fe = dvb_attach(r820t_attach, adap->fe[0],
                 priv->demod_i2c_adapter,
                 &rtl2832u_r828d_config);
         adap->fe[0]->ops.read_signal_strength =
                 adap->fe[0]->ops.tuner_ops.get_rf_strength;

         if (adap->fe[1]) {
             fe = dvb_attach(r820t_attach, adap->fe[1],
                     priv->demod_i2c_adapter,
                     &rtl2832u_r828d_config);
             adap->fe[1]->ops.read_signal_strength =
adap->fe[1]->ops.tuner_ops.get_rf_strength;
         }

to
case TUNER_RTL2832_R828D:
         if (adap->fe[1]) {
             fe = dvb_attach(r820t_attach, adap->fe[1],
                     priv->demod_i2c_adapter,
                     &rtl2832u_r828d_config);
             adap->fe[1]->ops.read_signal_strength =
adap->fe[1]->ops.tuner_ops.get_rf_strength;
         }

         fe = dvb_attach(r820t_attach, adap->fe[0],
                 priv->demod_i2c_adapter,
                 &rtl2832u_r828d_config);
         adap->fe[0]->ops.read_signal_strength =
                 adap->fe[0]->ops.tuner_ops.get_rf_strength;


I must have had that change still active in my tree. Does that make any 
sense?

MvH
Benjamin Larsson
