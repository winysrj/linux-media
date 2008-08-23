Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KWukq-0006NG-J3
	for linux-dvb@linuxtv.org; Sat, 23 Aug 2008 17:10:17 +0200
Date: Sat, 23 Aug 2008 17:09:37 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: e9hack <e9hack@googlemail.com>
In-Reply-To: <48B01765.8020104@gmail.com>
Message-ID: <alpine.LRH.1.10.0808231704500.26788@pub5.ifh.de>
References: <48B00D6C.8080302@gmx.de> <48B01765.8020104@gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support of Nova S SE DVB card missing
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Hartmut and Eberhard,

thanks for pointing that out, I almost overlooked the previous mail from 
Eberhard.

Eberhard, are you able to try patches and to compile your own drivers in 
order to help finding the best solution.

One option is to put back the original code in case the 
repeated-start-workaround is not set. But this one looks not very 
protected. I mean between the two i2c_transfer-calls something else could 
happen.

Is there no other mean to tell to the i2c-adapter to do a repeated start 
within one i2c_transfer-call?

Another option would be to try to set the "repeated_start_workaround" 
option also for the Nova SE card.

What do you think?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/


On Sat, 23 Aug 2008, e9hack wrote:

> Eberhard Kaltenhaeuser schrieb:
>> Actual kernel does not support the Hauppauge WinTV Nova S SE PCI card
>> anymore:
>>
>
> I think it is a problem of this changeset http://linuxtv.org/hg/v4l-dvb/rev/358d281e6a3d
> from Patrick Boettcher. The S5H1420 isn't able to understand repeated start conditions.
> The i2c-read code was changed from:
>
> 	if ((ret = i2c_transfer (state->i2c, &msg1, 1)) != 1)
> 		return ret;
>
> 	if ((ret = i2c_transfer (state->i2c, &msg2, 1)) != 1)
> 		return ret;
>
> to:
> 	if (state->config->repeated_start_workaround) {
> 		ret = i2c_transfer(state->i2c, msg, 3);
> 		if (ret != 3)
> 			return ret;
> 	} else {
> 		ret = i2c_transfer(state->i2c, &msg[1], 2);
> 		if (ret != 2)
> 			return ret;
> 	}
>
> -Hartmut
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
