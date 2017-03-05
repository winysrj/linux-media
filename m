Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57062
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752296AbdCEByW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 20:54:22 -0500
Date: Sat, 4 Mar 2017 22:54:15 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: bill murphy <gc2majortom@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kaffeine commit b510bff2 won't compile
Message-ID: <20170304225415.62a80aac@vento.lan>
In-Reply-To: <1c5c2aed-f7c6-a189-6dc5-fd44007eefaa@gmail.com>
References: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
        <20170227071122.3a319481@vento.lan>
        <a2c23f62-215a-9066-45bc-0b8eebacc84b@gmail.com>
        <20170301070024.3ca3150a@vento.lan>
        <fdc10667-1ed9-7c84-bf7d-ec3a255c59b2@gmail.com>
        <20170304110743.7635879c@vento.lan>
        <1c5c2aed-f7c6-a189-6dc5-fd44007eefaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 4 Mar 2017 13:57:28 -0500
bill murphy <gc2majortom@gmail.com> escreveu:

> That sounds good, would you like me to submit a good Frequency List to 'dtv-scan-tables'?

Yes, please.

> Maybe name it something like 'atsc/us-ATSC-center-frequencies-8VSB-06-2009', reflecting the
> date since the spectrum was allocated that way?

Yeah, that would work.

> Another Kaffeine related issue, I noticed in libdbv5 of v4l-utils, that there is no
> "North American Standard" LNB configuration. I just modified the source to add
> add one and recompiled. Since in North America, the FSS Band is from 11700 to 12200, and our LNBs are
> designed with an LO Frequency of 10750 MHz. Kaffeine seems to work correctly now on my
> Ku Band antennas. Would you like me to submit the patch, or just create a new bug report?

Better to submit a patch. You should notice, however, that it may have
more than one LNBf type in US. So, you need to take some care when
assigning a name for the LNBf.

> 
> Thanks again,
> Bill
> 
> 
> On 03/04/2017 09:07 AM, Mauro Carvalho Chehab wrote:
> > Em Sat, 4 Mar 2017 08:21:51 -0500
> > bill murphy <gc2majortom@gmail.com> escreveu:
> >  
> >> Hi Mauro,
> >>
> >> yes I can appreciate that, but why not just make one file for each
> >> country that actually differs,
> >>
> >> rather than make the rest of us suffer?
> >>
> >> canada and the us are the same.
> >>
> >> atsc/us-ATSC-center-frequencies-8VSB
> >>
> >> So could add two files for mexico and korea.
> >>
> >> atsc/mx-ATSC-center-frequencies-8VSB
> >> atsc/kr-ATSC-center-frequencies-8VSB
> >>
> >> can't be any worse that the hundreds of files being maintained for DVB-T
> >> in various countries.  
> > That could be done, but newer updates to dtv-scan-tables
> > (and projects that use it, like Kaffeine) would have regressions for
> > people outside US that use it.
> >
> > What could be done, instead, would be to have another file for
> > US new frequency set.
> >  
> >>
> >> On 03/01/2017 05:00 AM, Mauro Carvalho Chehab wrote:  
> >>> Hi Bill,
> >>>
> >>> Em Mon, 27 Feb 2017 23:46:09 -0500
> >>> bill murphy <gc2majortom@gmail.com> escreveu:
> >>>     
> >>>> Hi Mauro,
> >>>>
> >>>> Thanks for looking in to it. All is well now.  
> >>> Good! Thanks for testing.
> >>>     
> >>>> On a sidenote, given 700 MHz is used for LTE, and not broadcasting
> >>>>
> >>>> anymore, would you folks consider removing ch 52 thru 69
> >>>>
> >>>> in the us-atsc-frequencies if I posted a simple patch to dtv-scan-tables?  
> >>> The problem is that, despite its name, this table is used on other
> >>> Countries using atsc (like Mexico, Canada and South Korea):
> >>>
> >>> 	https://en.wikipedia.org/wiki/List_of_digital_television_deployments_by_country#/media/File:Digital_broadcast_standards.svg
> >>>
> >>> So, while the 700 MHz are still used on other ATSC Countries, we can't
> >>> remove, as otherwise, it will not discover the channels at the upper
> >>> frequency range there.
> >>>
> >>> Regards,
> >>> Mauro  
> >
> >
> > Thanks,
> > Mauro  
> 



Thanks,
Mauro
