Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34535 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1JTQfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 12:35:42 -0400
Received: by bkbzt19 with SMTP id zt19so3750331bkb.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 09:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111020162340.GC7530@jannau.net>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
	<CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
	<20111020162340.GC7530@jannau.net>
Date: Thu, 20 Oct 2011 12:35:40 -0400
Message-ID: <CAGoCfiwXjQsAEVfFiNA5CNw1PVuO0npO63pGb91rpbPuKGvwZQ@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Janne Grunau <janne@jannau.net>
Cc: Taylor Ralph <taylor.ralph@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 12:23 PM, Janne Grunau <janne@jannau.net> wrote:
> On Thu, Oct 20, 2011 at 11:30:11AM -0400, Devin Heitmueller wrote:
>> On Thu, Oct 20, 2011 at 11:24 AM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
>> > I've attached a patch that correctly sets the max/min/default values
>> > for the hdpvr picture controls. The reason the current values didn't
>> > cause a problem until now is because any firmware <= 0.15 didn't
>> > support them. The latest firmware releases properly support picture
>> > controls and the values in the patch are derived from the windows
>> > driver using SniffUSB2.0.
>> >
>> > Thanks to Devin Heitmueller for helping me.
>>
>> What worries me here is the assertion that the controls didn't work at
>> all in previous firmware and driver versions.  Did you downgrade the
>> firmware and see that the controls had no effect when using v4l2-ctl?
>>
>> Janne, any comment on whether the controls *ever* worked?
>
> I've looked at them only at very beginning and if I recall correctly
> they had no visible effects. The values in the linux driver were taken
> from sniffing the windows driver. I remember that I've verified the
> default brightness value since 0x86 looked odd. I'm not sure that I
> verified all controls. I might have assumed all controls shared the
> same value range.
>
> There were previous reports of the picture controls not working at all.

Hi Janne,

Thanks for taking the time to chime in.

If the controls really were broken all along under Linux, then that's
good to know.  That said, I'm not confident the changes Taylor
proposed should really be run against older firmwares.  There probably
needs to be a check to have the values in question only applied if
firmware >= 16.  If the controls were broken entirely, then we should
probably not advertise them in ENUM_CTRL and S_CTRL should return
-EINVAL if running the old firmware (perhaps put a warning in the
dmesg output saying the controls are unavailable because the user is
not running firmware >= 16).

My immediate concern is about ensuring we don't cause breakage in
older firmware.  For example, we don't know if there are some older
firmware revisions that *did* work with the driver.  The controls
might have worked up to firmware revision 10, then been broken from
11-15, then work again in 16 (with the new hue value needed).  The
safe approach is to only use these new settings if they're running
firmware >= 16.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
