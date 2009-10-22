Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32706.mail.mud.yahoo.com ([68.142.207.250]:24651 "HELO
	web32706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742AbZJVEDZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 00:03:25 -0400
Message-ID: <114221.71254.qm@web32706.mail.mud.yahoo.com>
Date: Wed, 21 Oct 2009 21:03:29 -0700 (PDT)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U help?
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <510991.99153.qm@web32703.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here are some more stuff in the trace that was not decoded by the parse_em28xx script..  

So what we know from this list of unknowns... 

0xa0 is the eeprom
0x4a is the SAA
0x42 ??. 
0xd0 ??
0x20 ?? 
0xc6 ??
0xc4 ??
0xc2 Thomson tuner.  

unknown: c0 02 00 00 42 00 01 00 <<< fd                                                 
unknown: c0 02 00 00 4a 00 01 00 <<< 11                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 2d                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 1c                                                 
unknown: c0 02 00 00 20 00 01 00 <<< fe                                                 
unknown: c0 02 00 00 d0 00 01 00 <<< 10                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 0a                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 5a                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 2e                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 00                                                 
unknown: 40 03 00 00 a0 00 01 00 >>> 0a                                                 
unknown: c0 02 00 00 a0 00 01 00 <<< 5a                                                 
unknown: c0 02 00 00 c6 00 01 00 <<< 00                                                 
unknown: c0 02 00 00 c4 00 01 00 <<< 10                                                 
unknown: c0 02 00 00 c2 00 01 00 <<< b4            

Anyone know what are at the other addresses?  I don't know if they are important or not.  

Thanks,
Franklin Meng

--- On Wed, 10/21/09, Franklin Meng <fmeng2002@yahoo.com> wrote:

> From: Franklin Meng <fmeng2002@yahoo.com>
> Subject: Re: Kworld 315U help?
> To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
> Cc: linux-media@vger.kernel.org
> Date: Wednesday, October 21, 2009, 8:06 AM
> Devin, 
> 
> Thanks for the info..  Should the parse_em28xx.pl
> script be updated to reflect this?  I'm assuming other
> em28xx boards also have the eeprom at address 0xa0.  
> 
> There are a couple more entries that I am unsure
> about..  I'll post those when I get home tonight. 
> 
> 
> Are you interested in looking at some traces?  I am
> pretty sure I have most of the analog and input stuff
> figured out though I probably don't have the GPIO sequence
> correct.  Anyways, if your interested I can send you
> what I know.  
> 
> Thanks
> Franklin Meng
> 
> --- On Wed, 10/21/09, Devin Heitmueller <dheitmueller@kernellabs.com>
> wrote:
> 
> > From: Devin Heitmueller <dheitmueller@kernellabs.com>
> > Subject: Re: Kworld 315U help?
> > To: "Franklin Meng" <fmeng2002@yahoo.com>
> > Cc: linux-media@vger.kernel.org
> > Date: Wednesday, October 21, 2009, 5:55 AM
> > On Wed, Oct 21, 2009 at 1:35 AM,
> > Franklin Meng <fmeng2002@yahoo.com>
> > wrote:
> > > I was wondering if someone would be able to help
> me
> > with getting the analog and inputs for the Kworld
> 315U
> > working.  I was able to get the digital part working
> with
> > help from Douglas Schilling and wanted to get the
> remaining
> > portions of the device working.
> > >
> > > I have traces but have not made much progress.
>  In
> > addition I also have some questions about the
> information
> > that the parse_em28xx.pl skips and does not decode.
> > >
> > > For example here is some of the data that doesn't
> seem
> > to be decoded..
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 08
> > > unknown: c0 02 00 00 a0 00 01 00 <<< d0
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 08
> > > unknown: c0 02 00 00 a0 00 01 00 <<< d0
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 22
> > > unknown: c0 02 00 00 a0 00 01 00 <<< 01
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 04
> > > unknown: c0 02 00 00 a0 00 02 00 <<< 1a
> eb
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 20
> > > unknown: c0 02 00 00 a0 00 01 00 <<< 46
> > > unknown: 40 03 00 00 a0 00 01 00 >>> 14
> > > unknown: c0 02 00 00 a0 00 04 00 <<< 4e
> 07 01
> > 00
> > >
> > > Anyways, any help that can be provided is
> > appreciated.
> > 
> > Those look like i2c commands to the onboard eeprom,
> which
> > is at i2c
> > address 0xa0.  For example:
> > 
> > unknown: 40 03 00 00 a0 00 01 00 >>> 04 
> >      // set eeprom read offset to 0x04
> > unknown: c0 02 00 00 a0 00 02 00 <<< 1a eb 
> > // read two bytes back from eeprom
> > 
> > Cheers,
> > 
> > Devin
> > 
> > -- 
> > Devin J. Heitmueller - Kernel Labs
> > http://www.kernellabs.com
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe
> > linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
