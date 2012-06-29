Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60058 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab2F2XCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 19:02:48 -0400
Subject: Re: AverTVHD Volar Max (h286DU)
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: aschuler@bright.net, linux-media@vger.kernel.org
Date: Fri, 29 Jun 2012 19:02:44 -0400
In-Reply-To: <CAGoCfiyB3AGix4s3db5iNkeHUaPd1p2UVQBPYwdmA9LKxhmqgg@mail.gmail.com>
References: <201206291649.000461@ms2.cniteam.com>
	 <CAGoCfiwqJ93O5iHW96tJHFZ7uNdvKAwk==3R2YGUnwy=i-rQPg@mail.gmail.com>
	 <201206291719.000478@ms2.cniteam.com>
	 <CAGoCfixAUwMjGm3nUZvkhj+cY0GraxR2sqq+TUu9m+DO4SoVjQ@mail.gmail.com>
	 <201206291757.000492@ms2.cniteam.com>
	 <CAGoCfiwby3tn5Zh1cyEbnW-Jag6SXbCKg89SMkxMyPKD29JEfg@mail.gmail.com>
	 <201206291910.000512@ms2.cniteam.com>
	 <CAGoCfiyB3AGix4s3db5iNkeHUaPd1p2UVQBPYwdmA9LKxhmqgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1341010965.2730.5.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-06-29 at 15:55 -0400, Devin Heitmueller wrote:
> On Fri, Jun 29, 2012 at 3:10 PM,  <aschuler@bright.net> wrote:

> > I've found that most, if not all, cable boxes do not pass
> > through CC data, because they are meant to interpret it and
> > pass it on with customized formatting and whatnot, so another
> > scaling challenge will be finding a feed that I can use
> > without a cable box. OTA broadcasts have been my testing
> > ground because they are so readily available.
> 
> Yeah, the fact that many cable boxes don't provide a way to expose CC
> data other than their inserting the decoded text into the video is
> pretty frustrating.  Bear in mind though that since you don't care
> about the video then as long as the cable box has standard definition
> outputs then it may very well include the CC data (HD component and
> HDMI don't have a way to send CC data, but the older standard def
> outputs still do).

And for the SD analog outputs (CVBS or S-Video) of such boxes you would
need an analog capture device in you Linux system.  There are at least a
few devices supported under linux that provide VBI data (e.g. CC) output
independent of the digitized video.

FWIW, I have noticed that ATSC OTA to analog NTSC converter boxes output
a very nicely formed CC signal in the VBI.  I have no experience with
cable boxes.

Regards,
Andy

