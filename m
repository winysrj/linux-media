Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:37192 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaCYAPf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 20:15:35 -0400
Date: Tue, 25 Mar 2014 01:15:32 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: James Hogan <james@albanarts.com>
Cc: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Message-ID: <20140325001532.GB25627@hardeman.nu>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
 <2300906.aKyjnYIEg7@radagast>
 <CAKv9HNbwftG5-mz6uLKH68AuHOK-PgDB4AZa0qHEWCXKL_+q+A@mail.gmail.com>
 <1894298.cUReo31JQU@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1894298.cUReo31JQU@radagast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 17, 2014 at 10:34:25PM +0000, James Hogan wrote:
>It's ambiguous the other way too (which is probably a strong point against 
>having actual protocol bits for each NEC variant, since they only differ in 
>how the scancode is constructed). E.g. the Tivo keymap is 32-bit NEC, but has 
>extended NEC scancodes where the bytes of the command are complements (i.e. 
>the extended NEC command checksum passes). This makes it hard to filter on at 
>the scancode level (the drivers will probably get it right for the hardware 
>filters, but the software filter will likely get it wrong in those corner 
>cases since it knows nothing of NEC).
>
>There's multiple ways the NEC scancode formats could be improved 
>(incompatibly!) to reduce the problems, but none are perfect.
>
>E.g. one possibility is to scrap the NEC and extended NEC scancodes and just 
>use 32-bit NEC scancodes format throughout:

YES!

All the "knowledge" of "original" NEC (16 bit), "extended" NEC, etc that
have multiplied over both drivers and in various parts of rc-core is a
big mistake IMHO. The only sane way of handling NEC is to always treat
it as a 32 bit scancode (and only in cases where e.g. the hardware
returns or expects a 16 bit value should the scancode be converted
to/from the canonical 32 bit format). There is absolutely no advantages
in trying to parse or "understand" the NEC format unless it absolutely
cannot be avoided.

I haven't had the time to really review your patches in depth, but
whatever you do, please try to keep any knowledge of NEC 16/24/32 bit
distinction out of any functionality you add.

I had a suggested patch before which would also make the keymap handling
32-bit centric...essentially by redefining the set/get keymap ioctls a
bit (with backwards compatibility that guesses if the scancode is
16/24/32 bit based). It's been on my todo list for a long time to dust it
off...(yeah...I know)...
 
>0x[16-bit-address][16-bit-command]
>
>which encodes scancodes for extended NEC like this:
>0x[16-bit-address][~8-bit-command][8-bit-command]
>
>and normal NEC like this:
>0x[~8-bit-address][8-bit-address][~8-bit-command][8-bit-command]
>
>Thanks
>James

-- 
David Härdeman
