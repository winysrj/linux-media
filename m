Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout08.t-online.de ([194.25.134.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1LOZA5-0002vC-4q
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2009 16:02:06 +0100
Date: Sun, 18 Jan 2009 16:01:55 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090118150155.GA4871@halim.local>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] dvb-usb: could not submit URB no. 0 - get them all back
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

Hello all,
I can't use my dvb-usb-vp7045 based dvb-t stick with latest v4l-dvb drivers.
I have tested latest hg and the standard dvb drivers.
My kernel is 2.6.28.
dmesg |grep -i dvb-usb shows:
dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
dvb-usb: could not submit URB no. 0 - get them all back

Can someone confirm or can tell me howto solve this???
Thanks
Halim



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
