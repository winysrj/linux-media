Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61682 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZCEMAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 07:00:00 -0500
Received: by fxm24 with SMTP id 24so3311851fxm.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 03:59:56 -0800 (PST)
Date: Thu, 5 Mar 2009 21:01:10 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	"hermann pitton" <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090305210110.6c5f88e2@glory.loctelecom.ru>
In-Reply-To: <200903041845.45469.hverkuil@xs4all.nl>
References: <28050.62.70.2.252.1236161035.squirrel@webmail.xs4all.nl>
	<20090304210246.75a5b602@glory.loctelecom.ru>
	<200903041845.45469.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans 

I build fresh video4linux with your patch and my config for our cards.
In a dmesg i see : found RDS decoder.
cat /dev/radio0 give me some slow junk data. Is this RDS data??
Have you any tools for testing RDS?
I try build rdsd from Hans J. Koch, but build crashed with:

rdshandler.cpp: In member function ‘void std::RDShandler::delete_client(std::RDSclient*)’:
rdshandler.cpp:363: error: no matching function for call to ‘find(__gnu_cxx::__normal_iterator<std::RDSclient**, std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >, __gnu_cxx::__normal_iterator<std::RDSclient**, std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >, std::RDSclient*&)’

P.S. Debian Lenny.

With my best regards, Dmitry.

> On Wednesday 04 March 2009 13:02:46 Dmitri Belimov wrote:
> > > Dmitri,
> > >
> > > I have a patch pending to fix this for the saa7134 driver. The i2c
> > > problems are resolved, so this shouldn't be a problem anymore.
> >
> > Good news!
> >
> > > The one thing that is holding this back is that I first want to
> > > finalize the RFC regarding the RDS support. I posted an RFC a few
> > > weeks ago, but I need to make a second version and for that I
> > > need to do a bit of research into the US version of RDS. And I
> > > haven't found the time to do that yet.
> >
> > Yes, I found your discussion in linux-media mailing list. If you
> > need any information from chip vendor I'll try find. I can get it
> > under NDA and help you.
> >
> > > I'll see if I can get the patch merged anyway.
> 
> I've attached my patch for the saa7134. I want to wait with the final
> pull request until I've finished the RDS RFC, but this gives you
> something to play with.
> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
