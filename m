Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail0.scram.de ([78.47.204.202] helo=mail.scram.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jochen@scram.de>) id 1LEP8r-0003pN-Dx
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 15:18:52 +0100
Message-ID: <494E5029.90305@scram.de>
Date: Sun, 21 Dec 2008 15:18:17 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de>
	<494C0CB3.6090109@iki.fi>
In-Reply-To: <494C0CB3.6090109@iki.fi>
Cc: linux-dvb@linuxtv.org, Manu Abraham <abraham.manu@gmail.com>,
	Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: [linux-dvb] MC44S803 frontend
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

Hi Antti,

> Is it possible to add this driver to the linuxtv.org repo? My, or Manu 
> or you? Looks like there is only one device using this driver currently.

IMHO it would be best to add this to your AF9015 tree. I hope with the now reduced
memory size there is no more reason to reject this driver from being included in the
kernel source.

Unfortunately, I'm on holidays for the next two weeks and I don't know if I have internet
connectivity all the time.

> Also Manu's original mxl500x driver seems to be much more sensitive than 
> current mxl5005s. I don't know what we should do with this driver, but 
> from users perspective this situation is not good. There is rather many 
> devices using this tuner.

Sorry, but I don't have this chip so I can't comment on this one.

Thanks,
Jochen

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
