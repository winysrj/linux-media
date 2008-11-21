Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L3Zo1-0003aK-GZ
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 18:28:34 +0100
Received: by nf-out-0910.google.com with SMTP id g13so567532nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 09:28:30 -0800 (PST)
Message-ID: <412bdbff0811210928n204dd6a3hdc7d20bcacdfe7bd@mail.gmail.com>
Date: Fri, 21 Nov 2008 12:28:30 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Hardware pid filters: are they worth it?
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

Hello,

I am doing some driver work, and the USB device I am working on has
hardware pid filter support.

Obviously if I don't implement such support, the kernel will do the
pid filtering.

Does anyone have any experience with hardware pid filters, and have
they provided any signficant/visible benefit over the kernel pid
filter (either from a performance perspective or power consumption)?
This is aside from the known benefit that some streams would fit into
a full speed USB whereas before you might have required high speed
without the hardware pid filter.

It's probably a good thing to implement in general for completeness,
but if there isn't any power or performance savings then I'm not sure
it's worth my time.

Opinions welcome,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
