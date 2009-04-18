Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:9852 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZDRAEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 20:04:07 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1113406wff.4
        for <linux-media@vger.kernel.org>; Fri, 17 Apr 2009 17:04:07 -0700 (PDT)
From: Kyle Guinn <elyk03@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Fri, 17 Apr 2009 19:04:02 -0500
Cc: Thomas Kaiser <v4l@kaiser-linux.li>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <200904162333.49502.elyk03@gmail.com> <alpine.LNX.2.00.0904171225120.11123@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0904171225120.11123@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904171904.02986.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 17 April 2009 12:50:51 Theodore Kilgore wrote:
> On Thu, 16 Apr 2009, Kyle Guinn wrote:
> > On Thursday 16 April 2009 13:22:11 Theodore Kilgore wrote:
> >> On Thu, 16 Apr 2009, Kyle Guinn wrote:
> >>> I've been looking through the frame headers sent by the MR97310A (the
> >>> Aiptek PenCam VGA+, 08ca:0111).  Here are my observations.
> >>>
> >>> FF FF 00 FF 96 6x x0 xx xx xx xx xx
> >>>
> >>> In binary that looks something like this:
> >>>
> >>> 11111111 11111111 00000000 11111111
> >>> 10010110 011001aa a1010000 bbbbbbbb
> >>> bbbbbbbb cccccccc ccccdddd dddddddd
> >>>
> >>> All of the values look to be MSbit first.  A looks like a 3-bit frame
> >>> sequence number that seems to start with 1 and increments for each
> >>> frame.
> >>
> >> Hmmm. This I never noticed. What you are saying is that the two bytes 6x
> >> and x0 are variable? You are sure about that? What I have previously
> >> experienced is that the first is always 64 with these cameras, and the
> >> second one indicates the absence of compression (in which case it is 0,
> >> which of course only arises for still cameras), or if there is data
> >> compression then it is not zero. I have never seen this byte to change
> >> during a session with a camera. Here is a little table of what I have
> >> previously witnessed, and perhaps you can suggest what to do in order to
> >> see this is not happening:
> >>
> >> Camera		that byte	compression	solved, or not	streaming
> >> Aiptek 		00		no		N/A		no
> >> Aiptek		50		yes		yes		both
> >> the Sakar cam	00		no		N/A		no
> >> ditto		50		yes		yes		both
> >> Argus QuikClix	20		yes		no	doesn't work
> >> Argus DC1620	50		yes		yes	doesn't work
> >> CIF cameras	00		no		N/A		no
> >> ditto		50		yes		yes		no
> >> ditto		d0		yes		no		yes
> >>
> >> Other strange facts are
> >>
> >> -- that the Sakar camera, the Argus QuikClix, and the
> >> DC1620 all share the same USB ID of 0x93a:0x010f and yet only one of
> >> them will stream with the existing driver. The other two go through the
> >> motions, but the isoc packets do not actually get sent, so there is no
> >> image coming out. I do not understand the reason for this; I have been
> >> trying to figure it out and it is rather weird. I should add that, yes,
> >> those two cameras were said to be capable of streaming when I bought
> >> them. Could it be a problem of age? I don't expect that, but maybe.
> >>
> >> -- the CIF cameras all share the USB id of 0x93a:0x010e (I bought
> >> several of them) and they all are using a different compression
> >> algorithm while streaming from what they use if running as still cameras
> >> in compressed mode. This leads to the question whether it is possible to
> >> set the compression algorithm during the initialization sequence, so
> >> that the camera also uses the "0x50" mode while streaming, because we
> >> already know how to use that mode.
> >>
> >> But I have never seen the 0x64 0xX0 bytes used to count the frames.
> >> Could you tell me how to repeat that? It certainly would knock down the
> >> validity of the above table wouldn't it?
> >
> > I've modified libv4l to print out the 12-byte header before it skips over
> > it.
>
> Good idea, and an obvious one. Why did I not think of that?
>
> > Then when I fire up mplayer it prints out each header as each frame is
> > received.  The framerate is only about 5 fps so there isn't a ton of data
> > to parse through.  When I point the camera into a light I get this (at
> > 640x480):
> >
> > ...
> > ff ff 00 ff 96 64 d0 c1 5c c6 00 00
> > ff ff 00 ff 96 65 50 c1 5c c6 00 00
> > ff ff 00 ff 96 65 d0 c1 5c c6 00 00
> > ff ff 00 ff 96 66 50 c1 5c c6 00 00
> > ff ff 00 ff 96 66 d0 c1 5c c6 00 00
> > ff ff 00 ff 96 67 50 c1 5c c6 00 00
> > ff ff 00 ff 96 67 d0 c1 5c c6 00 00
> > ff ff 00 ff 96 64 50 c1 5c c6 00 00
> > ff ff 00 ff 96 64 d0 c1 5c c6 00 00
> > ff ff 00 ff 96 65 50 c1 5c c6 00 00
> > ...
>
> Which camera is this? Is it the Aiptek Pencam VGA+? If so, then I can try
> it, too, because I also have one of them.
>

Yes, that's the one.  Try your others if you can and let me know what happens.

> > Only those 3 bits change, and it looks like a counter to me.  Take a look
> > at the gspca-mars (MR97113A?) subdriver.  I think it tries to accommodate
> > the frame sequence number when looking for the SOF.
>
> No, I don't see that, sorry. What I see is that it looks for the SOF,
> which is declared in pac_common.h to be the well-known FF FF 00 FF 96 and
> no more bytes after that.
>

I'm talking about this code from gspca/mars.c.  Look in sd_pkt_scan().

if (data[0 + p] == 0xff
 && data[1 + p] == 0xff
 && data[2 + p] == 0x00
 && data[3 + p] == 0xff
 && data[4 + p] == 0x96) {
	if (data[5 + p] == 0x64
	 || data[5 + p] == 0x65
	 || data[5 + p] == 0x66
	 || data[5 + p] == 0x67) {

-Kyle
