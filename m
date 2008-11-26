Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta-out.inet.fi ([195.156.147.13] helo=jenni1.inet.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1L5QKV-0007R4-UP
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 20:45:45 +0100
Received: from kemuli.localdomain (84.250.94.112) by jenni1.inet.fi (8.5.014)
	id 48FC59C701BE7F36 for linux-dvb@linuxtv.org;
	Wed, 26 Nov 2008 21:45:38 +0200
Received: from kettu.localdomain ([192.168.1.2])
	by kemuli.localdomain with esmtp (Exim 4.69)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1L5QKQ-0005Md-Ar
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 21:45:38 +0200
Message-ID: <492DA760.2050401@iki.fi>
Date: Wed, 26 Nov 2008 21:45:36 +0200
From: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <8622.130.36.62.139.1227602799.squirrel@webmail.xs4all.nl>	<492BBFD9.50909@cadsoft.de>	<a3ef07920811250832g35f4670ft4e14c942c3eef990@mail.gmail.com>
	<3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
In-Reply-To: <3cc3561f0811251034v7ac1a77dt7a2233a62b6a8f1c@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Morgan T=F8rvolt wrote:
> In all honesty, having this as a user setting,
> it would only need to be set once, which hardly qualify as hard work.
>   =

I fully support Klaus' opinion. My motherboard bios and udev initialize =

my three DVB cards into "random" order that is depending whether the =

boot was cold or warm. Application level setting of dvbN device =

capabilities would not work for me reliably.

Best Regards,
Seppo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
