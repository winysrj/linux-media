Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40391 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2L2RjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 12:39:12 -0500
Received: by mail-qc0-f179.google.com with SMTP id b14so5869598qcs.24
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 09:39:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212291253.45189.hverkuil@xs4all.nl>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
	<20121228222744.6b567a9b@redhat.com>
	<201212291253.45189.hverkuil@xs4all.nl>
Date: Sat, 29 Dec 2012 12:39:11 -0500
Message-ID: <CAGoCfix-3AgrkBUtFwLYTQf3YYL9t-8D7Qrge1fvJg-Fd+aBLA@mail.gmail.com>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT" recommendation
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 29, 2012 at 6:53 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> In my opinion these are application bugs, and not ABI breakages.

I'm not sure if you saw the email, but Linus seems to disagree with
your assertion quite strongly:

https://lkml.org/lkml/2012/12/23/75

The change as proposed results in a situation where apps worked fine,
user upgrades kernel, and now apps are broken.  That sounds a lot
like:

"If a change results in user programs breaking, it's a bug in the
kernel. We never EVER blame the user programs. How hard can this be to
understand?"

> As Mauro
> mentioned, some drivers don't return an error and so would always have failed
> with these apps (examples: cx18/ivtv, gspca).

Yeah, except uncompressed support is quite new with cx18, ivtv doesn't
support uncompressed at all, and gspca is for webcams, not TV.

> Do these apps even handle the case where TRY isn't implemented at all by the
> driver? (hdpvr)

I haven't looked at compressed formats.  Tvtime doesn't support them
at all, and MythTV uses a completely different code path for
compressed capture.  MythTV even has special code for the HD-PVR,
which presumably was to work around API inconsistencies.

> There is nothing in the spec that says that you will get an error if the
> pixelformat isn't supported by the driver, in fact it says the opposite:
>
> "Very simple, inflexible devices may even ignore all input and always return
> the default parameters."
>
> We are not in the business to work around application bugs, IMHO. We can of
> course delay making these changes until those applications are fixed.

Except those two applications aren't the only two applications in
existence which make use of the V4L2 API.  Oh, and applications are
supposed to continue working unmodified through kernel upgrades.

> I suspect that the behavior of returning an error if a pixelformat is not
> supported is a leftover from the V4L1 API (VIDIOCSPICT). When drivers were
> converted to S/TRY_FMT this method of handling unsupported pixelformats was
> probably never changed. And quite a few newer drivers copy-and-pasted that
> method. Drivers like cx18/ivtv that didn't copy-and-paste code looked at the
> API and followed what the API said.
>
> At the moment most TV drivers seem to return an error, whereas for webcams
> it is hit and miss: uvc returned an error (until it was fixed recently),
> gspca didn't. So webcam applications probably do the right thing given the
> behavior of gspca.

What if we returned an error but still changed the struct to specify
the supported format?  That's not what the spec says, but it seems
like that's what is implemented in many drivers today and what many
applications expect to happen.

No doubt, this is a mess, and if we had tighter enforcement and better
specs before this stuff went upstream years ago, we wouldn't be in
this situation.  But that's not the world we live in, and we have to
deal with where we stand today.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
