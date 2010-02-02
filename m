Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:39554 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab0BBRj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 12:39:29 -0500
Message-ID: <4B68632F.9090406@arcor.de>
Date: Tue, 02 Feb 2010 18:38:55 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] - tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de>	 <829197381002011252w93b0f17g4c4f6d35ffae45f3@mail.gmail.com>	 <4B67464B.3020801@arcor.de> <829197381002011344g1c640c4fufa057071b8527d55@mail.gmail.com> <4B674EF9.3020800@arcor.de> <4B675E52.5040306@redhat.com> <4B684F6A.6010902@arcor.de> <4B685660.3040105@redhat.com>
In-Reply-To: <4B685660.3040105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.02.2010 17:44, schrieb Mauro Carvalho Chehab:
> Stefan Ringel wrote:
>
>   
>>> So, it will basically preserve bits 8,7,6,4 and 1 of register 8,
>>> and will clear bit 4 (EM_GPIO_4 is 1 << 4 - e. g. bit 4).
>>> After that, it will sleep for 10 miliseconds, and will then do a
>>> reset on bit 3 of Register 4 (writing 0, then 1 to the bit).
>>>   
>>>       
>> reset example :
>>
>> static struct tm6010_seq terratec[] = {
>>             {TM6010_GPIO_2,    1,    60},  /* GPIO 2 going to high */
>>             {TM6010_GPIO_2,    0,    75},  /* GPIO 2 going to lo */
>>             {TM6010_GPIO_2,    1,    60},  /* GPIO 2 going to high */
>>             { -1         ,    -1,    -1},
>> }
>>
>> Is that correct?
>>     
> Yes. In the case of tm6010, it has separate registers for each GPIO, so, you
> don't need a bitmask.
>
>   
>>> the hack.c needs to be validated against the zl10353, in order to identify
>>> what are the exact needs for tm6000. Some devices require serial mode, while
>>> others require parallel mode.
>>>
>>> I bet that playing with zl10353_config, we'll find the proper init values 
>>> required by tm6000.
>>>
>>>   
>>>       
>> I have separately write in the hack.c the value from terratec hybrid
>> stick. The older value I haven't clean.
>>     
> Ok, but maybe you missed my point: at the long term, we should get rid of hack.c, and
> be sure that all needed initializations are done by zl10353 driver or by tm6010-dvb.
>   
I think I all are done by zl10353 driver.

I thinbk all config param is usefull and ".tm6000" for tm6000 specific
once. For what is ".parallel_ts" ?

int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
{
    struct tm6000_dvb *dvb = dev->dvb;

    if(dev->caps.has_zl10353) {
        struct zl10353_config config =
                    {.demod_address = dev->demod_addr,
                     .no_tuner = 1,
                     .parallel_ts = 1,
                     .if2 = 45700,
                     .disable_i2c_gate_ctrl = 1,
                     .tm6000 = 1,
                    };

        dvb->frontend = pseudo_zl10353_attach(dev, &config,
//        dvb->frontend = dvb_attach (zl10353_attach, &config,
                               &dev->i2c_adap);
    }
    else {
        printk(KERN_ERR "tm6000: no frontend defined for the device!\n");
        return -1;
    }

    return (!dvb->frontend) ? -1 : 0;
}


-- 
Stefan Ringel <stefan.ringel@arcor.de>

