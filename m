Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JdiC6-0002tr-2l
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 09:38:15 +0100
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <1206270834.4521.11.camel@shuttle>
References: <1206139910.12138.34.camel@youkaida>
	<1206185051.22131.5.camel@tux>  <1206190455.6285.20.camel@youkaida>
	<1206270834.4521.11.camel@shuttle>
Date: Mon, 24 Mar 2008 08:37:12 +0000
Message-Id: <1206347832.6370.25.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

Guys,

I was running with the following debug options when I got a disconnect:

options dvb-usb-dib0700 force_lna_activation=1
options dvb-usb-dib0700 debug=1
options mt2060 debug=1
options dibx000_common debug=1
options dvb_core debug=1
options dvb_core dvbdev_debug=1
options dvb_core frontend_debug=1
options dvb_usb debug=1
options dib3000mc debug=1
options usbcore autosuspend=-1


/var/log/messages is here:

http://www.youplala.net/~will/htpc/disconnects/messages-with_debug

Can that help, or would more be needed?

There was zero remote usage at the time.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
