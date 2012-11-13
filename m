Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36741 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab2KMTDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 14:03:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TYLmD-0004Lj-Bo
	for linux-media@vger.kernel.org; Tue, 13 Nov 2012 20:04:01 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 20:04:01 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 20:04:01 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Color problem with MPX-885 card (cx23885)
Date: Tue, 13 Nov 2012 20:03:43 +0100
Message-ID: <k7u5id$si8$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org> <CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com> <k7tt38$aol$1@ger.gmane.org> <CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com> <k7u1vf$q5h$1@ger.gmane.org> <CAGoCfiwNxh6uNXaQLNO7r4e8PXZxQ0+jZGY0ZjzXdy2vbmG-NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGoCfiwNxh6uNXaQLNO7r4e8PXZxQ0+jZGY0ZjzXdy2vbmG-NA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.11.2012 19:54, schrieb Devin Heitmueller:
> Almost certainly just changes needed for the cx25840 driver.  These
> are all basic issues with the video decoder core.  Google around - the
> cx25840 datasheet is readily available.  You have to watch out though
> because there are some subtle differences that you won't be able to
> detect if it's a cx23887 or cx23888 as opposed to the cx23885.

Well, I will try to have a look at the sources, but probably, I won't be
able to patch it correctly, if the changes necessara are more than
absolutely basic and obvious...

I once compiled the tw68 driver for another card. And here the borders
were also not correct. In this driver it was very easy to find the
settings to change.
> 
> Regarding the cropped image, what capture resolution are you using?
> Perhaps the scaler isn't working and you're setting the capture to
> something like "640x480" (which would effectively crop out lines
> 640-720 on the horizontal and lines 480-576 on the vertical).
> 
> Devin
> 

Thanks, you probably hinted me into the right direction. I use mplayer
to play the video stream and mplayer does indeed recognize a 640x480
video stream.

I am not using any crop settings for these tests. But maybe it is
possible to tell mplayer that the stream is 720x576 instead of the
640x480 it believes. That is, if the stream coming from the driver is
really not 640x480.

