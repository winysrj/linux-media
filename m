Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:59161 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0BXIO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 03:14:56 -0500
Message-ID: <4B84DFFC.9010904@freemail.hu>
Date: Wed, 24 Feb 2010 09:14:52 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca pac7302: add USB PID range based on heuristics
References: <4B655949.50102@freemail.hu>	<4B6575AC.7060100@redhat.com>	<4B84D0B5.8040005@freemail.hu> <20100224082822.2191df80@tele>
In-Reply-To: <20100224082822.2191df80@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Jean-Francois Moine wrote:
> On Wed, 24 Feb 2010 08:09:41 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> On the schematics in PixArt PAC7301/PAC7302 datasheet
>> (http://www.pixart.com.tw/upload/PAC7301_7302%20%20Spec%20V1_20091228174030.pdf)
>> pages 19, 20, 21 and 22 there is a note titled "PID IO_TRAP" which
>> describes the possible product ID range 0x2620..0x262f. In this range
>> there are some known webcams, however, there are some PIDs with
>> unknown or future devices. Because PixArt PAC7301/PAC7302 is a System
>> on a Chip (SoC) device is is probable that this driver will work
>> correctly independent of the used PID.
> 
> Hello,
> 
> I got such information from ms-win drivers. I appeared that most of the
> unknown/new webcams were never manufactured. Now, I wait for user
> requests before adding such webcams.

What about Genius iSlim 310? Based on the Windows driver this device is
a potential candidate for pac7302 driver, see
http://linuxtv.org/wiki/index.php/PixArt_PAC7301/PAC7302#Identification

I don't have access to Genius iSlim 310 so I cannot tell it for sure.

Regards,

	Márton Németh

