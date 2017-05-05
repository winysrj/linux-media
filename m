Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55050
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751441AbdEEAho (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 20:37:44 -0400
Date: Thu, 4 May 2017 21:37:37 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Reinhard Speyerer <rspmn@arcor.de>
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libdvbv5: T2 delivery descriptor: fix wrong size of
 bandwidth field
Message-ID: <20170504213737.5a91c5a0@vento.lan>
In-Reply-To: <20170504231429.GA1997@arcor.de>
References: <dc2b16b2-7caa-6141-a983-c83631544f3e@ladisch.de>
        <c6f1d1cd-69ea-d454-15a8-5de9325577de@googlemail.com>
        <20170503095303.71cf3a75@vento.lan>
        <20170503193318.07ddf143@vento.lan>
        <00937473-581c-ecf8-58c6-616a78aa37c5@googlemail.com>
        <20170504091147.3f3edc16@vento.lan>
        <20170504231429.GA1997@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 May 2017 01:14:29 +0200
Reinhard Speyerer <rspmn@arcor.de> escreveu:

> On Thu, May 04, 2017 at 09:11:47AM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 4 May 2017 09:55:04 +0200
> > Gregor Jasny <gjasny@googlemail.com> escreveu:
> >   
> > > Hello Mauro,
> > > 
> > > On 04.05.17 00:33, Mauro Carvalho Chehab wrote:  
> > > > Em Wed, 3 May 2017 09:53:03 -0300
> > > > Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:    
> > > >> Em Tue, 2 May 2017 22:30:29 +0200
> > > >> Gregor Jasny <gjasny@googlemail.com> escreveu:    
> > > >>> I just used your patch and another to hopefully fix
> > > >>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=859008
> > > >>>
> > > >>> But I'm a little bit hesitant to merge it to v4l-utils git without
> > > >>> Mauros acknowledgement.    
> > >   
> > > >> Patches look correct, but the T2 parser has a more serious issue that
> > > >> will require breaking ABI/API compatibility.    
> > >   
> > > > I'll cherry-pick the corresponding patches to the stable branch.    
> > > 
> > > Reinhard, could you please test the latest patches on
> > > https://git.linuxtv.org/v4l-utils.git/log/?h=stable-1.12
> > > 
> > > If they work for you, I'd release a new stable version and upload it to 
> > > Debian Sid afterwards.  
> > 
> > I found one additional bug there, at the code that handles subcells.
> > 
> > Fix applied. Reinhard/Clemens, if you find some channel that use
> > subcells on this descriptor and/or tfs_flag == 1, it would be really cool
> > if you could store ~60 seconds of the transponder and send it to me, as it
> > would allow me to have a testing stream. With that, I can input the stream
> > on my RF generator and test if this is parsed well with libdvbv5,
> > dvbv5-tools and Kaffeine.  
> 
> Hi Gregor and Mauro,
> 
> the created dvb_channel.conf files look good to me with both stable-1.12
> and master. Thanks!
> 
> I noticed that the dvb_channel.conf created by dvbv5-scan from the master
> branch already contains VIDE0_PID = ... while the one created by the
> stable-1.12 version still contains PID_24 = ... . Perhaps it might make
> sense to cherry-pick this for stable-1.12 if the changes are small.

Just cherry-picked. It is a small patch, but it is important in order
to handle HEVC channels.

> For some reason several/most(?) programs from freenet.TV (connect) which
> are distributed via the Internet instead of DVB-T2 have duplicate entries.

The dvb scan logic has some code to avoid parsing twice the
same transponder, but it doesn't have any logic to detect if
the same channel is announced multiple times. Perhaps this is
what's happening.

The best would be if you could record 60 seconds of the
transponder with the freenet (connect) channel. From the
dvb_channel.conf, it is located at frequency 578000000.
So, this should do the trick:

	$ dvbv5-zap -c dvb_channel.conf 'freenet. TV (connect )' -r -P -t60 -o freenet.ts
or
	$ dvbv5-zap -c de-scan_file 578000000 -r -P -t60 -o freenet.ts

(where de-scan_file is the name of the file you're using for 
dvbv5-scan)

Running dvbv5-scan with "-vv" could give some glue why it is
duplicating the channels, but if you send me the channel dump,
it would be easier for me to produce a patch and test it
locally.

> None of the channels available to me uses subcells or tfs_flag == 1.

Ok.


Thanks,
Mauro
