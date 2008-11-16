Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rasjidw@gmail.com>) id 1L1WCV-0002bH-26
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 02:13:21 +0100
Received: by ti-out-0910.google.com with SMTP id w7so1300445tib.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 17:13:14 -0800 (PST)
Message-ID: <bf82ea70811151713y2dd73364r2f1b5721a38acefb@mail.gmail.com>
Date: Sun, 16 Nov 2008 12:13:12 +1100
From: "Rasjid Wilcox" <rasjidw@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <491ECF8B.6060009@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>
	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>
	<49199510.6040809@iki.fi>
	<bf82ea70811150303p4d6517b2qce1345dd707a315c@mail.gmail.com>
	<491ECF8B.6060009@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

2008/11/16 Antti Palosaari <crope@iki.fi>:
> Did you re-plug stick?

I'm using Mythbuntu 8.04.  I created a file /etc/modprobe.d/dvb
containing 'options dvb-usb-af9015 dual_mode=1' and rebooted.

This gives the errors described before.

I have now just done the process 'manually', including re-plugging the
stick.  The 'extra' adapter is recognised by myth, but attempting to
record with it yields nothing on one channel (Myth complains that it
can't find the file for the recording) and unviewable video on the
other.

So not a lot of joy.  :-(

Cheers,

Rasjid.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
