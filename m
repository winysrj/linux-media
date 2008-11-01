Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA1FlBM3000500
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 11:47:11 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA1Fk3G4023353
	for <video4linux-list@redhat.com>; Sat, 1 Nov 2008 11:46:03 -0400
Received: by ey-out-2122.google.com with SMTP id 4so557539eyf.39
	for <video4linux-list@redhat.com>; Sat, 01 Nov 2008 08:46:03 -0700 (PDT)
Message-ID: <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
Date: Sat, 1 Nov 2008 11:46:03 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200811011505.51716.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
Cc: em28xx <em28xx@mcentral.de>, linux-dvb@linuxtv.org,
	v4l <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I have held off on offering an opinion this to see what others
thought, but I think now may be the time to speak up.

First off, a disclaimer: I am a contributor to the existing in-kernel
em28xx driver.  I have spent many months working on that codebase,
adding device support and fixing bugs.  I also have a large series of
patches queuing up that significantly improve both the codebase's
functionality and maintainability (having recently been given access
to some of the datasheets thanks to Empia and Pinnacle).

As one of the half dozen people who are working on the linux-dvb
version of em28xx, I am against the wholesale replacement of the
current version with Markus's codebase.

Why?  I've got a list of reasons, but in the interest of fairness,
let's start with what I see to be the good things:

# Significantly better device support - Markus has access to the
actual hardware for many of these devices, spends time adding support
for new devices, and since he works for the chipset vendor can in many
cases just call the manufacturer of the product and ask them
questions.

# Proper tuner locking - tuner locking was one of the big issues that
caused infighting before Markus forked off his code. Let's face it -
it's been over a year and most of the other devices don't do any
locking at all. His scheme, while not unified across drivers, is
better than nothing.

# Based on the chipset datasheets - He had the benefit of just being
able to look up what the registers mean

# VBI support for analog - a recent addition in the mrec driver, but
none at all in the V4L driver

# Support for other demods not currently in V4L - I don't think we
have any devices yet that use the LGDT3304, but Markus's driver has
support for devices that do.

# More thoroughly debugged - He's working on this full time. He's
working bugs, dealing with issues, and putting in proper fixes based
on reliable information instead of reverse engineering.

========

Now, the not so good things:

# Doesn't leverage common infrastructure such as videobuf (resulting
in duplicate functionality and more difficult for those who have to
maintain multiple drivers)

# Firmware blobs embedded in source - While it's easier for the user,
many distributions do not allow firmware blobs in the kernel due to
the belief that this is not GPL compatible. We would need to get
permission from the vendor to redistribute the firmware as a file (in
the V4L driver, we extract it from the Windows driver binary)

# Ambigious licensing - some of the files have headers from companies
other than Empiatech which are very clearly not GPL compatible (like
the Micronas drx3973d driver). Also, it's not clear that even the
firmware blobs mentioned above are authorized to be redistributed by
their rightful owners (Xceive and Micronas). While Empiatech may be ok
with making a GPL driver, these parties have not consented to having
their intellectual property in the kernel (they may have consented but
the header files say just the opposite).

# It has its own xc3028 and xc5000 tuner driver. I don't know whether
his driver is better than the one in V4L. Presumably he has the
datasheets for those parts, but on the other hand the V4L driver
allows loading of the firmware externally. The V4L drivers are also
used by devices beyond the em28xx and may have functionality required
by other companies products.

# What I'll call "Black magic" - lots of arbitrary code without any
explanation as to what it is doing or why. Why does the DVB init
routine write 0x77 to register 0x12? What does that do? A combination
of poor use of constants and commented code combined with a lack of
access to the datasheets leaves this a mystery. You just have to
"trust that it's doing the right thing because it works"

# He's the only one who has access to the datasheets, so there is
limited opportunity for peer review. The community driver is based on
reverse engineering, and we can pass around USB traces we collect to
justify/explain design decisions. How do you question a design when
the basis of answers is essentially "because the secret document that
I can't show you says so"?

====

I shared this list with Markus a few months ago and, the licensing
issues aside, it was his contention that "nobody cares" about most of
the things above.  As a maintainer that wants to continue contributing
to the codebase, *I* care.  And I'm sure that anybody other than
Markus who wants to understand the em28xx codebase and be able to fix
bugs would also care.  I'm also concerned with consistency between
drivers.  Having one driver do things differently than all the others
is just a maintenance headache for those who have to support multiple
drivers.

A number of people have suggested that nobody was willing to
incorporate Markus's changes incrementally to improve the in-kernel
driver.  This couldn't be further from the truth.  I appealed to
Markus on multiple occasions trying to find some compromise where his
changes could be merged into the mainline em28xx driver.  He outright
refused.  It was his contention that his driver was/is better than the
in-kernel driver in every possible way, and that the existing code has
no redeeming value.  In fact, I was accused of taking his GPL'd code
without his consent and incorporating it into the linux-dvb codebase.
It's this "all or nothing" attitude that has prevented his work thus
far from being incorporated, not the unwillingness of people like
myself to do the work to merge his changes in a sane matter.

I *really* want to see this resolved, because I recognize that I could
be better served working on other things than duplicating efforts to
debug issues that Markus may have already fixed in his codebase.  But
just throwing away the work of half a dozen other developers on an
actively maintained driver is not really the sort of compromise I
think would be best for the community.

I'm sorry if the sharing of my views on this matter create more
animosity within the community, as that is the exact opposite of what
I want.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
