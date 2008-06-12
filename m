Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sneakemail.com ([38.113.6.61] helo=sneak1.sneakemail.com)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <2hteq3r02@sneakemail.com>) id 1K6boT-0003u4-8c
	for linux-dvb@linuxtv.org; Thu, 12 Jun 2008 03:41:18 +0200
Date: 12 Jun 2008 01:41:10 -0000
To: linux-dvb@linuxtv.org
From: "Sneake" <2hteq3r02@sneakemail.com>
Message-ID: <5455-11240@sneakemail.com>
Subject: [linux-dvb] Regression in cx88_dvb relative 2.6.25?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Has anybody else seen a regression with the recent v4l-dvb code? I have a Pinnacle PCTV HD PCI card:
00:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
00:07.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
00:07.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)

It used to work flawlessly under the v4l-dvb branch, and when the code was merged into 2.6.25, then the stock kernel also worked flawlessly.

(all of this is for ATSC streams, not analog NTSC streams).

I then added 2 USB tuners (WinDVR-950 and Pinnacle PCTV-HD 800e), and so I pulled the latest v4l-dvb branch, built it, and installed it: and the PCI card stopped working. Now, trying to capture from the PCI card gives me a large number of errors in the recovered data stream.

Reverting to the stock 2.6.25 kernel modules will restore the PCI card's operation, so that would tend to eliminate user space changes, signal changes, and pretty much everything but the kernel drivers, as far as I can see.

So: has anybody else seen this?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
