Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47820 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559AbZDBX2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 19:28:25 -0400
Received: by ey-out-2122.google.com with SMTP id 4so204243eyf.37
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 16:28:22 -0700 (PDT)
Date: Thu, 02 Apr 2009 19:28:15 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : Re : epg data grabber
To: linux-media@vger.kernel.org
References: <49D53B8A.7020900@koala.ie> <1238713191.7516.2@manu-laptop>
	<49D544DD.1060001@koala.ie>
In-Reply-To: <49D544DD.1060001@koala.ie> (from simon@koala.ie on Thu Apr  2
	19:06:05 2009)
Message-Id: <1238714895.7516.3@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 02.04.2009 19:06:05, Simon Kenyon a écrit :
> Manu wrote:
> > Le 02.04.2009 18:26:18, Simon Kenyon a écrit :
> >   
> >> i've been hacking together a epg data grabber
> >> taking pieces from here, there and everywhere
> >>
> >> the basic idea is to grab data off-air and generate xmltv format
> xml
> >> files
> >>
> >> the plan is to support DVB, Freesat, Sky (UK and IT) and 
> >> MediaHighway1
> >> and 2
> >> i have the first two working and am working on the rest
> >>
> >> is this of interest to the linuxtv.org community
> >> i asked the xmltv people, but they are strictly perl. i do 
> >> understand.
> >>
> >> very little of this is original work of mine. just some applied 
> >> google
> >>
> >> and a smidgen of C
> >>
> >> i could put it up on sf.net if there is no room on linutv.org
> >>
> >> if anyone wants the work in progress, then please let me know
> >> it is big released under GPL 3
> >>
> >> i want to get it out there because i'm pretty soon going to be at
> the 
> >> end of my knowledge and would appreciate help
> >>
> >>     
> >
> > Hi Simon,
> > I have hacked something for what is supposedly mediaHighway epg (it
> is 
> > used on CanalSat Caraibes which is affiliated to Canal Satellite
> from 
> > France). I actually have a patch against mythtv (it uses the 
> scanner
> to 
> > get the epg directly).
> > I can provide my patches if needed (will need some time to sort
> things 
> > out abit, especially if you want a stand alone version).
> > Bye
> > Manu
> >   
> i am doing it "stand alone" so i can see what is going on
> i would propose to do  mythtv version but that is some way off
> 
> don't modify your stuff. i already extracted the freesat code from 
> the
> 
> mythtv code base
> that was a couple of hours work
> 

Hmm I might have a stadn alone version around, give me a few days and I 
can find that, life is busy right now ;-)
Bye
Manu

