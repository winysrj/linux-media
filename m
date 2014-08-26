Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57489 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaHZTlI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 15:41:08 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so14883944wgh.8
        for <linux-media@vger.kernel.org>; Tue, 26 Aug 2014 12:41:06 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 16:41:06 -0300
Message-ID: <CAOdi6ibuE_WM8_Hw6ZHHBcTkAhVV_adzL1CqcZuAdrSv+So6_g@mail.gmail.com>
Subject: Instability when using One Touch Video Capture conexant dongle with
 several xHCI hubs. There is one eHCI hub where it is stable
From: Rodrigo Severo <rodrigo@fabricadeideias.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


I have been trying to set several USB Video Grabbers on a few
machines. The Video Grabbers are "Oner Touch Video Capture" dongles
from Diammond Multimedia, a Connexant device with device ID 1f4d:0102.

On an old machine with "Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller" I have three Video Grabbers,
one on each USB hub, working flawlessly.

My problem is that I can't find a new machine where these devices are
also stable. I'm compiling a list of USB hubs where they aren't
stable. In all of them, I get tons of TX lenght quirk messages like
"xhci_hcd 0000:01:00.0: WARN Successful completion on short TX: needs
XHCI_TRUST_TX_LENGTH quirk?". Activating the TX quirk workaround for
these SUB hubs prevents the messages from being logged but
unfortunatelly the video grabbers keep being randomly disconnected
when recording.

I have already seem this same behaviour with the following xHCI hubs:

* Renesas uPD720201 - ID 0x1912:0x0014
* Renesas uPD720202 - ID 0x1912:0x0015
* AsMedia ASM1042A - ID 0x1b21:0x1142

Can someone help me further diagnose thi issue? I'm kind of lost right now.


Regards,

Rodrigo Severo
