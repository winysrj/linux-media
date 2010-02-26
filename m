Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63263 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208Ab0BZRHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 12:07:51 -0500
Received: by fxm19 with SMTP id 19so307868fxm.21
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 09:07:49 -0800 (PST)
Subject: Re: How to add DVB-S2 support to firedtv?
From: Beat Michel Liechti <bml303@gmail.com>
To: Henrik Kurelid <henke@kurelid.se>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>,
	Ben Backx <ben@bbackx.com>
In-Reply-To: <b13e649a0061e6efbfc91c6a8c7b57f4.squirrel@mail.kurelid.se>
References: <4B782CCA.3010903@s5r6.in-berlin.de>
	 <b13e649a0061e6efbfc91c6a8c7b57f4.squirrel@mail.kurelid.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Feb 2010 18:07:40 +0100
Message-ID: <1267204060.3060.5.camel@darkscan11>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there

I own a FireDTV S2 and I'm willing to invest some time. I poked around
in the driver code previously and I might do some coding given that I
have access to the required technical information. 

As far as I know Digital Everywhere is out of business - does this mean
that the NDAs are no longer in effect and that someone could give me the
technical documentation required? 

Cheerio

Beat


On Thu, 2010-02-18 at 11:04 +0100, Henrik Kurelid wrote:
> Hi,
> 
> Regarding the documentation and code:
> From a quick glance, the LNB/QPSK2 code follows the documentation fairly good.
> I guess it could do with a deeper check (I could see that at least the FEC switch case does seems to have some invalid values) but I would prefer
> that this is done by someone that actually has a DVB-S(2) card.
> 
> Regards,
> Henrik
> 
> > Hi all,
> >
> > what steps need to be taken to get DVB-S2 support into the firedtv
> > driver?  (The status is, as far as I understood:  FireDTV S2 and Floppy
> > DTV S2 devices recognize HD channels during channel scan but cannot tune
> > to them.  FireDTV C/CI DVB-C boxes however tune and play back HD
> > channels just fine.)
> >
> > I suppose the frontend needs to be extended for s2api.  Was there a
> > respective conversion in another DVB driver that can serve as a good
> > coding example?
> >
> > Is documentation from Digital Everywhere required regarding the
> > vendor-specific AV/C requests (LNB_CONTROL? TUNE_QPSK2?) or is the
> > current driver code enough to connect the dots?
> >
> > Is the transport stream different from DVB-C HD streams so that changes
> > to the isochronous I/O part would be required?
> > --
> > Stefan Richter
> > -=====-==-=- --=- -===-
> > http://arcgraph.de/sr/
> >
> 


