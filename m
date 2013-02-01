Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3BAIHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 03:07:55 -0500
Date: Fri, 1 Feb 2013 06:07:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Torfinn Ingolfsen <tingox@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: media_build: getting a TerraTec H7 working?
Message-ID: <20130201060747.615e545c@redhat.com>
In-Reply-To: <CAJ_iqtYTjVdx0rcx3RTbGPqy_eiUX_9VJAxvo--fsLvaJh=Q5g@mail.gmail.com>
References: <CAJ_iqtYTjVdx0rcx3RTbGPqy_eiUX_9VJAxvo--fsLvaJh=Q5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 31 Jan 2013 22:38:13 +0100
Torfinn Ingolfsen <tingox@gmail.com> escreveu:

> Hi,
> I'm trying to get a TerraTec H7 working. I started with Xubuntu 12.04,
> using kernel 3.2.24:
> tingo@kg-f4:~/work/w_scan-20121111$ lsb_release -a
> No LSB modules are available.
> Distributor ID:	Ubuntu
> Description:	Ubuntu 12.04.1 LTS
> Release:	12.04
> Codename:	precise
> 
> tingo@kg-f4:~/work/w_scan-20121111$ uname -a
> Linux kg-f4 3.2.24 #2 SMP Wed Sep 5 01:14:55 CEST 2012 x86_64 x86_64
> x86_64 GNU/Linux
> 
> I have this H7 variant:
> tingo@kg-f4:~/work/w_scan-20121111$ lsusb -s 2:2
> Bus 002 Device 002: ID 0ccd:10a3 TerraTec Electronic GmbH
> 
> I added the media_build tree, by following these instructions:
> http://git.linuxtv.org/media_build.git
> 
> relevant parts of dmesg output:
> [    9.008181] WARNING: You are using an experimental version of the
> media stack.
> [    9.008186]  As the driver is backported to an older kernel, it doesn't offer
> [    9.008188]  enough quality for its usage in production.
> [    9.008190]  Use it with care.
> [    9.008191] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [    9.008193]  a32f7d1ad3744914273c6907204c2ab3b5d496a0 Merge branch
> 'v4l_for_linus' into staging/for_v3.9
> [    9.008195]  6b9e50c463efc5c361496ae6a895cc966ff8025b [media]
> stv090x: On STV0903 do not set registers of the second path
> [    9.008198]  f67102c49a123b32a4469b28407feb52b37144f5 [media]
> mb86a20s: remove global BER/PER counters if per-layer counters vanish
> [    9.013452] usbcore: registered new interface driver dvb_usb_az6007
> 
> [    9.014108] usb 2-1: dvb_usb_v2: found a 'Terratec H7' in cold state
> 
> [    9.746658] usb 2-1: dvb_usb_v2: downloading firmware from file
> 'dvb-usb-terratec-h7-az6007.fw'
> [    9.770522] usb 2-1: dvb_usb_v2: found a 'Terratec H7' in warm state
> 
> [   11.008581] usb 2-1: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [   11.008625] DVB: registering new adapter (Terratec H7)
> [   11.011489] usb 2-1: dvb_usb_v2: MAC address: c2:cd:0c:a3:10:00
> [   11.025188] drxk: frontend initialized.
> [   11.036565] usb 2-1: DVB: registering adapter 0 frontend 0 (DRXK)...
> [   11.047302] mt2063_attach: Attaching MT2063
> [   11.072035] Registered IR keymap rc-nec-terratec-cinergy-xs
> [   11.072230] input: Terratec H7 as
> /devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0/input13
> [   11.072346] rc0: Terratec H7 as
> /devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc0
> [   11.072354] usb 2-1: dvb_usb_v2: schedule remote query interval to 400 msecs
> [   11.072361] usb 2-1: dvb_usb_v2: 'Terratec H7' successfully
> initialized and connected
> [   11.088076] drxk: status = 0x439130d9
> [   11.088085] drxk: detected a drx-3913k, spin A2, xtal 27.000 MHz

It looks ok so far.

> 
> I get this in /dev:
> tingo@kg-f4:~/work/w_scan-20121111$ ls -l /dev/dvb/adapter0
> total 0
> crw-rw----+ 1 root video 212, 3 Jan 31 21:06 ca0
> crw-rw----+ 1 root video 212, 0 Jan 31 21:06 demux0
> crw-rw----+ 1 root video 212, 1 Jan 31 21:06 dvr0
> crw-rw----+ 1 root video 212, 4 Jan 31 21:06 frontend0
> crw-rw----+ 1 root video 212, 2 Jan 31 21:06 net0
> 
> But when I scan with w_scan, it doesn't find any channels:
> tingo@kg-f4:~/work/w_scan-20121111$ ./w_scan -fc -c NO -C ISO-8859-1
> w_scan version 20121111 (compiled for DVB API 5.4)
...
> And yes - the H7 is connected to a cable with a DVB-C signal on it
> (using a different DVBC-adapter, w_scan finds lamost 200 channels).
> 
> What more can I do to get this H7 working?

Well, I prefer to not use w_scan for DVB-C. It will take a long time to
run, as it will try a large number of possibilities and still it might
not find the channels, if your cable operator is using some weird setup
(still, it has some options to make it more pedantic and increase the scan
time to a few hours).

I prefer, instead, to have a simple file with something like:

	# Frequency	Symbol_rate	FEC	Modulation
	C 573000000	5217000		NONE	QAM256

Where frequency and symbol rates that typically can be get easily from the STB.
You don't need to set FEC, as this device supports FEC_AUTO. Modulation can 
be QAM-16, QAM-32, QAM-64, QAM-128 or QAM-256.

w_scan by default tries only QAM-64 and QAM-256, as those are the typical
modulation types used, but it is up to your cable operator to decide. They
might be doing something weird.

In doubt, you could have more than one line with all possible alternatives,
like:

	# Frequency	Symbol_rate	FEC	Modulation
	C 573000000	5217000		NONE	QAM256
	C 573000000	5217000		NONE	QAM128
	...
	C 573000000	5217000		NONE	QAM16

Assuming that the above file is called "~/dvbc-freq", you can scan the
channels with:

	$ dvbv5-scan -I channel ~/dvbc-freq

Once it gets succeeded, the tool will get the other frequencies from the
stream and scan them.

It should be noticed that DVB-C2 is not supported by this frontend.

-- 

Cheers,
Mauro
