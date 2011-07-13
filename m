Return-path: <mchehab@localhost>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60256 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965018Ab1GMHnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 03:43:52 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107121143500.31381-100000@netrider.rowland.org>
References: <CACVXFVOL67EjcMxfizC0JR-=wraNTneZicw_OBfCGkseZh7Lig@mail.gmail.com>
	<Pine.LNX.4.44L0.1107121143500.31381-100000@netrider.rowland.org>
Date: Wed, 13 Jul 2011 15:43:51 +0800
Message-ID: <CACVXFVOGiJswRQ+5kJd7HW3Zyow9hrC6+HR=fB5o6o=iH-ca3A@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On Tue, Jul 12, 2011 at 11:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 12 Jul 2011, Ming Lei wrote:
>
>> Hi Laurent,
>>
>> After resume from sleep,  all the ISO packets from camera are like below:
>>
>> ffff880122d9f400 3527230728 S Zi:1:004:1 -115:1:2568 32 -18:0:1600
>> -18:1600:1600 -18:3200:1600 -18:4800:1600 -18:6400:1600 51200 <
>> ffff880122d9d400 3527234708 C Zi:1:004:1 0:1:2600:0 32 0:0:12
>> 0:1600:12 0:3200:12 0:4800:12 0:6400:12 51200 = 0c8c0000 0000fa7e
>> 012f1b05 00000000 00000000 00000000 00000000 00000000
>>
>> All are headed with 0c8c0000, see attached usbmon captures.
>
> Maybe this device needs a USB_QUIRK_RESET_RESUME entry in quirks.c.

I will try it, but seems unbind&bind driver don't produce extra usb reset signal
to the device.

Also, the problem didn't happen in runtime pm case, just happen in
wakeup from system suspend case. uvcvideo has enabled auto suspend
already at default.

thanks,
-- 
Ming Lei
