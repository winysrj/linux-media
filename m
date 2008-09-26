Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [216.80.70.60] (helo=host06.hostingexpert.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Kj3tG-0000ya-Eu
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 05:21:10 +0200
Message-ID: <48DC551F.4000700@linuxtv.org>
Date: Thu, 25 Sep 2008 23:21:03 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: scott.shell@gmail.com
References: <92758f120809251922g3d9571acn88d85cf84f35a2d@mail.gmail.com>
In-Reply-To: <92758f120809251922g3d9571acn88d85cf84f35a2d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO FusionHDTV7 Dual Express -Remote Control
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

Scott Shell wrote:
> I've been trying to figure out how to use the remote controller included
> with this DVB card. I'm not sure the support is included in the current
> v4l-dvb build but am curious if there is something I'm missing.
> 
> I have successfully managed to get the digital tuners to work but would like
> to use the remote.
> 
> I'm not overly savy when it comes to programing but if there is anything I
> can do to help solve this problem I'm happy to help.
> 
> Thanks for any assistance.

Scott,

Enable the remote by modprobe'ing ir-kbd-i2c

HTH,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
