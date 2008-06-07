Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n28.bullet.mail.ukl.yahoo.com ([87.248.110.145])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1K56aK-0002IM-Cr
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 00:08:33 +0200
Message-ID: <484B0607.9020205@yahoo.de>
Date: Sun, 08 Jun 2008 00:04:55 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
References: <20080607184758.GA30074@halim.local>
In-Reply-To: <20080607184758.GA30074@halim.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] budget_av,  high cpuload with kncone tvstar
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

Halim Sahin wrote:
> Hi,
> 
> I have one knc one tvstar.
> After loading budget_av the machine show this:
> uptime
>  20:44:58 up 37 min,  2 users,  load average: 0.71, 0.65, 0.67
> [...]

It is probably this known issue (fix already exists): 
<http://bugzilla.kernel.org/show_bug.cgi?id=10459>

Regards,
Robert


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
