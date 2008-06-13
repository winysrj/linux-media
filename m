Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp6.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1K75Vn-0001jA-JV
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 11:24:00 +0200
Message-ID: <48523C8D.2010807@avalpa.com>
Date: Fri, 13 Jun 2008 11:23:25 +0200
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Re :  LinuxDVB for STi7109
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

these Sti7109 based decoder are using a linux kernel but they do have
"proprietary" binary only kernel modules indeed and API for the DVB
stuff indeed: these so called STAPI libs.

you can find more about it, here:

  http://stlinux.com/docs/manual/

this is the site where ST is publishing lot's of things about the linux
kernel on their platform (it's SH4 CPU based like good old dreamcast
console!), in general.

you'll not find so much about the STAPI because its their "legacy" from
the previous ST20 based chip  generation and so heavily proprietary.

how don't know really how much they are happy with this heritage. maybe
they could/would ditch the STAPI down the drain as i'm told these are
not so good from a developer point of view.. just my personal opinion,
here, of course..

bye

andrea venturi



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
