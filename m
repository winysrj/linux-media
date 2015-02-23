Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:42366 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbBWUgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:36:11 -0500
Message-ID: <54EB8F38.9080806@southpole.se>
Date: Mon, 23 Feb 2015 21:36:08 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Gilles Risch <gilles.risch@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com> <54E9DDFE.4010507@gmail.com> <54EA3633.3030805@southpole.se> <54EA4A3B.9060000@iki.fi> <54EB8C86.3040700@gmail.com>
In-Reply-To: <54EB8C86.3040700@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2015 09:24 PM, Gilles Risch wrote:
> On 02/22/2015 10:29 PM, Antti Palosaari wrote:
>> On 02/22/2015 10:04 PM, Benjamin Larsson wrote:
>>> On 02/22/2015 02:47 PM, Gilles Risch wrote:
[...]
> [  141.423608] WARNING: You are using an experimental version of the
> media stack.
> [  141.423609]     As the driver is backported to an older kernel, it
> doesn't offer
> [  141.423610]     enough quality for its usage in production.
> [  141.423611]     Use it with care.
> [  141.423612] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  141.423613]     135f9be9194cf7778eb73594aa55791b229cf27c [media]
> dvb_frontend: start media pipeline while thread is running
> [  141.423614]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media]
> cx231xx: enable tuner->decoder link at videobuf start
> [  141.423615]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media]
> dvb-frontend: enable tuner link when the FE thread starts
> [  141.424714] em2884 #0: Binding DVB extension
> [  142.754917] usb 2-6: firmware: agent loaded
> dvb-usb-hauppauge-hvr930c-drxk.fw into memory
> [  142.765420] drxk: status = 0x639260d9
> [  142.765430] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
> [  144.006316] drxk: DRXK driver version 0.9.4300
> [  144.023065] drxk: frontend initialized.

The demod seems to initialize well.


> [  144.042622] xc5000 11-0061: creating new instance
> [  144.042938] xc5000: I2C read failed

The tuner does not initialize. What could be wrong is that the tuner 
might need to be powered on (pulling some gpio pin) or it resides on 
another i2c address then what the HVR-930C has it. Or something else.

MvH
Benjamin Larsson
