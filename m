Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49491 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2KMSyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 13:54:52 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so4633104qcr.19
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 10:54:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <k7u1vf$q5h$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org>
	<CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
	<k7tt38$aol$1@ger.gmane.org>
	<CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com>
	<k7u1vf$q5h$1@ger.gmane.org>
Date: Tue, 13 Nov 2012 13:54:51 -0500
Message-ID: <CAGoCfiwNxh6uNXaQLNO7r4e8PXZxQ0+jZGY0ZjzXdy2vbmG-NA@mail.gmail.com>
Subject: Re: Color problem with MPX-885 card (cx23885)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 1:02 PM, Neuer User <auslands-kv@gmx.de> wrote:
> The HSYNC problem is bigger than I thought. I compared the captured
> image with an image from another (USB) video digitizer and it is obvious
> that the image has lost about 10-20% on the right side and on the bottom.
>
> Can probably be easily fixed. But it is no commercial project, so I need
> to do it myself, I guess. I hope there are some settings in the driver.
> Any idea where I need to look? (Is it the cx23885 driver at all or even
> the cx25840?)

Almost certainly just changes needed for the cx25840 driver.  These
are all basic issues with the video decoder core.  Google around - the
cx25840 datasheet is readily available.  You have to watch out though
because there are some subtle differences that you won't be able to
detect if it's a cx23887 or cx23888 as opposed to the cx23885.

Regarding the cropped image, what capture resolution are you using?
Perhaps the scaler isn't working and you're setting the capture to
something like "640x480" (which would effectively crop out lines
640-720 on the horizontal and lines 480-576 on the vertical).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
