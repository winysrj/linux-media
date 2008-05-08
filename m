Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ppp196-18.static.internode.on.net ([59.167.196.18]
	helo=jumpgate.rods.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Rod@Rods.id.au>) id 1Ju7UD-0000Wt-7I
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 16:52:47 +0200
Received: from jumpgate.rods.id.au (localhost [127.0.0.1])
	by jumpgate.rods.id.au (Postfix) with ESMTP id 9D01D560363
	for <linux-dvb@linuxtv.org>; Fri,  9 May 2008 00:26:39 +1000 (EST)
Received: from [192.168.3.44] (shadow.rods.id.au [192.168.3.44])
	by jumpgate.rods.id.au (Postfix) with ESMTP id 73971560362
	for <linux-dvb@linuxtv.org>; Fri,  9 May 2008 00:26:39 +1000 (EST)
Message-ID: <48230D9E.3010104@Rods.id.au>
Date: Fri, 09 May 2008 00:26:38 +1000
From: Rod <Rod@Rods.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48222EA3.8030907@Rods.id.au>
	<d9def9db0805071624j62836409jb7a24a3153c1df9e@mail.gmail.com>
In-Reply-To: <d9def9db0805071624j62836409jb7a24a3153c1df9e@mail.gmail.com>
Subject: Re: [linux-dvb] [Fwd: Change wording of DIFF file please]
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

Markus Rechberger wrote:
> Hey,
>
> On 5/8/08, Rod <Rod@rods.id.au> wrote:
>   
>>     Repost as I think I fell off the list ;o(
>>
>>     
>
> this stuff was generated against my v4l-dvb-experimental repository it seems.
>
> +		}
> +		break;
> +	case TUNER_XCEIVE_XC3028:
> +		dprintk(KERN_INFO "saa7134_tuner_callback TUNER_XCEIVE_XC3028
> command %d\n", command);
> +		switch(command) {
> +		case TUNER_RESET1:
> +		case TUNER_RESET2:
> +			/* this seems to be to correct bit */
> +			saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00000000);
> +			saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> +			break;
> +
> +		case TUNER_RESET3:
> +			break;
>
> this also needs a change to work with the linuxtv repository, that way
> the patch is not compatible with the linuxtv.org repository it was
> generated against my v4l-dvb-experimental repository.
>
> You already have the xceive reset line bit. Look how other xc3028
> reset callbacks are implemented into the linuxtv.org repository and
> change this according to the other callbacks.
>
> Markus
>   
    Would I be able to get a little help with this please?

    I know I may be asking a bit much, but I'm trying to learn this 
stuff at the same time ;o)

    Does the code already work in 2.6.25? or its only in V4L repos 
building before submission into the linux tree?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
