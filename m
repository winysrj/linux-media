Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1JbBt6-00027w-Ut
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 10:44:14 +0100
Date: Mon, 17 Mar 2008 10:41:47 +0100
From: insomniac <insomniac@slackware.it>
To: linux-dvb@linuxtv.org
Message-ID: <20080317104147.1ade57fe@slackware.it>
In-Reply-To: <47DDD817.9020605@iki.fi>
References: <20080316182618.2e984a46@slackware.it>
	<abf3e5070803161342y4a68b638m1ae82e8b24cc9a4b@mail.gmail.com>
	<20080317011939.36408857@slackware.it> <47DDC4B5.5050607@iki.fi>
	<20080317025002.2fee3860@slackware.it> <47DDD009.30504@iki.fi>
	<20080317025849.49b07428@slackware.it> <47DDD817.9020605@iki.fi>
Mime-Version: 1.0
Cc: Antti Palosaari <crope@iki.fi>
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

On Mon, 17 Mar 2008 04:31:51 +0200
Antti Palosaari <crope@iki.fi> wrote:

> yes, thats correct. I made simple patch, you can test if it does 
> something nasty. You can also look dib0700_devices.c file and try
> some changes. Patch can be applied towards current v4l-dvb-master.

Patched and recompiled the modules. Now plugging in the usb stick
triggers the loading of the related kernel modules.
The one error I get in dmesg is 

dvb_core: exports duplicate symbol dvb_unregister_adapter (owned by
kernel)

so I have removed all the DVB support from kernel, and left only
CONFIG_DVB_CORE=y, and now kernel is compiling. What to say.. whatever
will happen, all this showed again the power of the open source,
I'm moved :-)

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
