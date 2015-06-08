Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbbFHPWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 11:22:23 -0400
Message-ID: <5575B32D.8050809@iki.fi>
Date: Mon, 08 Jun 2015 18:22:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Unembossed Name <severe.siberian.man@mail.ru>,
	linux-media@vger.kernel.org
Subject: Re: About Si2168 Part, Revision and ROM detection.
References: <A9A450C95D0047DA969F1F370ED24FE4@unknown>
In-Reply-To: <A9A450C95D0047DA969F1F370ED24FE4@unknown>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 08:03 AM, Unembossed Name wrote:
> Information below was given by a hardware vendor, who uses these
> demodulators on their dvb-t2 products. As an explanation on our
> questions for Si2168 Linux driver development.
> I think it can give more clue with Part, Revision and ROM detection
> algorithm in Linux driver for that demodulator.
>
> Also, I would like to suggest a following naming method for files
> containing firmware patches. It's self explaining:
> dvb-demod-si2168-a30-rom3_0_2-patch-build3_0_20.fw
> dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw.tar.gz
> dvb-demod-si2168-b40-rom4_0_2-startup-without-patch-stub.fw

There is very little idea to add firmware version number to name as then 
you cannot update firmware without driver update. Also, it is not 
possible to change names as it is regression after kernel update.

> (Stub code to startup B40 without patch at all:
> 0x05,0x00,0x00,0x00,0x00,0x00,0x00,0x00)
> I think such naming scheme can help to avoid possible mess with fw patch
> versions.

Current driver selects firmware by reading chip revision (A, B) and 
PMAJOR/PMINOR, which means A20, A30 and B40 are detected.

PBUILD is 2 and ROMID is 1 for me Si2168-B40 chip, without firmware 
upgrade it boots up with fw version 4.0.2. Those numbers are just same 
than PMAJOR.PMINOR.PBUILD, but are those?

It is not clear at all what the hell is role of ROMID.

I know that there is many firmware updates available and all are not 
compatible with chip revisions. But I expect it is only waste of some 
time when upload always biggest firmware to chip.

Lets say there is old B40 having 4.0.2 on ROM. Then there is newer B40 
having 4.0.10 on ROM. Then there is firmware upgrade to 4.0.11, one for 
4.0.2 and another for 4.0.10. 4.0.2 is significant bigger and as 4.0.10 
very close to 4.0.11 it is significantly smaller. However, you could 
download that 4.0.2 => 4.0.11 upgrade to both chips and it leads same, 
but chip with 4.0.2 fw on ROM will not work if you upload 4.0.10 => 
4.0.11 upgrade. I haven't tested that theory, but currently driver does 
that as there is no any other detection than A20/A30/B40 and it seems to 
work pretty well. Downside is just that large fw update done always.

regards
Antti

-- 
http://palosaari.fi/
