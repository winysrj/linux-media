Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:52136 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2L1T7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 14:59:18 -0500
Received: by mail-qc0-f171.google.com with SMTP id d1so5684186qca.30
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 11:59:17 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 28 Dec 2012 14:52:24 -0500
Message-ID: <CAGoCfiwzFFZ+hLOKT-5cHTJOiY8ZsRVXmDx+W7x+7uMXMKWk5g@mail.gmail.com>
Subject: ABI breakage due to "Unsupported formats in TRY_FMT/S_FMT" recommendation
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

So I noticed that one of the "V4L2 ambiguities" discussed at the Media
Workshop relates to expected behavior with TRY_FMT/S_FMT.
Specifically (from
http://www.linuxtv.org/news.php?entry=2012-12-28.mchehab):

===
1.4. Unsupported formats in TRY_FMT/S_FMT

What should a driver return in TRY_FMT/S_FMT if the requested format
is not supported (possible behaviors include returning the currently
selected format or a default format).
The spec says this: "Drivers should not return an error code unless
the input is ambiguous", but it does not explain what constitutes an
ambiguous input. In my opinion TRY/S_FMT should never return an error
other than EINVAL (if the buffer type is unsupported) or EBUSY (for
S_FMT if streaming is in progress).
Should we make a recommendation whether the currently selected format
or a default format should be returned?
One proposal is to just return a default format if the requested
pixelformat is unsupported. Returning the currently selected format
leads to inconsistent results.
Results:
TRY_FMT/S_FMT should never return an error when the requested format
is not supported. Drivers should always return a valid format,
preferably a format that is as widely supported by applications as
possible.
Both TRY_FMT and S_FMT should have the same behaviour. Drivers should
not return different formats when getting the same input parameters.
The format returned should be a driver default format if possible
(stateless behaviour) but can be stateful if needed.
The API spec should let clear that format retuns may be different when
different video inputs (or outputs) are selected.
===

Note that this will cause ABI breakage with existing applications.  If
an application expects an error condition to become aware that the
requested format was not supported, that application will silently
think the requested format was valid but in fact the driver is
returning data in some other format.

Tvtime (one of the more popular apps for watching analog television)
is one such application that will broken.

http://git.linuxtv.org/tvtime.git/blob/HEAD:/src/videoinput.c#l452

If YUVY isn't supported but UYVY is (for example, with the Hauppauge
HVR-950q), the application will think it's doing YUYV when in fact the
driver is returning UYVY.

MythTV is a little better (it does ultimately store the format
returned by the driver), however even there it depends on an error
being returned in order to know to do userland format conversion.

https://github.com/MythTV/mythtv/blob/master/mythtv/libs/libmythtv/recorders/NuppelVideoRecorder.cpp#L1367

Now it would be quite simple to change tvtime to use the expected
behavior, but if backward compatibility with the ABI is of paramount
importance, then we cannot proceed with this change as proposed.
Don't misunderstand me - if I were inventing the API today then the
proposed approach is what I would recommend - but since these parts of
the ABI are something like ten years old, we have to take into account
legacy applications.

Discussion is welcome.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
