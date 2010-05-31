Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23379 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745Ab0EaMnm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 08:43:42 -0400
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
From: Andy Walls <awalls@md.metrocast.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20100531091953.39055944@tele>
References: <201005291909.33593.linux@rainbow-software.org>
	 <201005302328.56690.linux@rainbow-software.org>
	 <1275256691.4863.19.camel@localhost>
	 <201005310003.12761.linux@rainbow-software.org>
	 <20100531091953.39055944@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 08:43:51 -0400
Message-ID: <1275309831.2227.26.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-05-31 at 09:19 +0200, Jean-Francois Moine wrote:
> On Mon, 31 May 2010 00:03:10 +0200
> Ondrej Zary <linux@rainbow-software.org> wrote:
> 
> > > I would try extracting a JPEG header from one of the files captured
> > > by the camera in stand alone mode (either a JPEG still or MJPEG
> > > file), and put that header together with the image data from the
> > > USB capture.  It may not look perfect, but hopefully you will get
> > > something you recognize.  
> > 
> > Just thought about the same thing so I uploaded a video file: 
> > http://www.rainbow-software.org/linux_files/spca1528/sunp0003.avi
> > 
> > > Attached was Theodore's first attempt of such a procedure with a
> > > header extracted from a standalone image file from my Jeilin based
> > > camera and USB snoop data from the same camera.  It wasn't perfect,
> > > but it was recognizable.  
> 
> I could not believe it! I already tried the image as JPEG, but I got
> just big colored pixels. I changed the 'samples Y' from 21 to 22 and
> I got something coherent! Here is the same image as yesterday with
> JPEG 411 header, compression quality 80% and insertion of 0x00 after
> 0xff.

Very nice work!

I think I understand the 'samples Y' change.  According to ITU T.81, you
changed the Vertical sampling factor in the Y component.  So, I guess
Luma is undersampled vertically for that mode of the camera (the camera
only really has a 240 line sensor)?

Regards,
Andy

