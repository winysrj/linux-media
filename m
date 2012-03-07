Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34432 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2CGRZJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 12:25:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1S5Kbo-0003pc-CS
	for linux-media@vger.kernel.org; Wed, 07 Mar 2012 18:25:04 +0100
Received: from mail.sevis.com ([mail.sevis.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 18:25:04 +0100
Received: from bob.news by mail.sevis.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 18:25:04 +0100
To: linux-media@vger.kernel.org
From: Bob Winslow <bob.news@non-elite.com>
Subject: Re: DVB-S2 multistream support
Date: Wed, 7 Mar 2012 16:33:41 +0000 (UTC)
Message-ID: <loom.20120307T170824-19@post.gmane.org>
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org> <CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com> <85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at> <CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com> <CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at> <CAF0Ff2kF3VCL4PomOo5zBBrZSPmPvGd9qSZ+XwSp7ALJmq3+kw@mail.gmail.com> <78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at> <CAF0Ff2nCz114LEJFRXy+L7Yq-uD4+sJeHOzNSk=28V_qgbta7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> that's really great news! i'm looking forward to look at the code when
> the public repository is ready. i'm sure i'm not the only one and the
> news would be especially exciting for TBS 6925 owners, which use
> Linux, but it's away beyond that, because the real news here is
> working base-band support in 'dvb-core' of V4L. also, it's really good
> that SAA716x code seems to just work with BBFrames and no further
> changes are required there.
> 

Hi Christian, Konstantin,


  Well, my TBS 6925 just came in the mail yesterday and I am excited to plug it
in and start playing with it.  Your work on the bb-demux looks like a good place
to start playing with the card under linux.

 Have you setup a public repo yet for the band band support (bb-demux) ?

Also, I downloaded the linux drivers for the card from the TBS dtv site, and put
them on my ubuntu 11.10 pc.  They seem to work.   Is this the best place to get
drivers for the card??  the front end driver files seem to be just .o's and the
source is not in the tarball.  

Sorry, I'm a bit new to the dvb world and I am still learning where to find
stuff.  Any pointers/help to finding the latest code/drivers would be very much
appreciated.


Kind regards, 

  Bob





