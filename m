Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:55721 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbZAPBUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 20:20:54 -0500
Received: by ewy10 with SMTP id 10so1661428ewy.13
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2009 17:20:52 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH 1/2] Add Mars-Semi MR97310A format
Date: Thu, 15 Jan 2009 19:20:48 -0600
Cc: linux-media@vger.kernel.org
References: <200901142059.34943.elyk03@gmail.com> <20090115124946.52779651@free.fr>
In-Reply-To: <20090115124946.52779651@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151920.48666.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 January 2009 05:49:46 Jean-Francois Moine wrote:
> On Wed, 14 Jan 2009 20:59:34 -0600
> Kyle Guinn <elyk03@gmail.com> wrote:
> > Add a pixel format for the Mars-Semi MR97310A webcam controller.
> >
> > The MR97310A is a dual-mode webcam controller that provides
> > compressed BGGR Bayer frames.  The decompression algorithm for still
> > images is the same as for video, and is currently implemented in
> > libgphoto2.
>
> Hi Kyle,
>
> What is the difference of this pixel format from the other Bayer ones?
>

This is a standard BGGR Bayer format which is compressed using a 
vendor-specific compression algorithm, much like V4L2_PIX_FMT_PAC207.  I 
don't believe the compression algorithm matches any of the other pixel 
formats.

The first two pixels in the first two rows are stored as raw 8-bit values (the 
top-left BGGR square), but the rest is Huffman compressed.  Take a look at 
precalc_table() and mars_decompress() in libgphoto2/camlibs/mars/mars.c for 
all of the details.  If you recognize this as an existing pixel format, 
please let me know.

> Also, did you ask Hans de Goede to add the decoding to the v4l library?
>

That is next on my TODO list.  I have a patch ready to send, but I first want 
to make sure there are no problems with adding this pixel format.

Regards,
-Kyle
