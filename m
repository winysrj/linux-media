Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:41996 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0BIXBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 18:01:20 -0500
Received: by fxm20 with SMTP id 20so647472fxm.21
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 15:01:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <215789.18894.qm@web35803.mail.mud.yahoo.com>
References: <215789.18894.qm@web35803.mail.mud.yahoo.com>
Date: Tue, 9 Feb 2010 18:01:18 -0500
Message-ID: <15cfa2a51002091501k7024fd1apf77dfa5783671ef2@mail.gmail.com>
Subject: Re: Kworld ATSC usb 435Q device and RF tracking filter calibration
From: Robert Cicconetti <grythumn@gmail.com>
To: Amy Overmyer <aovermy@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have this stick running on my Mythtv box with the patch and a quick
hack to disable the additional calibrations. It works, most of the
time, but will occasionally stop working until I reboot. The frequency
of this is reduced if I tell Mythbackend to only grab the tuner when
it needs it... might be a calibration issue, might be marginal
hardware overheating.

-R C

On Tue, Feb 9, 2010 at 5:16 PM, Amy Overmyer <aovermy@yahoo.com> wrote:
> I have one of these devices. It works OK in windows, but I'd like to stick it on my myth backend as a 3rd tuner, just in case. I'm using it for 8VSB OTA. I took a patch put forth a while back on this list and was able to put that on the kernel 2.6.31.6. I am able to tune and lock channels with it, but, like the people earlier, I see the RF tracking filter calibration in the syslogs and tuning takes some time.
>
> Is there anything I can do to debug this? I'm a programmer by trade (err my systems are usually a bit more special purpose than a linux box as I'm an embedded systems type guy, but it's all bits anyway), so don't be afraid to suggest code changes or point me in a direction.
>
> Thanks,
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
