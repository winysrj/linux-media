Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:52030 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753886Ab0KIJMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 04:12:48 -0500
Date: Tue, 9 Nov 2010 10:10:24 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michael PARKER <michael.parker@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Format of /dev/video0 data for HVR-4000 frame grabber
Message-ID: <20101109091024.GA15043@minime.bse>
References: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB088@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB088@SAFEX1MAIL1.st.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 09, 2010 at 09:43:29AM +0100, Michael PARKER wrote:
> I'm attempting to capture a single frame from the /dev/video0 output of
> my HVR-4000 card's analogue tuner as a JPEG.
> 
> Whilst several resources exist for capturing the output of a card with
> h/w MPEG compression, I'm unable to determine the format of the
> /dev/video0 data for a frame grabber such as the HVR-4000.

According to the sourcecode the cx88 chip can do 8 bit grayscale,
15/16/24/32 bit RGB/BGR, and two variants of 4:2:2 YCbCr.
 
> Can anyone suggest a means by which I can capture a single frame from a
> frame grabber card? Can I just use "dd if=/dev/video0 of=image.jpg bs=64K"
> or similar or do I have to access the card via the V4L2 drivers?

Yes, dd should work but you need to use a blocksize that can hold a
complete frame and count=1 if you want a single frame. JPEG, as
mentioned above, is not possible with this board.

The resolution and data format can be selected with V4L2 ioctls.

  Daniel
