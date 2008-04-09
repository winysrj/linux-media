Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JjblQ-0000Qj-Le
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 16:59:05 +0200
Message-ID: <47FCDB9A.5040807@gmail.com>
Date: Wed, 09 Apr 2008 19:07:06 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Janne Grunau <janne-dvb@grunau.be>
References: <200803292240.25719.janne-dvb@grunau.be>
In-Reply-To: <200803292240.25719.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
 dvb	adapter numbers, second try
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

Janne Grunau wrote:
> Hi,
> 
> I resubmit this patch since I still think it is a good idea to the this 
> driver option. There is still no udev recipe to guaranty stable dvb 
> adapter numbers. I've tried to come up with some rules but it's tricky 
> due to the multiple device nodes in a subdirectory. I won't claim that 
> it is impossible to get udev to assign driver or hardware specific 
> stable dvb adapter numbers but I think this patch is easier and more 
> clean than a udev based solution.
> 
> I'll drop this patch if a simple udev solution is found in a reasonable 
> amount of time. But if there is no I would like to see the attached 
> patch merged.

As i wrote sometime back, adding adapter numbers to adapters is bad.

In fact, when the kernel advocates udev, working around it is no
solution, but finding the problem and fixing the basic problem is more
important, rather than workarounds.

http://www.gentoo.org/doc/en/udev-guide.xml
http://reactivated.net/writing_udev_rules.html

If there is a general udev issue, it should be taken up with udev and
not working around within adapter drivers.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
