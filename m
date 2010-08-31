Return-path: <mchehab@localhost>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51500 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab0HaNz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Aug 2010 09:55:28 -0400
Message-ID: <bbcd88f59eac5ebc87692eff16a9b6fc.squirrel@www.hardeman.nu>
In-Reply-To: <4C7BA933.2020303@infradead.org>
References: <e5clffplcfofw16tg9fp5t77.1283131265736@email.android.com>
    <4C7BA933.2020303@infradead.org>
Date: Tue, 31 Aug 2010 15:55:26 +0200 (CEST)
Subject: Re: IR code autorepeat issue?
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Andy Walls" <awalls@md.metrocast.net>,
	"Anton Blanchard" <anton@samba.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Mon, August 30, 2010 14:50, Mauro Carvalho Chehab wrote:
> Em 29-08-2010 22:26, Andy Walls escreveu:
>> How about a keycode sensitive repeat delay?
>> A short delay for vol+/-, ch+/-, etc.
>> A medium delay for digits, fast forward, rewind, pause, play, stop, etc.
>> A long delay for power, mute, etc.
>
> There are two separate things here:
>
> 1) we need to fix a bug introduced for some remotes;
> 2) We may improve the repeat code at rc subsystem.
>
> For (1), a simple trivial patch is enough/desired. Let's first fix it, and
> then think on improvements.

I agree, and I think setting REP_DELAY = 500 is a good fix for now (note
that it needs to be set after registering the input device). We can tweak
the repeat handling further once rc_core has settled down.

> About a keycode sensitive delay, it might be a good idea, but
> there are some aspects to consider:
*snip*
> IMHO, this would add too much complexity for not much gain.

Agreed, the per-keycode-delay lists would probably not be welcome
in-kernel (as it's basically putting policy in the kernel) and even if we
implemented APIs to let userspace control it, I think it's unlikely that
the vast majority would ever use it (meaning we add useless complexity).

-- 
David Härdeman

