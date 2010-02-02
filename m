Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0BBUFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 15:05:49 -0500
Message-ID: <4B688594.60308@redhat.com>
Date: Tue, 02 Feb 2010 18:05:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] - tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>	 <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>	 <4B67464B.3020801@arcor.de> <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com> <4B674EF9.3020800@arcor.de> <4B675E52.5040306@redhat.com> <4B684F6A.6010902@arcor.de> <4B685660.3040105@redhat.com> <4B68632F.9090406@arcor.de>
In-Reply-To: <4B68632F.9090406@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:

>> Ok, but maybe you missed my point: at the long term, we should get rid of hack.c, and
>> be sure that all needed initializations are done by zl10353 driver or by tm6010-dvb.
>>   
> I think I all are done by zl10353 driver.
> 
> I thinbk all config param is usefull and ".tm6000" for tm6000 specific
> once. For what is ".parallel_ts" ?

zl10353 may be connected via a serial or via a parallel interface to the chip.
So, it basically depends on how the wiring between zl10353 and the bridge is done.

> 
> int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
> {
>     struct tm6000_dvb *dvb = dev->dvb;
> 
>     if(dev->caps.has_zl10353) {
>         struct zl10353_config config =
>                     {.demod_address = dev->demod_addr,
>                      .no_tuner = 1,
>                      .parallel_ts = 1,
>                      .if2 = 45700,
>                      .disable_i2c_gate_ctrl = 1,
>                      .tm6000 = 1,
>                     };
> 
>         dvb->frontend = pseudo_zl10353_attach(dev, &config,
> //        dvb->frontend = dvb_attach (zl10353_attach, &config,
>                                &dev->i2c_adap);
>     }
>     else {
>         printk(KERN_ERR "tm6000: no frontend defined for the device!\n");
>         return -1;
>     }
> 
>     return (!dvb->frontend) ? -1 : 0;
> }
> 
> 


-- 

Cheers,
Mauro
