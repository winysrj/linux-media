Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rasjidw@gmail.com>) id 1L1Ivo-00040I-W6
	for linux-dvb@linuxtv.org; Sat, 15 Nov 2008 12:03:14 +0100
Received: by rv-out-0506.google.com with SMTP id b25so1760390rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 03:03:07 -0800 (PST)
Message-ID: <bf82ea70811150303p4d6517b2qce1345dd707a315c@mail.gmail.com>
Date: Sat, 15 Nov 2008 22:03:07 +1100
From: "Rasjid Wilcox" <rasjidw@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <49199510.6040809@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>
	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>
	<49199510.6040809@iki.fi>
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

2008/11/12 Antti Palosaari <crope@iki.fi>:
> I disabled 2nd tuner by default due to bad performance I faced up with my
> hardware. Anyhow, you can enable it by module param, use modprobe
> dvb-usb-af9015 dual_mode=1 . Test it and please report.

I have enabled dual mode, and now have an extra adaptor in /dev/dvb.

However, when I try to set the new card up in the Myth backend in
Capture Card Setup, I get an error on the Frontend ID: "Could not get
card info for the card #1", and for Subtype: Unknown error.

dmesg also has an error message:

af9015: firmware copy to 2nd frontend failed, will disable it

Any suggestions?

Cheers,

Rasjid.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
