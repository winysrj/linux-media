Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47012 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751950AbdFJNm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 09:42:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sat, 10 Jun 2017 16:42:56 +0300
From: Antti Palosaari <crope@iki.fi>
To: =?UTF-8?Q?Jaroslav_=C5=A0karvada?= <jskarvad@redhat.com>
Cc: linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
In-Reply-To: <20170609174644.8735-1-jskarvad@redhat.com>
References: <20170609174644.8735-1-jskarvad@redhat.com>
Message-ID: <ff6c7a4d494155764eb9b8aca0c90eb4@iki.fi>
Subject: Re: [PATCH] dvb-usb-af9035: load HID table
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Jaroslav Škarvada kirjoitti 2017-06-09 20:46:
> Automatically load sniffed HID table from Windows driver if
> USB_VID_ITETECH:USB_PID_ITETECH_IT9135_9006 device is present (e.g. 
> Evolveo
> Mars) or if module parameter force_hid_tab_load is set.

There is few issues I don't like this approach. Mostly that module 
parameter to select HID table. There is existing solution to select 
remote controller, it is ir-keytable and it should be used rather than 
defining device specific module parameter.

If you look that HID table you could see there is 4 bytes NEC code and 3 
bytes HID code. Remote controller seems to have 34 keys. Remote 
controller address bytes are 0x02bd, grepping existing remote controller 
keytables it could be Total Media In Hand remote controller 
(rc-total-media-in-hand.c). If not, then defining new keytable is 
needed.

I did some research about issue and found 2 better solutions.
1) Configure HID table dynamically. Remote controller keytable has some 
needed information, but those KEY_* events needed to be translated to 
HID codes somehow.
2) Kill HID and then use CMD_IR_GET to get remote controller scancodes 
by polling.

Solution 1 sounds most correct. No need to poll and decode by sw as hw 
does all the job. But it is most hardest to implement, I am not aware if 
anyone has done it yet.

regards
Antti


-- 
http://palosaari.fi/
