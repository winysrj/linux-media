Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:39151 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752762AbdFQLUM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 07:20:12 -0400
Date: Sat, 17 Jun 2017 13:20:10 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] rc-core: add protocol to EVIOC[GS]KEYCODE_V2 ioctl
Message-ID: <20170617112010.566aun44rbumn6gx@hardeman.nu>
References: <20170429084458.rwoty4bdce6iqftr@hardeman.nu>
 <20170611161740.GB16107@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170611161740.GB16107@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 11, 2017 at 05:17:40PM +0100, Sean Young wrote:
>On Sat, Apr 29, 2017 at 10:44:58AM +0200, David Härdeman wrote:
>> >This can be implemented without breaking userspace.
>> 
>> How?
>
>The current keymaps we have do not specify the protocol variant, only
>the protocol (rc6 vs rc6-mce). So to support this, we have to be able
>to specify multiple protocols at the same time. So I think the protocol
>should be a bitmask.
>
>Also, in your example you re-used RC_TYPE_OTHER to match any protocol;
>I don't think that is a good solution since there are already keymaps
>which use other.
>
>So if we have an "struct rc_scancode" which looks like:
>
>struct rc_scancode {
>	u64 protocol;
>	u64 scancode;
>};
>
>Then if the keymap protocol is rc6, ir-keytable should set the protocol
>to RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32
> | RC_BIT_RC6_MCE.
>
>If the old ioctl is used, then the protocol should be set to RC_BIT_ALL.
>
>I can't think of anything what would break with this scheme.

I've tried coding up that solution before and the problem is that it'll
still require heuristics in the presence of a mix of old and new style
ioctl():s.

For example:

old_ioctl_set(0x1234 = KEY_A);
new_ioctl_set(PROTOCOL_NEC, 0x1234 = KEY_B);
new_ioctl_set(PROTOCOL_JVC, 0x1234 = KEY_C);
old_ioctl_get(0x1234) = ?
old_ioctl_set(0x1234 = KEY_D);
new_ioctl_get(PROTOCOL_NEC, 0x1234) = ?

-- 
David Härdeman
