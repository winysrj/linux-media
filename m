Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52461 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab0DAS3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 14:29:54 -0400
Received: by bwz1 with SMTP id 1so1063266bwz.21
        for <linux-media@vger.kernel.org>; Thu, 01 Apr 2010 11:29:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB4D9AB.6070907@redhat.com>
References: <201004011001.10500.hverkuil@xs4all.nl>
	 <201004011411.02344.laurent.pinchart@ideasonboard.com>
	 <4BB4A9E2.9090706@redhat.com> <201004011642.19889.hverkuil@xs4all.nl>
	 <4BB4B569.3080608@redhat.com>
	 <x2y829197381004010958u82deb516if189d4fb00fbc5e6@mail.gmail.com>
	 <4BB4D9AB.6070907@redhat.com>
Date: Thu, 1 Apr 2010 14:29:52 -0400
Message-ID: <g2q829197381004011129lc706e6c3jcac6dcc756012173@mail.gmail.com>
Subject: Re: V4L-DVB drivers and BKL
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 1, 2010 at 1:36 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> If you take a look at em28xx-dvb, it is not lock-protected. If the bug is due
> to the async load, we'll need to add the same locking at *alsa and *dvb
> parts of em28xx.

Yes, that is correct.  The problem effects both dvb and alsa, although
empirically it is more visible with the dvb case.

> Yet, in this specific case, as the errors are due to the reception of
> wrong data from tvp5150, maybe the problem is due to the lack of a
> proper lock at the i2c access.

The problem is because hald sees the new device and is making v4l2
calls against the tvp5150 even though the gpio has been toggled over
to digital mode.  Hence an i2c lock won't help.  We would need to
implement proper locking of analog versus digital mode, which
unfortunately would either result in hald getting back -EBUSY on open
of the V4L device or the DVB module loading being deferred while the
v4l side of the board is in use (neither of which is a very good
solution).

This is what got me thinking a few weeks ago that perhaps the
submodules should not be loaded asynchronously.  In that case, at
least the main em28xx module could continue to hold the lock while the
submodules are still being loaded.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
