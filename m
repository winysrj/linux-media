Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59794 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaASQu4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 11:50:56 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi8so2395114wib.2
        for <linux-media@vger.kernel.org>; Sun, 19 Jan 2014 08:50:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140119113926.60e0f586@samsung.com>
References: <20140119022328.55f6a741@samsung.com>
	<20140119113926.60e0f586@samsung.com>
Date: Sun, 19 Jan 2014 11:50:55 -0500
Message-ID: <CAGoCfiwp0WPMceeyQUHU-GJkSkiQzpF-YoJ+ueiFNqNOEQNK4A@mail.gmail.com>
Subject: Re: [ANNOUNCE EXPERIMENTAL] PCTV 80e driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 19, 2014 at 8:39 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> It seems that subsequent tuning makes the device worse, reducing the
> maximum effective packet bandwidth. Btw, this happens with both xHCI
> and EHCI drivers, so, it is not related to any USB 3.0 issue.

I'm pretty sure I saw this and had a patch.  I don't recall the exact
circumstances under which it happened, but I believe it had to do with
stopping and then restarting the streaming on the em28xx too quickly.
The state machine inside the em28xx gets confused and you end up
getting a misaligned stream (which is why you see hundreds of
different PIDs in output from tools such as dvbtraffic).

> Enabling some demux logs, it is possible to see that there are too many
> FEC errors:
>
> [73514.186880] dvb_dmx_swfilter_packet: 4546 callbacks suppressed
> [73514.186933] TEI detected. PID=0x17f data1=0xc1
> [73514.186965] TEI detected. PID=0x1c68 data1=0xbc
> [73514.186993] TEI detected. PID=0x17f data1=0xc1
> [73514.187022] TEI detected. PID=0x1c68 data1=0xbc
> [73514.187049] TEI detected. PID=0x17f data1=0xc1
> [73514.187080] TEI detected. PID=0x1c68 data1=0xbc
> [73514.187105] TEI detected. PID=0x17f data1=0xc1
> [73514.194878] TEI detected. PID=0x1c68 data1=0xbc
> [73514.194906] TEI detected. PID=0x17f data1=0xc1
> [73514.194927] TEI detected. PID=0x1c68 data1=0xbc
> [73521.569205] TS speed 402 Kbits/sec

Are these actually valid PIDs you're expecting data on?  If not, then
it could just be the issue I described above.  Does the TEI check
occur after it has found the SYNC byte?

> I'm starting to suspect that this could be a hardware issue.
>
> It would be good to see if others can use it and tune to several
> channels.
>
>> Ah, I didn't work at the remote controller yet. I'll handle it after
>> doing more tests with the DVB functionality.
>
> Remote controller support was added.

Should be trivial - I added the support for the em2874's RC using that
device - the RC support went upstream years ago but not the actual
board profile.

Probably worth mentioning that while I got signal lock on ATSC, I
didn't any significant analysis into the quality of the SNR. It's
possible that additional optimization of the frontend is required in
order to achieve optimal performance.  Also, I didn't do the ClearQAM
support yet, although that should be a fairly straightforward exercise
(should just be another block in the set_frontend() call which sets
the modulation appropriately).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
