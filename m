Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49120 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0JRNQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:16:36 -0400
Received: by ywi6 with SMTP id 6so329540ywi.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 06:16:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010171452.17454.hverkuil@xs4all.nl>
References: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
	<201010171452.17454.hverkuil@xs4all.nl>
Date: Mon, 18 Oct 2010 09:16:33 -0400
Message-ID: <AANLkTikPugSRT-t=5bKSLjk3eDmeYh5NYUui=uks35vy@mail.gmail.com>
Subject: Re: [RFC PATCH] radio-mr800: locking fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 8:52 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sunday, October 17, 2010 14:26:18 Hans Verkuil wrote:
>> - serialize the suspend and resume functions using the global lock.
>> - do not call usb_autopm_put_interface after a disconnect.
>> - fix a race when disconnecting the device.
>
> Regarding autosuspend: something seems to work since the power/runtime_status
> attribute goes from 'suspended' to 'active' whenever the radio handle is open.
> But the suspend and resume functions are never called. I can't figure out
> why not. I don't see anything strange.
>
> The whole autopm stuff is highly suspect anyway on a device like this since
> it is perfectly reasonable to just set a frequency and exit. The audio is
> just going to the line-in anyway. In other words: not having the device node
> open does not mean that the device is idle and can be suspended.
>
> My proposal would be to rip out the whole autosuspend business from this
> driver. I've no idea why it is here at all.
>
> Regards,
>
>        Hans

Hans, I highly agree with that analysis. The original author put that
code in. But like you, I'm not sure if it was ever really valid. Since
I didn't have anything to test with, I left it untouched.

Regards,

David Ellingsworth
