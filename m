Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.208]:27412 "HELO
	nm17-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754478Ab1HGSY3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Aug 2011 14:24:29 -0400
Message-ID: <1312741087.98815.YahooMailClassic@web130124.mail.mud.yahoo.com>
Date: Sun, 7 Aug 2011 11:18:07 -0700 (PDT)
From: Bob Carpenter <rgc3679@yahoo.com>
Subject: Re: Any advice for writing Ruby driver for Hauppauge WinTV-HVR-1150 on Linux?
To: Linux Media <linux-media@vger.kernel.org>
In-Reply-To: <CAGoCfiyKMQXAuGzQY-cr0fauLz7WFdW8TOGfn3qzcHuvXPMw3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the info. The V4L2 spec is helpful, and the terminology allowed me to do some accurate googling. In fact I found a Ruby extension (hornetseye) that uses the V4L2 driver - I can probably make some progress going down that path.

--Bob 

--- On Sat, 8/6/11, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> Subject: Re: Any advice for writing Ruby driver for Hauppauge WinTV-HVR-1150 on Linux?
> To: "Bob Carpenter" <rgc3679@yahoo.com>
> Cc: linux-media@vger.kernel.org
> Date: Saturday, August 6, 2011, 6:04 PM
> On Sat, Aug 6, 2011 at 8:48 PM, Bob
> Carpenter <rgc3679@yahoo.com>
> wrote:
> > I'd like to write a driver using Ruby language for a
> Hauppauge WinTV-HVR-1150 card.
> >
> > I will be attaching an NTSC analog camera to the
> composite video input and want to stream the video across
> the internet to a client app that can display it.
> >
> > I've never written a PCI driver.
> >
> > The 1150 card will be attached to an Ubuntu 10.04
> box.
> >
> > I'd welcome any ideas or advice to get started.
> >
> > Thanks,
> >
> > --Bob
> 
> Several points:
> 
> Under Linux, you don't write drivers in Ruby.  You
> write them in C.
> 
> The HVR-1150 already has a driver under Linux.
> 
> You probably want to be writing a Ruby application, not a
> driver.
> 
> You should probably start by reading the video4linux2 API
> documentation, which is the kernel API for interacting with
> tuner
> drivers.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> 
