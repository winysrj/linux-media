Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:51451 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2HUP24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 11:28:56 -0400
From: "M. Fletcher" <mpf30@cam.ac.uk>
To: <crope@iki.fi>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
Date: Tue, 21 Aug 2012 16:29:09 +0100
Message-ID: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies for the confusion. Having done more digging I think the
dvb_usb_rtl2832u module was added by the package download from here
http://www.dfragos.me/2011/11/installation-of-the-rt2832u-driver-in-linux/.
This is confirmed by looking through the corresponding 'MakeFile'. I have
therefore removed references to dvb_usb_rtl2832u from
/lib/modules/3.2.0-29-generic/kernel/drivers/media/usb/dvb-usb.

I have also performed a clean, build & install of V4L-DVB.

The contents of the dvb-usb folder are now as follows:

dct@DCTbox:/lib/modules/3.2.0-29-generic/kernel/drivers/media/usb/dvb-usb$
ls
dvb-usb-a800.ko           dvb-usb-dib0700.ko        dvb-usb-dtv5100.ko
dvb-usb-nova-t-usb2.ko     dvb-usb-vp702x.ko
dvb-usb-af9005.ko         dvb-usb-dibusb-common.ko  dvb-usb-dw2102.ko
dvb-usb-opera.ko           dvb-usb-vp7045.ko
dvb-usb-af9005-remote.ko  dvb-usb-dibusb-mb.ko      dvb-usb-friio.ko
dvb-usb-pctv452e.ko
dvb-usb-az6027.ko         dvb-usb-dibusb-mc.ko      dvb-usb-gp8psk.ko
dvb-usb-technisat-usb2.ko
dvb-usb-cinergyT2.ko      dvb-usb-digitv.ko         dvb-usb.ko
dvb-usb-ttusb2.ko
dvb-usb-cxusb.ko          dvb-usb-dtt200u.ko        dvb-usb-m920x.ko
dvb-usb-umt-010.ko

I cannot see any reference to the dvb_usb_rtl28xxu module. Having said that
a reference to 'dvb_usb_rtl28xxu' does appear when I build V4L-DVB.

Can you please advise how I correctly add dvb_usb_rtl28xxu?

