Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1LQha6-0005FI-Ir
	for linux-dvb@linuxtv.org; Sat, 24 Jan 2009 13:25:47 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 10CAB33A869
	for <linux-dvb@linuxtv.org>; Sat, 24 Jan 2009 13:25:09 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wyQ3pDA0Dook for <linux-dvb@linuxtv.org>;
	Sat, 24 Jan 2009 13:25:08 +0100 (CET)
Received: from halim.local (p54AE62B9.dip.t-dialin.net [84.174.98.185])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id D849833A826
	for <linux-dvb@linuxtv.org>; Sat, 24 Jan 2009 13:25:08 +0100 (CET)
Date: Sat, 24 Jan 2009 13:25:12 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090124122512.GA10672@halim.local>
References: <20090118150155.GA4871@halim.local>
	<8fa153640901182324o566aceb8l73069650506d56cb@mail.gmail.com>
	<20090124112527.GA5727@halim.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090124112527.GA5727@halim.local>
Subject: [linux-dvb] More Info: Status: Re: dvb-usb: could not submit URB
	no. 0 - get	them all back
Reply-To: linux-media@vger.kernel.org
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

Hi.
I made more tests and the following is very interesting:
reloading module ehci-hcd before loading dvb-usb-vp7045 works.
I can tune to dvb-t channels and the mentioned Errormessage doesn't occour.

Maybe this helps you to find out whats going wrong there?
BR.
halim


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
