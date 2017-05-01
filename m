Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:40485 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952721AbdEAMuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 08:50:01 -0400
Date: Mon, 1 May 2017 14:49:57 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] [RFC] rc-core: report protocol information to userspace
Message-ID: <20170501124957.yqvy6dcqz5lh3bu5@hardeman.nu>
References: <149346313232.25459.10475301883786006034.stgit@zeus.hardeman.nu>
 <20170501103830.GB10867@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170501103830.GB10867@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 11:38:30AM +0100, Sean Young wrote:
>On Sat, Apr 29, 2017 at 12:52:12PM +0200, David Härdeman wrote:
>> Whether we decide to go for any new keytable ioctl():s or not in rc-core, we
>> should provide the protocol information of keypresses to userspace.
>> 
>> Note that this means that the RC_TYPE_* definitions become part of the
>> userspace <-> kernel API/ABI (meaning a full patch should maybe move those
>> defines under include/uapi).
>> 
>> This would also need to be ack:ed by the input maintainers.
>
>This was already NACKed in the past.
>
>http://www.spinics.net/lists/linux-input/msg46941.html
>

Didn't know that, thanks for the pointer. I still think we should
revisit this though. Even if we don't add protocol-aware EVIOC[SG]KEY_V2
ioctls, that information is useful for a configuration tool when
creating keymaps for a new remote.

And examining the parent hardware device (as Dmitry seemed to suggest)
doesn't help with protocol identification.

Another option if we don't want to touch the input layer would be to
export the last_* members from struct rc_dev in sysfs (and I'm guessing
a timestamp would be necessary then). Seems like a lot of work to
accomplish what would otherwise be a one-line change in the input layer
though (one-line since I'm assuming we could provide the protocol
defines in a separate header, other than input-event-codes.h as the
protocols are subsystem-specific).

-- 
David Härdeman
