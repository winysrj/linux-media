Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48700 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1FKRIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:08:06 -0400
Received: by eyx24 with SMTP id 24so1213180eyx.19
        for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 10:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106111902.11384.hverkuil@xs4all.nl>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<4a3fc9cd-d7e1-4692-92cb-af4d652c0224@email.android.com>
	<BANLkTikJbhC--Qp4KUBjFdrCMuvvoMuxaA@mail.gmail.com>
	<201106111902.11384.hverkuil@xs4all.nl>
Date: Sat, 11 Jun 2011 13:08:04 -0400
Message-ID: <BANLkTi=XkLVOc6NfQvD66o-ppD9Fch42SQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 11, 2011 at 1:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> OK, but how do you get it into standby in the first place? (I must be missing
> something here...)

The tuner core puts the chip into standby when the last V4L filehandle
is closed.  Yes, I realize this violates the V4L spec since you should
be able to make multiple calls with something like v4l2-ctl, but
nobody has ever come up with a better mechanism for knowing when to
put the device to sleep.

We've been forced to choose between the purist perspective, which is
properly preserving state, never powering down the tuner and sucking
up 500ma on the USB port when not using the tuner, versus powering
down the tuner when the last party closes the filehandle, which
preserves power but breaks v4l2 conformance and in some cases is
highly noticeable with tuners that require firmware to be reloaded
when being powered back up.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
