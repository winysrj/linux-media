Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62357 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaBJAvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 19:51:40 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so2593342eei.26
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 16:51:39 -0800 (PST)
Received: from [192.168.1.100] ([188.24.65.5])
        by mx.google.com with ESMTPSA id s46sm47828026eeb.0.2014.02.09.16.51.37
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 09 Feb 2014 16:51:38 -0800 (PST)
Message-ID: <52F82291.70204@gmail.com>
Date: Mon, 10 Feb 2014 02:51:29 +0200
From: ZRADU <zradu1100@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Remote RM-KS for Avermedia PCI M733A (saa7134)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have this saa7134 card (PCI):
180 -> Avermedia PCI M733A [1461:4155,1461:4255]
My card is autodetected as subsystem [1461:4255]

It works very well (TV, RADIO, COMPOSITE), except REMOTE.
The latest developtment version of the driver gives support only to the 
RM_K6 remote control

This card come with IR remote: RM-KS

Same information for this remote I found here:
http://linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Digi_Volar_X_%28A815%29

Support for RM-KS remote for module dvb_usb_af9015 is already included:
"New remote RM-KS for Avermedia Volar-X (af9015)"
http://permalink.gmane.org/gmane.comp.video.linuxtv.scm/2637

module dvb_usb_af9015 have option to set type of remove:
"options dvb_usb_af9015 remote=5"

Can someone bring support for RM-KS remote to Avermedia PCI M733A as for 
dvb_usb_af9015 module?


Thanks
