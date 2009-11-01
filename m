Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55669 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbZKAAf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 20:35:56 -0400
Subject: Re: cx18: YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
In-Reply-To: <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 31 Oct 2009 20:38:30 -0400
Message-Id: <1257035911.3181.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-10-31 at 16:28 -0400, Devin Heitmueller wrote:
> On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:
> > All,
> >
> > At
> >
> > http://linuxtv.org/hg/~awalls/cx18-yuv
> >
> > I have checked in some improvements to YUV handling in the cx18
> > driver.

> > Andy
> 
> Hi Andy,
> 
> How does this code work if the cx23418 scaler is used (resulting in
> the size of the frames to be non-constant)?  Or is the scaler not
> currently supported in the driver?


It is designed to fit as many integral frames as possible into the YUV
buffers.  It should work with the scaler.  I have not tested it though.
I also have note tested scaling to much aside from down to 480x480 with
MPEG as this is the MythTV default.

Please note that with the HM12 macroblock format, the height must be a
multiple of 32 lines (IIRC) so you'll have full blocks to decode.  See
the README.hm12 under Documentation somewhere.

Regards,
Andy

> Devin


