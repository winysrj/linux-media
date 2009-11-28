Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42817 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZK1KcC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 05:32:02 -0500
Message-ID: <4B10FC0A.7050408@s5r6.in-berlin.de>
Date: Sat, 28 Nov 2009 11:31:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com> <m34oolrnwd.fsf@intrepid.localdomain> <4B0E71B6.4080808@redhat.com> <m3my29up3y.fsf@intrepid.localdomain> <4B0ED19B.9030409@redhat.com> <20091128003918.628d4b84@pedra> <20091128025437.GN6936@core.coreip.homeip.net> <4B10F0BC.60008@redhat.com>
In-Reply-To: <4B10F0BC.60008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
[scancode-to-keycode map size]
>> Hmm, why can't you just resize it when you get EVIOCSKEYCODE for
>> scancode that would be out of bounds for the current table (if using
>> table approach)?
[...]
> Let's suppose, for example that instead of using a 49 keys
> IR, they want to use some programable IR with 55 keys, with different
> scancodes. This means that they'll need to delete all 49 scancodes from the old IR 
> and add 55 new scancodes. As there's no explicit call to delete a scan code, the solution
> I found with the current API is to read the current scancode table and replace them with
> KEY_UNKNOWN, allowing its re-use (this is what the driver currently does) or deleting
> that scancode from the table. After deleting 49 keys, you'll need to add the 55 new keys.
> If we do dynamic table resize for each operation, we'll do 104 sequences of kmalloc/kfree
> for replacing one table.

It is not a performance sensitive task, is it?  If you can trade ABI
simplicity for performance (which shouldn't actually matter), that'd be
a better deal.

Besides, some of the necessary kernel-internal house-keeping can also be
deferred until close().

> IMO, it would be better to have an ioctl to do the keycode table resize. An optional flag
> at the ioctl (or a separate one) can be used to ask the driver to clean the current
> keymap table and allocate a new one with the specified size. 
> This will avoid playing with memory allocation for every new key and will provide a simple
> way to say to the driver to discard the current keybable, since a new one will be used.

OTOH, an additional "forget all current mappings" ioctl sounds like an
ABI simplification.
-- 
Stefan Richter
-=====-==--= =-== ===--
http://arcgraph.de/sr/
