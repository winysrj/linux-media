Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1461 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0BDHXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 02:23:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: ivtv-utils/test/ps-analyzer.cpp: error in extracting SCR?
Date: Thu, 4 Feb 2010 08:25:32 +0100
Cc: Lars Hanisch <dvb@cinnamon-sage.de>, linux-media@vger.kernel.org
References: <4B6A123F.5080500@cinnamon-sage.de> <1265253363.3122.106.camel@palomino.walls.org>
In-Reply-To: <1265253363.3122.106.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002040825.32062.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 04 February 2010 04:16:03 Andy Walls wrote:
> On Thu, 2010-02-04 at 01:18 +0100, Lars Hanisch wrote:
> > Hi,
> > 
> >   I'm writing some code repacking the program stream that ivtv delivers 
> > into a transport stream (BTW: is there existing code for this?).
> 
> Buy a CX23418 based board.  That chip's firmware can produce a TS.
> 
> I think Compro and LeadTek cards are available in Europe and are
> supported by the cx18 driver.
> 
> >  Since 
> > many players needs the PCR I would like to use the SCR of the PS and 
> > place it in the adaption field of the TS (if wikipedia [1] and my 
> > interpretation of it is correct it should be the same).
> > 
> >   I stumbled upon the ps-analyzer.cpp in the test-directory of the 
> > ivtv-utils (1.4.0). From line 190 to 198 the SCR and SCR extension are 
> > extracted from the PS-header. But referring to [2] the SCR extension has 
> > 9 bits, the highest 2 bits in the fifth byte after the sync bytes and 
> > the lower 7 bits in the sixth byte. The last bit is a marker bit (always 1).
> > 
> >   So instead of
> > 
> > scr_ext = (hdr[4] & 0x1) << 8;
> > scr_ext |= hdr[5];
> > 
> >   I think it should be
> > 
> > scr_ext = (unsigned)(hdr[4] & 0x3) << 7;
> > scr_ext |= (hdr[5] & 0xfe) >> 1;
> 
> 
> Given the non-authoritative MPEG-2 documents I have, yes, you appear to
> be correct on this.
> 
> Please keep in mind that ps-analyzer.cpp is simply a debug tool from an
> ivtv developer perspective.  You base prodcution software off of it at
> your own risk. :)
> 
> >   And the bitrate is coded in the next 22 bits, so it should be
> > 
> > mux_rate = (unsigned)(hdr[6]) << 14;
> > mux_rate |= (unsigned)(hdr[7]) << 6;
> > mux_rate |= (unsigned)(hdr[8] & 0xfc) >> 2;
> > 
> >   Am I correct?

Yes, you are correct. I miscounted the bits when I wrote this originally.
Thanks for reporting this!

Regards,

	Hans

> 
> I did not check this one, but I would not be surprised if ps-analyzer
> had this wrong too.
> 
> Regards,
> Andy
> 
> > Regards,
> > Lars.
> > 
> > [1] http://en.wikipedia.org/wiki/Presentation_time_stamp
> > [2] http://en.wikipedia.org/wiki/MPEG_program_stream
> > --
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
