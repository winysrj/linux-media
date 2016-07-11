Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.opdenkamp.eu ([149.210.151.186]:49728 "EHLO
	opdenkamp.opdenkamp.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751421AbcGKHlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 03:41:36 -0400
Subject: Re: [PATCH 0/5] Pulse-Eight USB CEC driver
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
From: Lars Op den Kamp <lars@opdenkamp.eu>
Message-ID: <57834C17.7030100@opdenkamp.eu>
Date: Mon, 11 Jul 2016 09:34:47 +0200
MIME-Version: 1.0
In-Reply-To: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm subscribed to this mailing list, though haven't been participating 
in discussions here (no time). I work for Pulse-Eight and did most of 
the CEC software.

There's no difference between firmware v4 and v5 for the USB model of 
the adapter. v5 just adds support for the new Intel NUC internal CEC 
adapter.

You can snoop the bus by setting the ack mask to 0 and just read what 
comes in (MSGCODE_SET_ACK_MASK 0)
This is the same as "cec-client -m" does when using libCEC: 
https://github.com/Pulse-Eight/libcec/blob/master/src/libcec/adapter/Pulse-Eight/USBCECAdapterCommands.cpp#L584

Let me know if you need more help, or send an email to 
support@pulse-eight.com (which will likely end up in my inbox anyway 
eventually).

thanks, Lars

On 10-07-16 15:11, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This adds support for the Pulse-Eight USB CEC dongle. It has been tested
> with both v4 and v5 firmware.
>
> It is still in staging because 1) the CEC framework it depends on is still in
> staging, 2) the code needs to be refactored a bit and 3) it needs more testing.
>
> That said, it's in pretty decent shape. It's pretty neat, but I do wish it
> would support a CEC bus snooping mode: that would make it an ideal CEC bus
> sniffer. But I don't see any support for it, unfortunately.
>
> If anyone knows how this can be achieved then please let me know!
>
> Please note that this needs support from inputattach (part of linuxconsoletools),
> a patch is included in the TODO file.
>
> Regards,
>
> 	Hans
>
> Hans Verkuil (5):
>    cec: add check if adapter is unregistered.
>    serio.h: add new define for the Pulse-Eight USB-CEC Adapter
>    pulse8-cec: new driver for the Pulse-Eight USB-CEC Adapter
>    MAINTAINERS: add entry for the pulse8-cec driver
>    pulse8-cec: add TODO file
>
>   MAINTAINERS                                   |   7 +
>   drivers/staging/media/Kconfig                 |   2 +
>   drivers/staging/media/Makefile                |   1 +
>   drivers/staging/media/cec/cec-adap.c          |   5 +-
>   drivers/staging/media/pulse8-cec/Kconfig      |  10 +
>   drivers/staging/media/pulse8-cec/Makefile     |   1 +
>   drivers/staging/media/pulse8-cec/TODO         |  35 ++
>   drivers/staging/media/pulse8-cec/pulse8-cec.c | 502 ++++++++++++++++++++++++++
>   include/uapi/linux/serio.h                    |   1 +
>   9 files changed, 563 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/staging/media/pulse8-cec/Kconfig
>   create mode 100644 drivers/staging/media/pulse8-cec/Makefile
>   create mode 100644 drivers/staging/media/pulse8-cec/TODO
>   create mode 100644 drivers/staging/media/pulse8-cec/pulse8-cec.c
>

