Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:61228 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZC2XFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 19:05:50 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHA00ANUITN3Z60@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Sun, 29 Mar 2009 19:05:47 -0400 (EDT)
Date: Sun, 29 Mar 2009 19:05:47 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Wintv-1250 - EEPROM decoding - V4L DVB
In-reply-to: <49CFC642.3030408@videotron.ca>
To: Michel Dansereau <Michel.Dansereau@videotron.ca>
Cc: linux-media@vger.kernel.org
Message-id: <49CFFECB.4080902@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49CFC642.3030408@videotron.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>        switch (dev->board) {
> /* removed        case CX23885_BOARD_HAUPPAUGE_HVR1250: */
>        case CX23885_BOARD_HAUPPAUGE_HVR1500:
>        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>        case CX23885_BOARD_HAUPPAUGE_HVR1400:
>                if (dev->i2c_bus[0].i2c_rc == 0)
>                        hauppauge_eeprom(dev, eeprom+0x80);
>                break;
>        case CX23885_BOARD_HAUPPAUGE_HVR1250: /*added*/
>        case CX23885_BOARD_HAUPPAUGE_HVR1800:
>        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>        case CX23885_BOARD_HAUPPAUGE_HVR1200:
>        case CX23885_BOARD_HAUPPAUGE_HVR1700:
>                if (dev->i2c_bus[0].i2c_rc == 0)
>                        hauppauge_eeprom(dev, eeprom+0xc0);
>                break;
>        }

Thanks.

Hauppauge have various revs of the 1250 and the eeprom offset can change. It 
looks like your model is different the the stock HVR-1250 I've seen.

- Steve
