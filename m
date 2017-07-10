Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58772
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753061AbdGJMid (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 08:38:33 -0400
Date: Mon, 10 Jul 2017 09:38:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/2] app: kaffeine: Fix missing PCR on live streams.
Message-ID: <20170710093827.6397088f@vento.lan>
In-Reply-To: <179d3ac3-673f-7671-e2cc-6dd0262a14d3@gmail.com>
References: <20170709094351.14642-1-tvboxspy@gmail.com>
        <20170709081455.024e4c0d@vento.lan>
        <179d3ac3-673f-7671-e2cc-6dd0262a14d3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 9 Jul 2017 13:11:36 +0100
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On 09/07/17 12:14, Mauro Carvalho Chehab wrote:
> > Hi Malcolm,
> > 
> > Em Sun,  9 Jul 2017 10:43:50 +0100
> > Malcolm Priestley <tvboxspy@gmail.com> escreveu:
> >   
> >> The ISO/IEC standard 13818-1 or ITU-T Rec. H.222.0 standard allow transport
> >> vendors to place PCR (Program Clock Reference) on a different PID.
> >>
> >> If the PCR is unset the value is 0x1fff, most vendors appear to set it the
> >> same as video pid in which case it need not be set.
> >>
> >> The PCR PID is at an offset of 8 in pmtSection structure.  
> > 
> > Thanks for the patches!
> > 
> > Patches look good, except for two things:
> > 
> > - we use camelCase at Kaffeine. So, the new field should be pcrPid ;)  
> Ok, Wasn't sure
> 
> > 
> > - you didn't use dvbsi.xml. The way we usually update dvbsi.h and part of
> >    dvbsi.cpp is to add a field at dvbsi.xml and then run:
> > 
> > 	$ tools/update_dvbsi.sh  
> Oh I see.
> 
> 
> > 
> >    Kaffeine should be built with the optional BUILD_TOOLS feature, in order
> >    for it to build the tool that parses dvbsi.xml.
> > 
> > Anyway, I applied your patchset and added a few pathes afterwards
> > adjusting it.  
> 
> Thanks
> 
> How do you turn off debug the spam from epg is horrendous.

The default should have been to have those debug messages disabled.
I'm pretty sure I wrote some patches for it some time ago, but it
seems they got lost.

Anyway, I wrote them again. You should now see debug messages only
if kaffeine is called with --debug or using
	QT_LOGGING_RULES=kaffeine.category.debug=true

as stated on its help message.

> 
> Regards
> 
> 
> Malcolm
> 
> 



Thanks,
Mauro
