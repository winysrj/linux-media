Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from core6.multiplay.co.uk ([85.236.96.23] helo=multiplay.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <prvs=1258f76cd4=sid@the-gales.com>)
	id 1LKUyX-0004Ds-S3
	for linux-dvb@linuxtv.org; Wed, 07 Jan 2009 10:45:22 +0100
Received: from [192.168.1.10] ([85.236.104.54])
	by mail1.multiplay.co.uk (mail1.multiplay.co.uk [85.236.96.23])
	(Cipher TLSv1:RC4-MD5:128) (MDaemon PRO v9.6.6)
	with ESMTP id md50006796123.msg
	for <linux-dvb@linuxtv.org>; Wed, 07 Jan 2009 09:41:00 +0000
Message-ID: <496478A8.5000909@the-gales.com>
Date: Wed, 07 Jan 2009 09:40:56 +0000
From: Sid Gale <sid@the-gales.com>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <495FA006.8020609@the-gales.com>	
	<ea4209750901040646p492a91a2x9cd070b98e1dca9c@mail.gmail.com>	
	<4961D3E7.3070304@the-gales.com>
	<ea4209750901050327nc21a830j75992a0f1de0fd75@mail.gmail.com>
In-Reply-To: <ea4209750901050327nc21a830j75992a0f1de0fd75@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Asus My Cinema U3000 Mini
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

Albert Comerma wrote:
> Just more questions... the v4l driver was already supplied on the kernel 
> or you downloaded it and compile?
> It should not take so much time to get a channel... In other drivers 
> there was some GPIO problems, but I never got anything similar with this 
> card (at least nobody told me)...
> You can try to load the dvb-core module with a specified timeout in 
> parameter: dvb_override_tune_delay:0: normal (default), >0 => delay in 
> milliseconds to wait for lock after a tune attempt (int)
> 
> Since you're a beginner in linux you should; first connect your card,
> then as root unload the modules used by your card (order is important);
>  sudo rmmod dvb_usb_dib0700 dib7000p dib7000m dib3000mc dib0070 dvb_usb 
> dvb_core
> If you want you can get a list on the used modules and dependences 
> between them running; lsmod | grep dvb
> Then you need to reload the modules in opposite order adding the parameter;
> sudo modprobe dvb_core dvb_override_tune_delay=10000
> You should see the new parameter on 
> /sys/module/dvb_core/parameters/dvb_override_tune_delay
> And now you have to finish loadding the other modules one by one; sudo 
> modprobe dvb_usb... sudo modprobe dib0070...
> 

Hi Albert

Thanks for the response. I tried changing the tune delay as you 
described, but it made no difference. The first filter timeout message 
appeared after about 5 seconds, just like before, so it looks as though 
it isn't a tuning timeout that's the problem.

Thanks for the suggestions, though.

Regards

Sid


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
