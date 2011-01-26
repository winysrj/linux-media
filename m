Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1AZSJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 13:09:35 -0500
Message-ID: <4D405D8E.6020900@redhat.com>
Date: Wed, 26 Jan 2011 15:44:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL] More IR fixes for 2.6.38
References: <yc7vxnkntxcbxdk5pe3jpndi.1296062052946@email.android.com>
In-Reply-To: <yc7vxnkntxcbxdk5pe3jpndi.1296062052946@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-01-2011 15:23, Andy Walls escreveu:
> Mauro,
> 
>  I plan to make extensive lirc_zilog changes starting tonight, so the sooner Jarrod's lirc_zilog.c fix is in a media_tree branch, the less rebase I'll have to do. :)

Andy,

Then, it is better to use Jarod's tree for it. His patches are against
upstream, and are meant to be applied to .38. So, I need first to send
them to linux-next, then to upstream and then merge from upstream,
otherwise, I'll have to manually fix the conflicts on the next merge window.
Due to LCA, I'm not sure if Linus will apply much patches during this
week. So, I'll probably wait until next week to send Jarod's patches
upstream.

> 
> Thanks.
> 
> Andy
> 
> Jarod Wilson <jarod@redhat.com> wrote:
> 
>> Mauro,
>>
>> Please pull these additional IR driver fixes against Linus' tree in for
>> 2.6.38 merge. Without these, mceusb is still broken (keybounce issues),
>> the HD-PVR tx won't work, and ir-kbd-i2c behaves badly with both the
>> HD-PVR and the HVR-1950.
>>
>> Thanks much!
>>
>> The following changes since commit 6fb1b304255efc5c4c93874ac8c066272e257e28:
>>
>>  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2011-01-26 16:31:44 +1000)
>>
>> are available in the git repository at:
>>
>>  git://linuxtv.org/jarod/linux-2.6-ir.git for-2.6.38
>>
>> Jarod Wilson (7):
>>      rc/mce: add mappings for missing keys
>>      hdpvr: fix up i2c device registration
>>      lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
>>      ir-kbd-i2c: improve remote behavior with z8 behind usb
>>      rc/ir-lirc-codec: add back debug spew
>>      rc: use time unit conversion macros correctly
>>      mceusb: really fix remaining keybounce issues
>>
>> drivers/media/rc/ir-lirc-codec.c               |    6 +++-
>> drivers/media/rc/keymaps/rc-rc6-mce.c          |    6 ++++
>> drivers/media/rc/mceusb.c                      |    9 ++++--
>> drivers/media/rc/nuvoton-cir.c                 |    6 ++--
>> drivers/media/rc/streamzap.c                   |   12 ++++----
>> drivers/media/video/hdpvr/hdpvr-core.c         |   24 +++++++++++++++---
>> drivers/media/video/hdpvr/hdpvr-i2c.c          |   30 ++++++++++++++--------
>> drivers/media/video/hdpvr/hdpvr.h              |    3 +-
>> drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++
>> drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
>> drivers/staging/lirc/lirc_zilog.c              |   32 +++++++++++++++++++----
>> 11 files changed, 106 insertions(+), 36 deletions(-)
>>
>> -- 
>> Jarod Wilson
>> jarod@redhat.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

