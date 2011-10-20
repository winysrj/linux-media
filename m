Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45879 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab1JTQJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 12:09:55 -0400
Received: by wyg36 with SMTP id 36so3046891wyg.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 09:09:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
Date: Thu, 20 Oct 2011 12:09:53 -0400
Message-ID: <CAOTqeXp8t-qsC9NBgSD9rkeRuKfJue8JZM7vu+EwidDtrNKvCQ@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Taylor Ralph <taylor.ralph@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 11:30 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Oct 20, 2011 at 11:24 AM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
>> I've attached a patch that correctly sets the max/min/default values
>> for the hdpvr picture controls. The reason the current values didn't
>> cause a problem until now is because any firmware <= 0.15 didn't
>> support them. The latest firmware releases properly support picture
>> controls and the values in the patch are derived from the windows
>> driver using SniffUSB2.0.
>>
>> Thanks to Devin Heitmueller for helping me.
>>
>> Regards.
>> --
>> Taylor
>
> Hi Taylor,
>
> What worries me here is the assertion that the controls didn't work at
> all in previous firmware and driver versions.  Did you downgrade the
> firmware and see that the controls had no effect when using v4l2-ctl?
>

I have 2 HD-PVRs. I ran one with 0x17 and one with 0x15. Using
v4l2-ctl to control the 0x15 unit produced zero changes. It has been
reported by mythtv users in the past the picture control changes did
not work for the HD-PVR.

Regards.
--
Taylor
