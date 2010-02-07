Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62374 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0BGUyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 15:54:06 -0500
Subject: Re: ivtv-utils/test/ps-analyzer.cpp: error in extracting SCR?
From: Andy Walls <awalls@radix.net>
To: Lars Hanisch <dvb@cinnamon-sage.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <4B6F2455.4040001@cinnamon-sage.de>
References: <4B6A123F.5080500@cinnamon-sage.de>
	 <1265253363.3122.106.camel@palomino.walls.org>
	 <201002040825.32062.hverkuil@xs4all.nl> <4B6F2455.4040001@cinnamon-sage.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Feb 2010 15:53:32 -0500
Message-Id: <1265576012.1707.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-02-07 at 21:36 +0100, Lars Hanisch wrote:
> Hi,
> 
>   Just for completeness, attached is the patch against the subversion 
> repository at ivtvdriver.org.

Thanks!

Regards,
Andy

> Regards,
> Lars.
> 
> Am 04.02.2010 08:25, schrieb Hans Verkuil:
> > On Thursday 04 February 2010 04:16:03 Andy Walls wrote:
> >> On Thu, 2010-02-04 at 01:18 +0100, Lars Hanisch wrote:
> >>> Hi,
> >>>
> >>>    I'm writing some code repacking the program stream that ivtv delivers
> >>> into a transport stream (BTW: is there existing code for this?).
> >>
> >> Buy a CX23418 based board.  That chip's firmware can produce a TS.
> >>
> >> I think Compro and LeadTek cards are available in Europe and are
> >> supported by the cx18 driver.
> >>
> >>>   Since
> >>> many players needs the PCR I would like to use the SCR of the PS and
> >>> place it in the adaption field of the TS (if wikipedia [1] and my
> >>> interpretation of it is correct it should be the same).
> >>>
> >>>    I stumbled upon the ps-analyzer.cpp in the test-directory of the
> >>> ivtv-utils (1.4.0). From line 190 to 198 the SCR and SCR extension are
> >>> extracted from the PS-header. But referring to [2] the SCR extension has
> >>> 9 bits, the highest 2 bits in the fifth byte after the sync bytes and
> >>> the lower 7 bits in the sixth byte. The last bit is a marker bit (always 1).
> >>>
> >>>    So instead of
> >>>
> >>> scr_ext = (hdr[4]&  0x1)<<  8;
> >>> scr_ext |= hdr[5];
> >>>
> >>>    I think it should be
> >>>
> >>> scr_ext = (unsigned)(hdr[4]&  0x3)<<  7;
> >>> scr_ext |= (hdr[5]&  0xfe)>>  1;
> >>
> >>
> >> Given the non-authoritative MPEG-2 documents I have, yes, you appear to
> >> be correct on this.
> >>
> >> Please keep in mind that ps-analyzer.cpp is simply a debug tool from an
> >> ivtv developer perspective.  You base prodcution software off of it at
> >> your own risk. :)
> >>
> >>>    And the bitrate is coded in the next 22 bits, so it should be
> >>>
> >>> mux_rate = (unsigned)(hdr[6])<<  14;
> >>> mux_rate |= (unsigned)(hdr[7])<<  6;
> >>> mux_rate |= (unsigned)(hdr[8]&  0xfc)>>  2;
> >>>
> >>>    Am I correct?
> >
> > Yes, you are correct. I miscounted the bits when I wrote this originally.
> > Thanks for reporting this!
> >
> > Regards,
> >
> > 	Hans
> >
> >>
> >> I did not check this one, but I would not be surprised if ps-analyzer
> >> had this wrong too.
> >>
> >> Regards,
> >> Andy
> >>
> >>> Regards,
> >>> Lars.
> >>>
> >>> [1] http://en.wikipedia.org/wiki/Presentation_time_stamp
> >>> [2] http://en.wikipedia.org/wiki/MPEG_program_stream
> >>> --
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> >
> 


