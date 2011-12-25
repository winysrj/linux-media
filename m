Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab1LYR6x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 12:58:53 -0500
Message-ID: <4EF7644F.5070401@redhat.com>
Date: Sun, 25 Dec 2011 15:58:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: Dennis Sperlich <dsperlich@googlemail.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com> <4EF72D61.9090001@gmail.com> <201112251511.54080.hselasky@c2i.net>
In-Reply-To: <201112251511.54080.hselasky@c2i.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25-12-2011 12:11, Hans Petter Selasky wrote:
> On Sunday 25 December 2011 15:04:17 Dennis Sperlich wrote:
>> On 25.12.2011 11:52, Mauro Carvalho Chehab wrote:
>>> On 24-12-2011 19:58, Dennis Sperlich wrote:
>>>> Hi,
>>>>
>>>> I have a Terratec Cinergy HTC Stick an tried the new support for the
>>>> DVB-C part. It works for SD material (at least for free receivable
>>>> stations, I tried afair only QAM64), but did not for HD stations
>>>> (QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD
>>>> (via KabelDeutschland). The HD material was just digital artefacts, as
>>>> far as mplayer could decode it. When I did a dumpstream and looked at
>>>> the resulting file size I got something about 1MB/s which seems a
>>>> little too low, because SD was already about 870kB/s. After looking
>>>> around I found a solution in increasing the isoc_dvb_max_packetsize
>>>> from 752 to 940 (multiple of 188). Then an HD stream was about 1.4MB/s
>>>> and looked good. I'm not sure, whether this is the correct fix, but it
>>>> works for me.
>>>>
>>>> If you need more testing pleas tell.
>>>>
>>>> Regards,
>>>> Dennis
>>>>
> 
> These numbers should not be hardcoded, but extracted from the USB endpoint 
> descriptor!

The driver retrieves the values from the USB endpoints during probe. This
is used for analog mode. However, on DVB mode, the values are hardcoded by
the ones that had/have access to Empiatech datasheets (Unfortunately,
I don't have them).

So, it is hard to know if the current limit is due to some chipset bug that
doesn't report well the maximum packet size, or if it is just due to the lack
of time for the ones that wrote the code to actually use the reported values.

Fixing the driver to use the USB descriptors is easy. The hard part is to be
sure that it won't break for the ones with older chipsets.

Regards,
Mauro.

> 
> --HPS

