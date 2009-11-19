Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42990 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbZKSPnU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 10:43:20 -0500
Date: Thu, 19 Nov 2009 16:43:18 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Aurelio Grego <80classics@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy T-Express
In-Reply-To: <4AF2C79C.800@gmail.com>
Message-ID: <alpine.LRH.2.00.0911191637580.12734@pub2.ifh.de>
References: <4AF2C79C.800@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Aurelio,

On Thu, 5 Nov 2009, Aurelio Grego wrote:

> Hi Patrick,
> I'm writing you about a problem with Terratec Cinergy T-Express DVB-T
> USB card.
> The card is recognized by kernel, after compiling v4l-dvb sources
> (v4l-dvb-fd679bbd8bb3.tar.gz).
> Despite all, kaffeine and w_scan utility are not able to receive any
> channels.
> I've downloaded the required firmware from here:
> http://www.wi-bw.tfh-wildau.de/~pboettch/home/files/dvb-usb-dib0700-1.20.fw
> What can I do? I used recent Linux distributions with kernel 2.6.31, but
> with no luck.
> Thanks for your help and support.
>
> dylan@linux-t9fm:~> dmesg | grep dvb
> dvb-usb: found a 'Terratec Cinergy T Express' in cold state, will try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> dvb-usb: found a 'Terratec Cinergy T Express' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: Terratec Cinergy T Express successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_dib0700
>
> dylan@linux-t9fm:~> lsusb
> Bus 007 Device 005: ID 0ccd:0062 TerraTec Electronic GmbH
>
> dylan@linux-t9fm:~/Desktop/w_scan-20090504> ./w_scan -ft -c IT -X >> /home/dylan
> /channels.conf
> w_scan version 20090502 (compiled for DVB API 5.0)
> using settings for ITALY
> DVB aerial
> DVB-T Europe
> frontend_type DVB-T, channellist 4
> output format czap/tzap/szap/xine
> Info: using DVB adapter auto detection.
>        /dev/dvb/adapter0/frontend0 -> DVB-T "DiBcom 7000PC": good  :-)
> Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.0
> frontend DiBcom 7000PC supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning 7MHz frequencies...
> 177500: (time: 00:00)
> 184500: (time: 00:03)
> 191500: (time: 00:06)
> 198500: (time: 00:09)
> 205500: (time: 00:12)
> 212500: (time: 00:16)
> 219500: (time: 00:19)
> 226500: (time: 00:22)
> Scanning 8MHz frequencies...
> 474000: (time: 00:25) (time: 00:27) signal ok:
>        QAM_AUTO f = 474000 kHz I999B8C999D999T999G999Y999

It seems that your reception quality is not good enough. Which means, that 
either the antenna or the hardware or the driver are not correctly 
set-up/written for your board.

Can you try the windows driver which with the same antenna position?

best regards,

--

Patrick
http://www.kernellabs.com/
