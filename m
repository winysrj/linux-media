Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58878 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750749Ab0EaH40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 03:56:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Date: Mon, 31 May 2010 09:56:16 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
References: <201005291909.33593.linux@rainbow-software.org> <201005310003.12761.linux@rainbow-software.org> <20100531091953.39055944@tele>
In-Reply-To: <20100531091953.39055944@tele>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005310956.16961.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 31 May 2010, Jean-Francois Moine wrote:
> On Mon, 31 May 2010 00:03:10 +0200
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
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

That's great - that's what it should look like! It's a part of LCD monitor and 
a shelf above it.

-- 
Ondrej Zary
