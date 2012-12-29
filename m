Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2005 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2L2Ly0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 06:54:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT" recommendation
Date: Sat, 29 Dec 2012 12:53:45 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com> <20121228222744.6b567a9b@redhat.com>
In-Reply-To: <20121228222744.6b567a9b@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212291253.45189.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat December 29 2012 01:27:44 Mauro Carvalho Chehab wrote:
> Em Fri, 28 Dec 2012 14:52:24 -0500
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> 
> > Hi there,
> > 
> > So I noticed that one of the "V4L2 ambiguities" discussed at the Media
> > Workshop relates to expected behavior with TRY_FMT/S_FMT.
> > Specifically (from
> > http://www.linuxtv.org/news.php?entry=2012-12-28.mchehab):
> > 
> > ===
> > 1.4. Unsupported formats in TRY_FMT/S_FMT
> > 
> > What should a driver return in TRY_FMT/S_FMT if the requested format
> > is not supported (possible behaviors include returning the currently
> > selected format or a default format).
> > The spec says this: "Drivers should not return an error code unless
> > the input is ambiguous", but it does not explain what constitutes an
> > ambiguous input. In my opinion TRY/S_FMT should never return an error
> > other than EINVAL (if the buffer type is unsupported) or EBUSY (for
> > S_FMT if streaming is in progress).
> > Should we make a recommendation whether the currently selected format
> > or a default format should be returned?
> > One proposal is to just return a default format if the requested
> > pixelformat is unsupported. Returning the currently selected format
> > leads to inconsistent results.
> > Results:
> > TRY_FMT/S_FMT should never return an error when the requested format
> > is not supported. Drivers should always return a valid format,
> > preferably a format that is as widely supported by applications as
> > possible.
> > Both TRY_FMT and S_FMT should have the same behaviour. Drivers should
> > not return different formats when getting the same input parameters.
> > The format returned should be a driver default format if possible
> > (stateless behaviour) but can be stateful if needed.
> > The API spec should let clear that format retuns may be different when
> > different video inputs (or outputs) are selected.
> > ===
> > 
> > Note that this will cause ABI breakage with existing applications.  If
> > an application expects an error condition to become aware that the
> > requested format was not supported, that application will silently
> > think the requested format was valid but in fact the driver is
> > returning data in some other format.
> > 
> > Tvtime (one of the more popular apps for watching analog television)
> > is one such application that will broken.
> > 
> > http://git.linuxtv.org/tvtime.git/blob/HEAD:/src/videoinput.c#l452
> > 
> > If YUVY isn't supported but UYVY is (for example, with the Hauppauge
> > HVR-950q), the application will think it's doing YUYV when in fact the
> > driver is returning UYVY.
> > 
> > MythTV is a little better (it does ultimately store the format
> > returned by the driver), however even there it depends on an error
> > being returned in order to know to do userland format conversion.
> > 
> > https://github.com/MythTV/mythtv/blob/master/mythtv/libs/libmythtv/recorders/NuppelVideoRecorder.cpp#L1367
> > 
> > Now it would be quite simple to change tvtime to use the expected
> > behavior, but if backward compatibility with the ABI is of paramount
> > importance, then we cannot proceed with this change as proposed.
> > Don't misunderstand me - if I were inventing the API today then the
> > proposed approach is what I would recommend - but since these parts of
> > the ABI are something like ten years old, we have to take into account
> > legacy applications.
> 
> Thanks for pointing it!
> 
> (c/c Hans, as he started those discussions)
> 
> Well, if applications will break with this change, then we need to revisit
> the question, and decide otherwise, as it shouldn't break userspace.
> 
> It should be noticed, however, that currently, some drivers won't
> return errors when S_FMT/TRY_FMT requests invalid parameters.
> 
> So, IMHO, what should be done is:
> 	1) to not break userspace;
> 	2) userspace apps should be improved to handle those drivers
> that have a potential of breaking them;
> 	3) clearly state at the API, and enforce via compliance tool,
> that all drivers will behave the same.

In my opinion these are application bugs, and not ABI breakages. As Mauro
mentioned, some drivers don't return an error and so would always have failed
with these apps (examples: cx18/ivtv, gspca).

Do these apps even handle the case where TRY isn't implemented at all by the
driver? (hdpvr)

There is nothing in the spec that says that you will get an error if the
pixelformat isn't supported by the driver, in fact it says the opposite:

"Very simple, inflexible devices may even ignore all input and always return
the default parameters."

We are not in the business to work around application bugs, IMHO. We can of
course delay making these changes until those applications are fixed.

I suspect that the behavior of returning an error if a pixelformat is not
supported is a leftover from the V4L1 API (VIDIOCSPICT). When drivers were
converted to S/TRY_FMT this method of handling unsupported pixelformats was
probably never changed. And quite a few newer drivers copy-and-pasted that
method. Drivers like cx18/ivtv that didn't copy-and-paste code looked at the
API and followed what the API said.

At the moment most TV drivers seem to return an error, whereas for webcams
it is hit and miss: uvc returned an error (until it was fixed recently),
gspca didn't. So webcam applications probably do the right thing given the
behavior of gspca.

What does xawtv do, BTW?

Regards,

	Hans
