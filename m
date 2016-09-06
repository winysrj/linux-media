Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39049
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932970AbcIFJlQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:41:16 -0400
Date: Tue, 6 Sep 2016 06:41:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Chris Mayo <aklhfex@gmail.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
Message-ID: <20160906064108.5bd84045@vento.lan>
In-Reply-To: <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
        <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
        <20160824114927.3c6ab0d6@vento.lan>
        <20160824115241.7e2c90ca@vento.lan>
        <28A9DFEA-1E94-4EE0-A2BB-B22D029683B9@darmarit.de>
        <20160905102511.6de3dbe4@vento.lan>
        <eaa7b609-2c27-9943-5197-d9bec71b2db7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Sep 2016 20:01:22 +0100
Chris Mayo <aklhfex@gmail.com> escreveu:

> On 05/09/16 14:25, Mauro Carvalho Chehab wrote:
> > Em Mon, 5 Sep 2016 15:13:04 +0200
> > Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >   
> >> Hi Mauro, (Hi Chris)
> >>
> >> sorry for my late reply. I test the v4-utils on my HTPC,
> >> where I'am not often have time for experimentation ;-)
> >>
> >> Am 24.08.2016 um 16:52 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >>  
> >>> Em Wed, 24 Aug 2016 11:49:27 -0300
> >>> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> >>>     
> >>>> Hi Markus,
> >>>>
> >>>> Em Wed, 10 Aug 2016 11:52:19 +0200
> >>>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> >>>>     
> >>>>> From: Markus Heiser <markus.heiser@darmarIT.de>
> >>>>>
> >>>>> From: Heiser, Markus <markus.heiser@darmarIT.de>
> >>>>>
> >>>>> The vdr format was broken, I got '(null)' entries
> >>>>>
> >>>>> HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
> >>>>> 0-:1----:2--------------:3:4-----:
> >>>>>
> >>>>> refering to the VDR Wikis ...
> >>>>>
> >>>>> * LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
> >>>>> * german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4
> >>>>>
> >>>>> There is no field at position 4 / in between "Source" and "SRate" which
> >>>>> might have a value. I suppose the '(null):' is the result of pointing
> >>>>> to *nothing*.
> >>>>>
> >>>>> An other mistake is the ending colon (":") at the line. It is not
> >>>>> explicit specified but adding an collon to the end of an channel entry
> >>>>> will prevent players (like mpv or mplayer) from parsing the line (they
> >>>>> will ignore these lines).
> >>>>>
> >>>>> At least: generating a channel list with
> >>>>>
> >>>>>  dvbv5-scan --output-format=vdr ...
> >>>>>
> >>>>> will result in the same defective channel entry, containing "(null):"
> >>>>> and the leading collon ":".      
> >>>>
> >>>> Sorry for taking too long to handle that. I usually stop handling
> >>>> patches one week before the merge window, returning to merge only
> >>>> after -rc1. This time, it took a little more time, due to the Sphinx
> >>>> changes, as I was needing some patches to be merged upstream, in order
> >>>> to change my handling scripts to work with the new way.
> >>>>
> >>>> Anyway, with regards to this patch, not sure if you saw, but
> >>>> Chris Mayo sent us a different fix for it:
> >>>>
> >>>> 	https://patchwork.linuxtv.org/patch/35803/
> >>>>
> >>>> With is meant to support VDR format as used on version 2.2. Not sure
> >>>> if this format is backward-compatible with versions 1.x, but usually
> >>>> VDR just adds new parameters to the lines.
> >>>>
> >>>> So, I'm inclined to merge Chris patch instead of yours.
> >>>>
> >>>> So, could you please test if his patch does what's needed?    
> >>>
> >>> PS.: If the formats for v 1.x are not compatible with the ones for
> >>> v2.x, then the best would be to change the code to add a new format
> >>> for vdr v2.x, while keep supporting vdr v1.x.    
> >>
> >> Hmm, I'am a bit confused about vdr's channel.conf v1.x and v2.x.
> >>
> >> I can't find any documentation on this and since there is no
> >> version control system for vdr it is hard to dig the history.  
> > 
> > Yeah, I see your pain.
> >   
> >> As far as I can see, Chris fixes an issue with DVB-T and the
> >> issue with the leading ":".
> >>
> >> My patch fixes an issue with DVB-S/2 entry-location (and the
> >> issue with the leading ":").
> >>
> >> I will give it a try to merge my changes on top of Chris's
> >> patch and test DVB-T & DVB-S2 on my HTPC with an vdr server.  
> 
> Thanks. I can't test DVB-S(2) so I decided to leave that part alone.
> 
> > 
> > Ok, that would be great! it would also be good if either of you could
> > take a look on how to allow libdvbv5 to support both VDR versions 1.x and
> > 2.x. I don't use VDR here (afaikt, it doesn't support ISDB-T - and nowadays
> > I only have DVB/ATSC via my RF test generators), but, IMHO, being able to
> > provide output on both formats can be useful for other VDR users.
> >   
> 
> Is supporting vdr v1.x necessary?

That is a good question. I don't have a strong opinion here.

> 
> I believe v1.7.x were developer releases leading up to v2.0.
> Last stable v1.x was 2012-02-14: Version 1.6.0-3. With v1.6.0 being from 2008!

Hmm... 4 years ago... LTS distros usually lasts 5 years. So, it is possible
that someone might have a LTS version shipped with it. On the other hand,
it sounds unlikely that someone would be running vdr from LTS while using
the latest v4l-utils version (except if there are some VDR extensions people
would need that only runs on 1.x versions).

> Looks like v2.2.0 added parameters N, Q and X for S2 and T2. But libdvbv5 does
> not currently appear to output these (at least Q and X for T2).

I guess the latest version at the time I added support at libdvbv5 was v2.1.
According with the git logs, support was added in 2014 and aimed support
for version 2.1.6:

commit 67a718b3f1c8edb47f052cfa1e34c2234bb3dad5
Author: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date:   Sat Sep 13 12:25:36 2014 -0300

    Add support for VDR format (only for output)
    
    VDR has its own special format, that doesn't fit into the normal
    oneline parsers. So, it requires its own code to parse.
    
    Add support for it, as used on vdr 2.1.6.
    
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

My goal on that time were just to provide this extra output format in
order to provide an alternative for VDR users that were relying on
the old dvbscan tool (with used to provide VDR support for even older
versions). I remember I set a test bench on that time to be sure that
VDR were recognizing the output format and filling the blanks. I didn't 
bother to write a VDR input file format (with could be useful for file
format conversions).

I don't mind if someone would add support for those 3 newer parameters at
the library, provided that we keep it backward-compatible to what's there,
and even add support for those extra fields at the libdvbv5 format too.

I guess older VDR 2.x versions are capable of working with files with those
extra parameters, as it should silently ignore them. So, if we move to
version 2.2.x, we should not have backward compatible problems, I guess.

Regards,
Mauro
