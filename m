Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jb4bz-00068I-0v
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 02:58:05 +0100
Message-ID: <47DDD009.30504@iki.fi>
Date: Mon, 17 Mar 2008 03:57:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: insomniac <insomniac@slackware.it>
References: <20080316182618.2e984a46@slackware.it>	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>	<20080317011939.36408857@slackware.it>
	<47DDC4B5.5050607@iki.fi> <20080317025002.2fee3860@slackware.it>
In-Reply-To: <20080317025002.2fee3860@slackware.it>
Cc: linux-dvb@linuxtv.org
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

insomniac wrote:
> The .inf should be this: http://rafb.net/p/8ideWc93.html
> 
> Anyway, can you point me out what is the module for such chipset? If
> it's included in the mainstream kernel, or if I need to get it
> separately. I have read about bttv.ko, but I'm not sure wheter it worked
> for me or not, because no device seems to be created in /dev, nor dmesg
> gives helpful messages after modprobe.
> Thanks again.

I think it is not correct driver .inf file. inf-file you have is for 
Pinnacle PCTV 72e with product ID 0236 and lsusb you have has product ID 
0237.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
