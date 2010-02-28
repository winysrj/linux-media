Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:52379 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031496Ab0B1IkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 03:40:23 -0500
Message-ID: <4B8A2BF2.40003@freemail.hu>
Date: Sun, 28 Feb 2010 09:40:18 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Linux Input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Platform Driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] Input: scancode in get/set_keycodes should be unsigned
References: <20100228061310.GA765@core.coreip.homeip.net> <4B8A10D0.2020802@freemail.hu> <20100228070536.GC765@core.coreip.homeip.net>
In-Reply-To: <20100228070536.GC765@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Sun, Feb 28, 2010 at 07:44:32AM +0100, Németh Márton wrote:
>> Hi,
>> Dmitry Torokhov wrote:
>>> The HID layer has some scan codes of the form 0xffbc0000 for logitech
>>> devices which do not work if scancode is typed as signed int, so we need
>>> to switch to unsigned int instead. While at it keycode being signed does
>>> not make much sense either.
>> Are the scan codes and key codes always 4 bytes long? Then the u32 data
>> type could be used to take 16 bit (or 64 bit) processors also into
>> consideration.
>>
> 
> We do not support 16 bit processors and for 64 bit 'unsigned int' is
> still 32 bits.
> 

OK, then:

Acked-by: Márton Németh <nm127@freemail.hu>
