Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57844 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1BWVJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 16:09:53 -0500
Received: by eyx24 with SMTP id 24so1473468eyx.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 13:09:52 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 23 Feb 2011 16:09:51 -0500
Message-ID: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>
Subject: Question on V4L2 S_STD call
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello there,

I was debugging some PAL issues with cx231xx, and noticed some
unexpected behavior with regards to selecting PAL standards.

In particular, tvtime has an option for PAL which corresponds to the
underlying value "0xff".  This basically selects *any* PAL standard.
However, the cx231xx has code for setting up the DIF which basically
says:

if (standard & V4L2_STD_MN) {
 ...
} else if ((standard == V4L2_STD_PAL_I) |
                        (standard & V4L2_STD_PAL_D) |
			(standard & V4L2_STD_SECAM)) {
 ...
} else {
  /* default PAL BG */
  ...
}

As a result, if you have a PAL-B/G signal and select "PAL" in tvtime,
the test passes for PAL_I/PAL_D/SECAM since that matches the bitmask.
The result of course is garbage video.

So here is the question:

How are we expected to interpret an application asking for "PAL" in
cases when the driver needs a more specific video standard?

I can obviously add code to tvtime in the long term to have the user
provide a more specific standard instead of "PAL", but since it is
supported in the V4L2 spec, I would like to understand what the
expected behavior should be in drivers.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
