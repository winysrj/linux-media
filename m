Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60537 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2F0Ew0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 00:52:26 -0400
Received: by obbuo13 with SMTP id uo13so930125obb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 21:52:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEA80C3.90102@netscape.net>
References: <4FE9FA7F.60800@netscape.net>
	<CAGoCfiyWLdtNVX-2CT9PraAvq-4WL3vUjqaw8o7+S-10R-eCQw@mail.gmail.com>
	<4FEA80C3.90102@netscape.net>
Date: Wed, 27 Jun 2012 00:52:24 -0400
Message-ID: <CAGoCfiwaXZev2yjUuFDB-Z-kZcgoBA+6V7VZ3LBidzw7zb9x3A@mail.gmail.com>
Subject: Re: dheitmueller/cx23885_fixes.git and mygica x8507
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:40 PM, Alfredo Jesús Delaiti
<alfredodelaiti@netscape.net> wrote:
> The problem was that tvtime was set to 768, by passing a resolution to 720
> was solved. Sorry for not having tried before.
> With a resolution of 720 pixels the image looks good.
> My sincere apologies and thanks.

I'll have to check if that's a driver bug or not.  The way the logic
is supposed to work is the application is supposed to propose a size,
and if the driver concludes the size is unacceptable it should return
the size that it intends to actually operate at.  The application is
expected to read the resulting size from the driver and adjust
accordingly.

Hence, either:

1.  the driver is saying "ok" to 768 and then tvtime receives green
video from the driver.
2.  the driver properly returns 720 when asked for 768, but tvtime
doesn't check for the adjusted size.

Scenario #1 is a driver bug, and scenario #2 is a tvtime bug.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
