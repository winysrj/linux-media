Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54260
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751030AbdIWTZ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:25:58 -0400
Date: Sat, 23 Sep 2017 16:25:50 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.15] Cleanup fixes
Message-ID: <20170923162550.503c9cf2@vento.lan>
In-Reply-To: <b33aac55-6749-3dc9-1258-c6518b05a94e@users.sourceforge.net>
References: <7f18a823-3827-5a9c-053d-61f113a2d36f@xs4all.nl>
        <20170923093802.34b31c98@vento.lan>
        <b33aac55-6749-3dc9-1258-c6518b05a94e@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 Sep 2017 16:43:53 +0200
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> >> coccinelle, checkpatch, coverity, etc.  
> …
> > It **really** doesn't makes any sense to send patch bombs like that!  
> 
> I got an other impression for this software development aspect.
> 
> 
> > That pisses me off, as it requires a considerable amount of time from
> > my side that could be used handling important stuff...  
> 
> I can partly understand this view.
> 
> 
> > You're even doing the same logical change on the same driver several times,
> > like this one:
> > 	atmel-isc: Delete an error message for a failed memory allocation in isc_formats_init()
> > 	atmel-isi: Delete an error message for a failed memory allocation in two functions  
> 
> Such a change approach can occasionally occur because of my selection
> for a specific patch granularity.

Then change patch granularity: one patch per subsystem or per
directory (e. g. pci, usb, platform, others).

> 
> > Instead, group patches that do the same thing per subsystem.  
> 
> I was also uncertain about the acceptance for the suggested
> change patterns.

That's the usual criteria most maintainers use for cleanups.

> Do you want a “development pause” from my queue of change possibilities?

Those patches are mainly source code "polishing". I really don't
want to take much time handling such kind of patches, as they
usually doesn't fix any real bug, nor add functionality.

So, if you really want to contribute, the best is to buy yourself
some media devices, test them and send patches fixing real bugs
and improving the functionality of them.

Regards,
Mauro
