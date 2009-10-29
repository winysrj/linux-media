Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:51427 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZJ2CKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 22:10:35 -0400
Received: from [98.155.23.24] by cdptpa-omta01.mail.rr.com with ESMTP
          id <20091029021038800.HRTI5890@cdptpa-omta01.mail.rr.com>
          for <linux-media@vger.kernel.org>;
          Thu, 29 Oct 2009 02:10:38 +0000
Message-ID: <4AE8F99E.5010701@acm.org>
Date: Wed, 28 Oct 2009 19:10:38 -0700
From: Bob Cunningham <rcunning@acm.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR-950Q problem under MythTV
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just completed a fresh install of MythTV 0.22 RC1 on my fully-updated Fedora 11 system.  My tuner is an HVR-950Q, connected to cable.  The tuner works fine under tvtime (SD) and xine (HD).

All MythTV functions work, except LiveTV.  The problem is that mythfrontend times out waiting for the HVR-950Q to tune to the first station.  This appears to be due to the very long HVR-950Q firmware load time, since no errors are reported by the backend.

Unfortunately, mythfrontend has a hard-wired 7 second timeout for most requests sent to the backend.  It seems this timeout works fine under normal circumstances for every other tuner MythTV works with.

The following is repeated in dmesg after every attempt:

   xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
   usb 1-2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
   xc5000: firmware read 12401 bytes.
   xc5000: firmware uploading...
   xc5000: firmware upload complete...

It looks like the HVR-950Q driver reloads the firmware at every possible opportunity, independent of the hardware state, each time either the SD or HD device is opened, such as when changing from an SD channel on /dev/video0 to an HD channel on /dev/dvb/adapter0.  Is this necessary?

Is it possible to tell the driver to ease up on the firmware reloads?  I don't mind if the first attempt fails, but the second attempt should succeed (without a reload).

Alternatively, are faster firmware loads possible?

Should I open a bug on this?
