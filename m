Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47714 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3KXSw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 13:52:29 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so3027710wgg.7
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 10:52:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LapwReWVi64eu7fQOpb-xfGC9gWf=5Yz4x22jnYOmMAiw@mail.gmail.com>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
	<CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
	<CAA9z4Lbro=UjZjcjK1e51ikVG7Q2XU9Ei1XWPELCq47iGowkWg@mail.gmail.com>
	<CAGoCfixzV+N7WMhwA=e72pvQJREV5KaR0By=O6+emgsS5eQwGA@mail.gmail.com>
	<CAA9z4LapwReWVi64eu7fQOpb-xfGC9gWf=5Yz4x22jnYOmMAiw@mail.gmail.com>
Date: Sun, 24 Nov 2013 13:52:27 -0500
Message-ID: <CAGoCfiym-UbVn39r+nmY9kHK1jUmuH+n6jV5ougmUAxrZJnf9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Lee <updatelee@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 24, 2013 at 1:40 PM, Chris Lee <updatelee@gmail.com> wrote:
> I made an exception in my app if the system is ATSC/QAM it uses the
> snr = snr * 10.0 and havent found a card yet that it doesnt work with.
> Ive also converted quite a few of my dvb-s tuners to report db in the
> same way. Havent found a card yet that doesnt have the ability to
> report snr in db. Im sure there is one, but I wonder how old it is and
> if anyone still uses them.

The devices which have the ldgt3303 demodulator report in (SNR *
1/256), and there are still quite a few of those out there and in use.
 But yeah, since most of the ATSC/ClearQAM devices out there nowadays
have a demod driver written by one of three people, all who agreed on
the same format, you won't find many devices out there nowadays which
don't use 0.1 dB increments.

That said, everything in the previous paragraph applies exclusively to
ATSC/ClearQAM devices.  There is much more variation once you start
talking about DVB-T/S/S2, etc.

> I have found a few tuner/demods that dont have a method of reporting
> signal strength and just use a calc based off the snr in db to make a
> fake strength.

Yup, there is definitely more ambiguity across demods with the signal
strength field.  In some cases it reports the same as the SNR field,
in other cases it scales the SNR to a 0-65535 range, in yet other
cases it returns garbage or no value at all.

> How I look at is if snr in % is completely arbitrary and means nothing
> when compared from one tuner to another, whats the harm in that
> particularly weird tuner/demod of reporting a fake SNR that is
> arbitrary and have every other device in Linux report something
> useful. Seems dumb to have every device in Linux report an arbitrary
> useless value just because one or two devices cant report anything
> useful.

The whole argument over the years is what that "useful format" should
be.  The problem is bad enough where a whole new API has been proposed
which allows the demod to specify its reporting format explicitly.
That proposed new API has a whole host of *other* problems, but that
was the last attempt to bring some clarity to the problem.

> I just hate seeing every device reporting useless values just because
> one or two tuner/demods are reporting useless values. Why destroy that
> useful data for the sake of making all data uniformly useless.

Unfortunately we're not talking about one or two - we're talking about
dozens.  I wouldn't be remotely surprised to see that more than 50% of
devices out there do not report in 0.1dB increments.  Certainly a
large part of the problem is that users such as yourself have a
slightly skewed viewpoint because your experience is based on the
handful of tuners you own (if you actually own a handful, that's
comparatively quite a lot - most people only own a single tuner).

Yeah, the situation is frustrating.  No easy answers here.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
