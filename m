Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:35209 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166455AbdD2IpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Apr 2017 04:45:01 -0400
Date: Sat, 29 Apr 2017 10:44:58 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170429084458.rwoty4bdce6iqftr@hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
 <20170428083133.2e6621bd@vento.lan>
 <20170428165911.axrlw6aic3cqabas@hardeman.nu>
 <20170428194212.GA7376@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428194212.GA7376@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 08:42:13PM +0100, Sean Young wrote:
>On Fri, Apr 28, 2017 at 06:59:11PM +0200, David Härdeman wrote:
>> On Fri, Apr 28, 2017 at 08:31:33AM -0300, Mauro Carvalho Chehab wrote:
>> >Em Thu, 27 Apr 2017 22:34:23 +0200
>> >David Härdeman <david@hardeman.nu> escreveu:
>> ...
>> >> This patch changes how the "input_keymap_entry" struct is interpreted
>> >> by rc-core by casting it to "rc_keymap_entry":
>> >> 
>> ...
>> >
>> >Nack.
>> 
>> That's not a very constructive approach. If you have a better approach
>> in mind I'm all ears. Because you're surely not suggesting that we stay
>> with the current protocol-less approach forever?
>
>Well, what problem are we trying to solve actually?

I'm not sure what the confusion is? Last time around we discussed this
there seemed to be general agreement that protocol information is
useful?

>Looking at the keymaps we have already, there are many scancodes which
>overlap and only a few of them use a different protocol. So having this
>feature will not suddenly make it possible to load all our keymaps, it
>will just make it possible to simultaneously load a few more.

That's not really the point, overlaps in scancode && protocol cannot be
distinguished. But overlaps in scancode can be. I have remotes which
overlap in scancode even though they have different protocols.

>> 
>> That's a gross oversimplification.
>
>This can be implemented without breaking userspace.

How?

-- 
David Härdeman
