Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1JTPaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 11:30:14 -0400
Received: by bkbzt19 with SMTP id zt19so3680429bkb.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 08:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
References: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
Date: Thu, 20 Oct 2011 11:30:11 -0400
Message-ID: <CAGoCfiyCPD-W3xeqD4+AE3xCo-bj05VAy4aHXMNXP7P124ospQ@mail.gmail.com>
Subject: Re: [PATCH] [media] hdpvr: update picture controls to support
 firmware versions > 0.15
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Taylor Ralph <taylor.ralph@gmail.com>
Cc: linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 20, 2011 at 11:24 AM, Taylor Ralph <taylor.ralph@gmail.com> wrote:
> I've attached a patch that correctly sets the max/min/default values
> for the hdpvr picture controls. The reason the current values didn't
> cause a problem until now is because any firmware <= 0.15 didn't
> support them. The latest firmware releases properly support picture
> controls and the values in the patch are derived from the windows
> driver using SniffUSB2.0.
>
> Thanks to Devin Heitmueller for helping me.
>
> Regards.
> --
> Taylor

Hi Taylor,

What worries me here is the assertion that the controls didn't work at
all in previous firmware and driver versions.  Did you downgrade the
firmware and see that the controls had no effect when using v4l2-ctl?

Janne, any comment on whether the controls *ever* worked?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
