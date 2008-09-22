Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.j.buxton@gmail.com>) id 1Khs4y-0002RP-GA
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 22:32:22 +0200
Received: by gv-out-0910.google.com with SMTP id n29so376345gve.16
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 13:32:16 -0700 (PDT)
Message-ID: <3d374d00809221332j58fedca7s17db8332524b3400@mail.gmail.com>
Date: Mon, 22 Sep 2008 21:32:15 +0100
From: "Alistair Buxton" <a.j.buxton@gmail.com>
To: Michael <m72@fenza.com>
In-Reply-To: <5926395e0809210137y7a89a887xa7ca54218d09b1e@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
	<3d374d00809190659r123651ffwec3a326367e248e7@mail.gmail.com>
	<5926395e0809200414m186da966g62b4f0f975b46633@mail.gmail.com>
	<3d374d00809201151w543e17cdm4ca67e5940667f2b@mail.gmail.com>
	<5926395e0809210137y7a89a887xa7ca54218d09b1e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB USB receiver stopped reporting correct USB ID
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

2008/9/21 Michael <m72@fenza.com>:

> So I looked that this path too and downloaded the SuiteUSB 1.0 - USB
> Development tools for Visual C++ 6.0 from
> http://www.cypress.com/design/RD1076. That had a utility called
> CyConsole. That recognised that Cypress a USB device was plugged in
> and allows data be be manually changed, but unfortunately the
> documentation is written for people who have a better understanding of
> these things than me. There wasn't any obvious way just enter new
> vendor and product IDs. I looked through the datasheet of the
> cy7c68013 (http://download.cypress.com.edgesuite.net/design_resources/datasheets/contents/cy7c68013_8.pdf),
> but didn't see anything obvious. Anyone out there able/willing to give
> me some instructions on how to use the cypress tool to do that?

The eeprom cannot be reprogramed directly by the host. You must load a
special firmware which does nothing but program the eeprom. This is
called a second stage loader. It is included in the development kit.

Have a look at this pdf:

http://ece-www.colorado.edu/~mcclurel/EZUSBtools.pdf

The EZ-USB control panel is available in this dev kit:

http://download.cypress.com.edgesuite.net/design_resources/developer_kits/contents/cy3684_ez_usb_fx2lp_development_kit_15.exe

Technical Reference (different to the datasheet):

http://download.cypress.com.edgesuite.net/design_resources/technical_reference_manuals/contents/ez_usb_r___technical_reference_manual__trm__14.pdf

-- 
Alistair Buxton
a.j.buxton@gmail.com

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
