Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1696 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0JQMw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 08:52:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
Date: Sun, 17 Oct 2010 14:52:17 +0200
Cc: David Ellingsworth <david@identd.dyndns.org>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
In-Reply-To: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010171452.17454.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, October 17, 2010 14:26:18 Hans Verkuil wrote:
> - serialize the suspend and resume functions using the global lock.
> - do not call usb_autopm_put_interface after a disconnect.
> - fix a race when disconnecting the device.

Regarding autosuspend: something seems to work since the power/runtime_status
attribute goes from 'suspended' to 'active' whenever the radio handle is open.
But the suspend and resume functions are never called. I can't figure out
why not. I don't see anything strange.

The whole autopm stuff is highly suspect anyway on a device like this since
it is perfectly reasonable to just set a frequency and exit. The audio is
just going to the line-in anyway. In other words: not having the device node
open does not mean that the device is idle and can be suspended.

My proposal would be to rip out the whole autosuspend business from this
driver. I've no idea why it is here at all.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
