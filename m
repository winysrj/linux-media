Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:33042 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1422808AbdD1Q7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 12:59:13 -0400
Date: Fri, 28 Apr 2017 18:59:11 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, sean@mess.org
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170428165911.axrlw6aic3cqabas@hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332526341.32431.11307248841385136294.stgit@zeus.hardeman.nu>
 <20170428083133.2e6621bd@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170428083133.2e6621bd@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 08:31:33AM -0300, Mauro Carvalho Chehab wrote:
>Em Thu, 27 Apr 2017 22:34:23 +0200
>David Härdeman <david@hardeman.nu> escreveu:
...
>> This patch changes how the "input_keymap_entry" struct is interpreted
>> by rc-core by casting it to "rc_keymap_entry":
>> 
>> struct rc_scancode {
>> 	__u16 protocol;
>> 	__u16 reserved[3];
>> 	__u64 scancode;
>> }
>> 
>> struct rc_keymap_entry {
>> 	__u8  flags;
>> 	__u8  len;
>> 	__u16 index;
>> 	__u32 keycode;
>> 	union {
>> 		struct rc_scancode rc;
>> 		__u8 raw[32];
>> 	};
>> };
>> 
...
>
>Nack.

That's not a very constructive approach. If you have a better approach
in mind I'm all ears. Because you're surely not suggesting that we stay
with the current protocol-less approach forever?

>No userspace breakages are allowed.

That's a gross oversimplification. A cursory glance at the linux-api
mailing list shows plenty of examples of changes that might not be 100%
backwards-compatible. Here's an example:
http://marc.info/?l=linux-fsdevel&m=149089166918069

That's the kind of discussion we need to have - i.e. the best way to go
about this and to minimize the damage to userspace. In that vein, I'll
post an alternative approach shortly as the basis for further
discussion.

>There's no way to warrant that
>ir-keytable version is compatible with a certain Kernel version.

I know. But we know when an ioctl() is made whether it is a
protocol-aware one or not.

-- 
David Härdeman
