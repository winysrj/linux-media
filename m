Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ammma.de ([213.83.39.131] helo=ammma.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan@horde.org>) id 1LTncG-0000bf-Tg
	for linux-dvb@linuxtv.org; Mon, 02 Feb 2009 02:28:49 +0100
Received: from ammma.net (hydra.ammma.mil [192.168.110.1])
	by ammma.de (8.11.6/8.11.6/AMMMa AG) with ESMTP id n121UEI11265
	for <linux-dvb@linuxtv.org>; Mon, 2 Feb 2009 02:30:14 +0100
Received: from neo.wg.de (hydra.ammma.mil [192.168.110.1])
	by ammma.net (8.12.11.20060308/8.12.11/AMMMa AG) with ESMTP id
	n121Shtv005348
	for <linux-dvb@linuxtv.org>; Mon, 2 Feb 2009 02:28:43 +0100
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id 921E540195B
	for <linux-dvb@linuxtv.org>; Mon,  2 Feb 2009 02:28:43 +0100 (CET)
Received: from neo.wg.de ([127.0.0.1])
	by localhost (neo.wg.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tbKq42-RqfyU for <linux-dvb@linuxtv.org>;
	Mon,  2 Feb 2009 02:28:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by neo.wg.de (Postfix) with ESMTP id BBCCA4188E2
	for <linux-dvb@linuxtv.org>; Mon,  2 Feb 2009 02:28:37 +0100 (CET)
Message-ID: <20090202022837.610753x91rgmndwk@neo.wg.de>
Date: Mon, 02 Feb 2009 02:28:37 +0100
From: Jan Schneider <jan@horde.org>
To: linux-dvb@linuxtv.org
References: <20090131124351.169513hbsz3js5fk@neo.wg.de>
	<002d01c984b1$ab3820f0$217da8c0@tdrpc>
	<20090201235434.2795793if603bysc@neo.wg.de>
In-Reply-To: <20090201235434.2795793if603bysc@neo.wg.de>
MIME-Version: 1.0
Content-Disposition: inline
Subject: Re: [linux-dvb] Technotrend C-2300 and CAM
Reply-To: linux-media@vger.kernel.org
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

Zitat von Jan Schneider <jan@horde.org>:

> Zitat von Tomas Drajsajtl <linux-dvb@drajsajtl.cz>:
>
>>> Hi,
>>>
>>> for some reason, my CAM (Alphacrypt Classic) doesn't seem to be
>>> detected by my Technotrend C-2300/CI combination. There is nothing in
>>> the kernel log/syslog when inserting or removing the card. I updated
>>> the card to the latest firmware (3.18) to no avail.
>>> I don't even know where to start debugging. No windows here, so I
>>> can't really tell whether this is a hardware problem.
>>> Any hints on where to start looking would help. The combination seems
>>> to work fine for almost everybody, beside one single thread on this
>>> list in 2007 that didn't come to a conclusion either.
>>>
>>> Jan.
>>
>> Hi Jan, I have the same problem with my C-2300 card and TechniCrypt CX
>> (CAM). After several days of testing different kernels and drivers I tried
>> it somewhere in Windows and found that it's not working there as well. Maybe
>> some HW incompatibility... The CAM I have is the only one provided and
>> supported by my cable operator so I had to get another card. C-1501 is
>> functional for me and even cheaper.
>
> Thanks for the feedback. The Alphacrypt CAM seems to be known as
> working fine with that card, and I would hate to have to install
> Windows just to rule out a hardware issue. But I guess I'd give it a
> try if no-one else has some idea.

Maybe this means something to anybody actually knowing the code. After  
I enabled debug messages through kernel parameters, I now get tons of:
dvb-ttpci: dvb_ca_ioctl(): av7110:f7e14000
from the CA/CI layer.

Jan.

-- 
Do you need professional PHP or Horde consulting?
http://horde.org/consulting/


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
