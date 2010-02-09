Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f183.google.com ([209.85.223.183]:47283 "EHLO
	mail-iw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0BIWcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 17:32:23 -0500
Received: by iwn13 with SMTP id 13so8960660iwn.25
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 14:32:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <215789.18894.qm@web35803.mail.mud.yahoo.com>
References: <215789.18894.qm@web35803.mail.mud.yahoo.com>
Date: Tue, 9 Feb 2010 17:32:22 -0500
Message-ID: <be3a4a1002091432n7427bae1n776cfcc2aaf993c5@mail.gmail.com>
Subject: Re: Kworld ATSC usb 435Q device and RF tracking filter calibration
From: Jarod Wilson <jarod@wilsonet.com>
To: Amy Overmyer <aovermy@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2010 at 5:16 PM, Amy Overmyer <aovermy@yahoo.com> wrote:
> I have one of these devices. It works OK in windows, but I'd like to stick it on my myth backend as a 3rd tuner, just in case. I'm using it for 8VSB OTA. I took a patch put forth a while back on this list and was able to put that on the kernel 2.6.31.6. I am able to tune and lock channels with it, but, like the people earlier, I see the RF tracking filter calibration in the syslogs and tuning takes some time.
>
> Is there anything I can do to debug this? I'm a programmer by trade (err my systems are usually a bit more special purpose than a linux box as I'm an embedded systems type guy, but it's all bits anyway), so don't be afraid to suggest code changes or point me in a direction.

Best as I can recall, the problem is with the gpio reset sequence for
these devices. Something is getting reset when it shouldn't, and all
the tda18271 registers wind up zeroed out when they shouldn't be, and
thus rf tracking filter calibration gets re-run, because the register
bit that signifies its already been done isn't set any longer... So
there needs to be some debugging done, probably with the gpio reset
config. I keep meaning to hook the stick up under windows and sniff
traffic again to see if I can see what's being done differently, just
don't ever seem to get around to it.

-- 
Jarod Wilson
jarod@wilsonet.com
