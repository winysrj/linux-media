Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greg.d.thomas@gmail.com>) id 1JiUqq-0004Dm-R7
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 15:24:09 +0200
Received: by an-out-0708.google.com with SMTP id d18so238972and.125
	for <linux-dvb@linuxtv.org>; Sun, 06 Apr 2008 06:23:48 -0700 (PDT)
Message-ID: <e28a31000804060623u141fc8e2hd6405809ce6fe477@mail.gmail.com>
Date: Sun, 6 Apr 2008 14:23:48 +0100
From: "Greg Thomas" <Greg@TheThomasHome.co.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] WinTV-NOVA-TD & low power muxes
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

I have a WinTV-NOVA-TD stick
(http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-TD-Stick)
- running off the Sudbury transmitter (uk-sudbury at
http://linuxtv.org/hg/dvb-apps/file/2686c080e0b5/util/scan/dvb-t/).

If I follow the "Testing your DVB device" Wiki page, it works fine for
muxes 2 & 4 (the higher power ones), but can find no channels at all
on the other muxes - whilst my cheap =A320 supermarket DVB-T STB works
just fine. Is it that

(a) USB DVB-T sticks are just less sensitive than an STB,
(b) The NOVA-TD is just less sensitive than normal for a USB stick, or
(c) Something else I'm completely missing.

Sorry if this is a stupid question, but I'm kind of new at all this!

Also, I noticed that tzap always reports the snr as 0000 for those
channels it can find; that seems a little unlikely at best, to me!

Thanks,

Greg
Kernel: 2.6.24-15-generic
Firmware: /lib/firmware/2.6.24-15-generic/dvb-usb-dib0700-1.10.fw

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
