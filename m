Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60268 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab1LBBNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 20:13:30 -0500
Received: by dadv6 with SMTP id v6so901993dad.19
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2011 17:13:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAP_ERaFTaU=8cOwi+sj3QCy1F9QgTmYJihGaXrJA1XyveY8dxw@mail.gmail.com>
References: <CAP_ERaFTaU=8cOwi+sj3QCy1F9QgTmYJihGaXrJA1XyveY8dxw@mail.gmail.com>
Date: Fri, 2 Dec 2011 01:13:28 +0000
Message-ID: <CAP_ERaEeyDZNcWrkC3o5Gn8s1Rge3d6rWejzakf=gZhaDeCfbA@mail.gmail.com>
Subject: PCTV452e / S2-3600 displays I2C error
From: Neil Sutton <sutton.nm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm not entirely sure if this is the correct list, but I compiled the
latest 3.2 RC3 kernel to get native support of my S2-3600 tuner
(s2-liplianin seems to cause trouble with my other tuner).

I enabled the PCTV452e module in the kernel and the device detects ok;

[   12.075239] dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.
[   12.076620] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   12.080767] dvb-usb: MAC address: 00:d0:5c:64:54:95
[   12.759115] dvb-usb: found a 'Hauppauge Nova-T Stick' in cold
state, will try to load a firmware
[   13.298383] dvb-usb: Technotrend TT Connect S2-3600 successfully
initialized and connected.
[   13.464394] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[   14.180319] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   14.180429] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   15.356117] dvb-usb: Hauppauge Nova-T Stick successfully
initialized and connected.
[   15.356832] usbcore: registered new interface driver dvb_usb_dib0700

But when I try to make any tuning with the device I get no picture and
the following get put to syslog;

Dec  2 01:01:26 MicroServer kernel: [ 1535.331468] dvb-usb: could not
submit URB no. 0 - get them all back
Dec  2 01:01:26 MicroServer kernel: [ 1535.372388] pctv452e: I2C error
-121; AA 97  CC 00 01 -> 55 97  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.385003] pctv452e: I2C error
-121; AA AE  CC 00 01 -> 55 AE  CC 00 00.
Dec  2 01:01:26 MicroServer kernel: [ 1535.444992] pctv452e: I2C error
-121; AA C9  CC 00 01 -> 55 C9  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.665248] dvb-usb: could not
submit URB no. 0 - get them all back
Dec  2 01:01:46 MicroServer kernel: [ 1555.708805] pctv452e: I2C error
-121; AA 2E  CC 00 01 -> 55 2E  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.722046] pctv452e: I2C error
-121; AA 45  CC 00 01 -> 55 45  CC 00 00.
Dec  2 01:01:46 MicroServer kernel: [ 1555.784543] pctv452e: I2C error
-121; AA 60  CC 00 01 -> 55 60  CC 00 00.

The 'URB' errors appear each time the card moves to a new transponder,
the I2C errors appear to be when the card is attempting to lock a
channel within the current transponder.

Does anyone have any thoughts on what might be causing this ? - I've
had a search around but can't really find the problem mentioned
anywhere... the device works fine under the latest liplianin drivers.

Many Thanks
Neil
