Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1Jb4WJ-0005JG-L9
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 02:52:16 +0100
Received: from localhost (39.255.187.177) by aa012msr.fastwebnet.it (8.0.013.5)
	id 47CFF2F2016F91F3 for linux-dvb@linuxtv.org;
	Mon, 17 Mar 2008 02:51:31 +0100
Date: Mon, 17 Mar 2008 02:50:02 +0100
From: insomniac <insomniac@slackware.it>
To: linux-dvb@linuxtv.org
Message-ID: <20080317025002.2fee3860@slackware.it>
In-Reply-To: <47DDC4B5.5050607@iki.fi>
References: <20080316182618.2e984a46@slackware.it>
	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
	<20080317011939.36408857@slackware.it> <47DDC4B5.5050607@iki.fi>
Mime-Version: 1.0
Subject: Re: [linux-dvb] New unsupported device
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

On Mon, 17 Mar 2008 03:09:09 +0200
Antti Palosaari <crope@iki.fi> wrote:

> > Tell me if you need more information, I'm very interested into make
> > my card work and give back to the community all the support I can.  
> 
> Look driver .inf files, they usually reveals better information.
> Anyhow, mod7700 could be DibCom 7700 chipset that is supported rather
> well.  

The .inf should be this: http://rafb.net/p/8ideWc93.html

Anyway, can you point me out what is the module for such chipset? If
it's included in the mainstream kernel, or if I need to get it
separately. I have read about bttv.ko, but I'm not sure wheter it worked
for me or not, because no device seems to be created in /dev, nor dmesg
gives helpful messages after modprobe.
Thanks again.

Best regards,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
