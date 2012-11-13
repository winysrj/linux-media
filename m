Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54088 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab2KMTMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 14:12:03 -0500
Received: by mail-qa0-f46.google.com with SMTP id c11so1341544qad.19
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 11:12:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <k7u5id$si8$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org>
	<CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
	<k7tt38$aol$1@ger.gmane.org>
	<CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com>
	<k7u1vf$q5h$1@ger.gmane.org>
	<CAGoCfiwNxh6uNXaQLNO7r4e8PXZxQ0+jZGY0ZjzXdy2vbmG-NA@mail.gmail.com>
	<k7u5id$si8$1@ger.gmane.org>
Date: Tue, 13 Nov 2012 14:12:02 -0500
Message-ID: <CAGoCfizTJXViw4p3kMMg1jaHgSYWDcONC9QVYpkfZ7YDZ2zpuQ@mail.gmail.com>
Subject: Re: Color problem with MPX-885 card (cx23885)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 2:03 PM, Neuer User <auslands-kv@gmx.de> wrote:
> Thanks, you probably hinted me into the right direction. I use mplayer
> to play the video stream and mplayer does indeed recognize a 640x480
> video stream.
>
> I am not using any crop settings for these tests. But maybe it is
> possible to tell mplayer that the stream is 720x576 instead of the
> 640x480 it believes. That is, if the stream coming from the driver is
> really not 640x480.

Just to be clear, I wasn't intending to suggest that you were using
any of the actual V4L2 cropping features.  I'm just saying that if the
video scaler were broken, it's possible that the frames are
*effectively* being cropped at 640x480.

But yeah, you should definitely try capturing at 720x576 in mplayer.
You can specific command line arguments to mplayer to set the width
and height.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
