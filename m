Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58208 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab2LLW3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 17:29:20 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so1412981vcd.19
        for <linux-media@vger.kernel.org>; Wed, 12 Dec 2012 14:29:20 -0800 (PST)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 12 Dec 2012 23:29:00 +0100
Message-ID: <CAKdnbx7_u7ncrnjJYsLC1g4k5TxVQ2FkLP2ooZjXT=6jXspchw@mail.gmail.com>
Subject: dvb_usbv2, pid filtering and adapter caps with af9035
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I'm using a af9035 based usb devices on mips device but may affect other
usb tuner..

In dmesg I get a lot of
usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
usb 1-2: dvb_usbv2: pid_filter() failed=-929852640

This should mean that the code go into the next  if..

/* activate the pid on the device pid filter */
if (adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER &&
           adap->pid_filtering &&
           adap->props->pid_filter)

but into af9035.c code I can't find any caps initialization, pid_filtering
or pid_filter.

It seems like that some structure isn't initalized correctly.

I can't understand if the issue is in dvb_usb_core.c that don't initialize
caps.. and pid_filter* or in each dvb_usb driver that don't null the value
of each structure..

Please, can you check?

Regards,

Eddi
