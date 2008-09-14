Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Keu4T-00028U-Gr
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 18:03:34 +0200
Message-ID: <48CD35D0.5010907@linuxtv.org>
Date: Sun, 14 Sep 2008 18:03:28 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <412bdbff0809131441k5f38931cr7d64dc3871c37987@mail.gmail.com>	
	<48CC3651.5040502@linuxtv.org>	
	<412bdbff0809131528h22171a3am434cd5e2500f40db@mail.gmail.com>	
	<48CC8338.6050405@linuxtv.org>
	<412bdbff0809140550w7c6bdeaag567039de5af590db@mail.gmail.com>
In-Reply-To: <412bdbff0809140550w7c6bdeaag567039de5af590db@mail.gmail.com>
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
> On Sat, Sep 13, 2008 at 11:21 PM, Andreas Oberritter <obi@linuxtv.org> wrote:
>> The sleep callback gets called automatically some seconds after the last
>> user closed the frontend device.
> 
> Great.  That sounds like the ideal place to bring everything down.  Is
> that scheduled via a timer?

No. I just saw that the timeout defaults to 0 seconds now. For each
frontend a kernel thread gets started when open() is called. After the
call to close(), the thread will be stopped after 'dvb_shutdown_timeout'
seconds. It compares the jiffies value to accomplish that. See
dvb_frontend_is_exiting() in dvb_frontend.c.

> And does it still get called if the
> frontend gets reopened before the timer expires?

No, and the old kernel thread will be reused.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
