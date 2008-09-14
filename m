Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KeiB2-0002CM-P6
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 05:21:33 +0200
Message-ID: <48CC8338.6050405@linuxtv.org>
Date: Sun, 14 Sep 2008 05:21:28 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>	<48CC3651.5040502@linuxtv.org>
	<412bdbff0809131528h22171a3am434cd5e2500f40db@mail.gmail.com>
In-Reply-To: <412bdbff0809131528h22171a3am434cd5e2500f40db@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Power management and dvb framework
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

Devin Heitmueller wrote:
> Thanks for the suggestions.  At this point my best bet is to just
> litter the code with some printk() messages so I can see what the
> complete workflow is for the life of a device.  That will help alot
> with figuring out where at what point which hooks get called.

The sleep callback gets called automatically some seconds after the last
user closed the frontend device.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
