Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63330 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaEIPTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 11:19:50 -0400
Received: by mail-lb0-f182.google.com with SMTP id q8so5557884lbi.13
        for <linux-media@vger.kernel.org>; Fri, 09 May 2014 08:19:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 9 May 2014 11:19:49 -0400
Message-ID: <CAJHRZ=KtLYbK=80FOZEquufSBXogxxduKc_eD9sbDsGD3Y3N2w@mail.gmail.com>
Subject: Hauppauge 950Q TS capture intermittent lock up
From: Trevor Anonymous <trevor.forums@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have written a simple application to capture RF QAM transport
streams with the Hauppauge 950Q, and save to a file. This is
essentially the same as dvbstream, but with unnecessary stuff removed
(and I have verified this bug using dvbstream as well):
- tune using frontend device
- demux device: DMX_SET_PES_FILTER on pid 8192 with DMX_OUT_TS_TAP output.
- Read from dvr device, save to file.
- Interrupt app using alarm() and stop pes filter, close devices.


This works as expected. The problem is after running this a bunch of
times (sometimes 15-20+), the device seems to eventually get into a
bad state, and nothing is available to read on the dvr device. The
lockup never seems to happen while reading data (i.e., either data
comes and the app works completely, or the app reads 0 bytes). When
this happens, all the tuning/demod locks look good, and everything
appears to be working -- there just isn't data ready to read from the
dvr device.

When it gets into a bad state, I have to physically remove/reinsert
the 950Q device or otherwise reset the device (e.g., usb reset -
USBDEVFS_RESET ioctl).

Has anyone seen this issue before?

I am running Fedora 19 with 3.13.9 kernel. Hardware is:
- au0828, au8522, xc5000 (with dvb-fe-xc5000c-4.1.30.7.fw)


Thanks,
-Trevor
