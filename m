Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63069 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968340Ab3DSNWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 09:22:09 -0400
Received: by mail-qc0-f176.google.com with SMTP id n41so1692747qco.7
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 06:22:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304191158.04116.hverkuil@xs4all.nl>
References: <5167513D.60804@iki.fi>
	<201304190912.06319.hverkuil@xs4all.nl>
	<51710A3F.10909@iki.fi>
	<201304191158.04116.hverkuil@xs4all.nl>
Date: Fri, 19 Apr 2013 09:16:46 -0400
Message-ID: <CAGoCfizZVS2Fu9o=oKHOVewObg++kROw2mNyQrEnTF4ydzRWPQ@mail.gmail.com>
Subject: Re: Keene
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Antti Palosaari <crope@iki.fi>, LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 19, 2013 at 5:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> So perhaps this can be solved with two generic controls:
>
> bool CID_POWER_OFF_AT_LAST_CLOSE
> int CID_POWER_OFF_DELAY (unit: seconds)
>
> If POWER_OFF_AT_LAST_CLOSE is false, then you never power off. If it is true,
> then power off after a given delay. If the delay == 0 then power off immediately.
>
> Drivers can decide on proper default values. But radio devices must start
> with CID_POWER_OFF_AT_LAST_CLOSE set to false for compatibility reasons.
>
> I don't have time for the next few weeks to investigate this further, so if
> you are interested...

Bear in mind that deferred shutdown opens a huge set of problems with
hybrid tuners.  We already have many, many race known conditions
related to closing V4L and then immediately opening the corresponding
DVB device (and closing DVB then immediately opening the V4L device).
Without a proper framework, a change such as this will exacerbate the
problem.

These race conditions typically result in completely undefined
behavior, as you either having both sides of the device powered up at
the same time, or you have the second half powered up and then
conflicting commands are received to power it down because of deferred
commands for the first half to go to sleep.

It's an absolute mess.

And please don't forget that this isn't just about a shared tuner chip
- it's about the state of video decoders and demodulators as well.
You cannot just introduce simple locking in tuner-core and hope that
resolves the problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
