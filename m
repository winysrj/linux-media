Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59520 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab2LMOrG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 09:47:06 -0500
Message-ID: <50C9EA4A.5010106@iki.fi>
Date: Thu, 13 Dec 2012 16:46:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: dvb_usbv2, pid filtering and adapter caps with af9035
References: <CAKdnbx7_u7ncrnjJYsLC1g4k5TxVQ2FkLP2ooZjXT=6jXspchw@mail.gmail.com>
In-Reply-To: <CAKdnbx7_u7ncrnjJYsLC1g4k5TxVQ2FkLP2ooZjXT=6jXspchw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2012 12:29 AM, Eddi De Pieri wrote:
> Hi Antti,
>
> I'm using a af9035 based usb devices on mips device but may affect other
> usb tuner..
>
> In dmesg I get a lot of
> usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
> usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
> usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
> usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
> usb 1-2: dvb_usbv2: pid_filter() failed=-929852640
>
> This should mean that the code go into the next  if..
>
> /* activate the pid on the device pid filter */
> if (adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER &&
>             adap->pid_filtering &&
>             adap->props->pid_filter)
>
> but into af9035.c code I can't find any caps initialization, pid_filtering
> or pid_filter.
>
> It seems like that some structure isn't initalized correctly.
>
> I can't understand if the issue is in dvb_usb_core.c that don't initialize
> caps.. and pid_filter* or in each dvb_usb driver that don't null the value
> of each structure..
>
> Please, can you check?

It was missing block braces and that error was printed. It does not have 
functionality issues, only that error logging is done.

You are likely using some 3.7 RC Kernel as that is fixed.

https://patchwork.kernel.org/patch/1712771/

for some reason, Mauro forget to sent it earlier?, fix went to 3.7-rc8 
and not earlier...

http://lwn.net/Articles/527935/

regards
Antti

-- 
http://palosaari.fi/
