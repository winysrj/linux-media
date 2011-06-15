Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49296 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1FOUJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 16:09:47 -0400
Received: by ewy4 with SMTP id 4so304342ewy.19
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2011 13:09:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106152155.57978.hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<201106111902.11384.hverkuil@xs4all.nl>
	<BANLkTi=XkLVOc6NfQvD66o-ppD9Fch42SQ@mail.gmail.com>
	<201106152155.57978.hverkuil@xs4all.nl>
Date: Wed, 15 Jun 2011 16:09:45 -0400
Message-ID: <BANLkTinx9Pa_Oe3qOfNgKZS3e82US6r8wg@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 15, 2011 at 3:55 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Why would that violate the spec? If the last filehandle is closed, then
> you can safely poweroff the tuner. The only exception is when you have a radio
> tuner whose audio output is hooked up to some line-in: there you can't power off
> the tuner.

The use case that some expect to work is:

v4l2-ctl <set standard>
v4l2-ctl <set frequency>
cat /dev/video0 > out.mpg

By powering off the tuner after v4l2-ctl closes the device node, the
cat won't work as expected because the tuner will be powered down.

>> We've been forced to choose between the purist perspective, which is
>> properly preserving state, never powering down the tuner and sucking
>> up 500ma on the USB port when not using the tuner, versus powering
>> down the tuner when the last party closes the filehandle, which
>> preserves power but breaks v4l2 conformance and in some cases is
>> highly noticeable with tuners that require firmware to be reloaded
>> when being powered back up.
>
> Seems fine to me. What isn't fine is that a driver like e.g. em28xx powers off
> the tuner but doesn't power it on again on the next open. It won't do that
> until the first S_FREQUENCY/S_TUNER/S_STD call.

You don't want to power up the tuner unless you know the user intends
to use it.  For example, you don't want to power up the tuner if the
user intends to capture on composite/s-video input (as this consumes
considerably more power).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
