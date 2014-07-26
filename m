Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:56552 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaGZREq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 13:04:46 -0400
Message-ID: <53D3DE39.3060300@dest-unreach.be>
Date: Sat, 26 Jul 2014 18:58:33 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/rc/ir-nec-decode : add toggle feature
References: <53A29E5A.9030304@dest-unreach.be> <53A29E79.2000304@dest-unreach.be> <20140619090540.GC13952@hardeman.nu> <53A2D0B5.4050003@dest-unreach.be> <20140726124739.6c3e25bb.m.chehab@samsung.com>
In-Reply-To: <20140726124739.6c3e25bb.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-07-26 17:47, Mauro Carvalho Chehab wrote:
> Em Thu, 19 Jun 2014 13:59:49 +0200
> Niels Laukens <niels@dest-unreach.be> escreveu:
> 
>> On 2014-06-19 11:05, David Härdeman wrote:
>>> On Thu, Jun 19, 2014 at 10:25:29AM +0200, Niels Laukens wrote:
>>>> Made the distinction between repeated key presses, and a single long
>>>> press. The NEC-protocol does not have a toggle-bit (cfr RC5/RC6), but
>>>> has specific repeat-codes.
>>>
>>> Not all NEC remotes use repeat codes. Some just transmit the full code
>>> at fixed intervals...IIRC, Pioneer remotes is (was?) one example... 
>>
>> A way to cover this, is to make this mechanism optional, and
>> auto-activate as soon as a repeat code is seen. But that will only work
>> reliably with a single (type of) remote per system. Is this a better
>> solution?
> 
> No, auto-activating is a very bad idea, as it means that any NEC remote,
> if ever pressed in the room, will change the driver behavior. We should be
> able to support both cases: the one with specific repeat codes and the
> ones that don't support, at the same time.

I've changed the patch to still auto-activate, but "locally": a new
key-event will only be forced if the previously received code was a
repeat-code. This is means that non-compliant remotes will work as
before, and compliant remotes will work better: key's need to be pressed
at least for 1 repeat interval (nominally 100ms) for this feature to
activate.

I've tried this on my setup, and while it's better than the original, it
is, for me, still unacceptable. The previous version of this patch allowed
me to do a quick "3 times down". This version (and the original) doesn't.
So I'm not even posting this one.

Which makes me wonder: It seems as if it's impossible to differentiate
between the two types of remotes before the first repeat is sent, and by
then it's too late.  And it's not acceptable to latch the
repeat-code-capable flag in to the kernel. Would it be an option to make
this user-configurable? Either by splitting NEC into two variants, or by
using a parameter somehow? And if so: what is the preferred way?

Niels
