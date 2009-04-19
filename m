Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep53.mail.dk ([80.160.77.118]:36673 "EHLO fep53.mail.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZDSWac (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 18:30:32 -0400
Message-ID: <49EBA5C6.5060808@liberalismen.dk>
Date: Mon, 20 Apr 2009 00:29:26 +0200
From: Kjeld Flarup <kjeld.flarup@liberalismen.dk>
MIME-Version: 1.0
To: Michael Riepe <michael.riepe@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: dvbd
References: <49EA7EFA.4030701@liberalismen.dk> <49EAF472.9010702@googlemail.com>
In-Reply-To: <49EAF472.9010702@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael

Thanks for your reply. Tweaking the scheduling is ususally easy to fix. 
I might want to look at the buffering too. It ought to be a system thing.
I never got VDR working properly, and currently I use mplayer/mencoder 
to record.

But one thing which I would like to do is to use dvbd together with VLC, 
because VLC can handle the DVB subtitles used in Denmark. But VLC does 
not seem to like connecting to the dvbd socket. If anyone have success 
with that, I sure would like to know.

Also at some time soon I would need to stream some DVB signals. But I do 
not like the way this is done by most tools, they seems to be using up 
CPU cycles even if nobody is listening.

  Regards Kjeld

Michael Riepe wrote:
> Hi!
>
> Kjeld Flarup wrote:
>
>   
>> I've taken some interest in a small piece of software called dvbd.
>> http://dvbd.sourceforge.net/
>> I really like the concept of this software, because it could be used for
>> sharing one DVB card among several different applications.
>>     
>
> That's right.
>
>   
>> BUT the software have not been developed since 2004.
>>     
>
> And it needs a few tweaks when you're using a more recent C++ compiler
> like gcc 4.3.x.
>
>   
>> Is this because it is not so smart anyway, or are there some better
>> programs out there?
>>     
>
> There is VDR, of course. But I don't like the way it does things.
> Therefore, I've been using dvbd for years to handle my small zoo of
> DVB-T receivers (I've got four of them running at the moment). It easily
> handles several recordings in parallel without using many resources - a
> few megabytes of RAM and a few percent of CPU time on an old (2005)
> Athlon64. I currently consider moving it to an Intel Atom based system.
>
> dvbd does sometimes have issues with disk writes, though. It doesn't do
> much buffering, and if another process is blocking the disk it's writing
> to for too long, you may encounter drop-outs. It's best to give it a
> disk of its own. Similarly, if dvbd doesn't get scheduled for a while,
> it will lose data from the receivers. On a single-core machine that also
> does other things (like mine), I recommend to raise its priority with
> nice --20, or maybe use a realtime priority level.
>
>   


-- 
-------------------- Med Liberalistiske Hilsner ----------------------
  Civilingeniør, Kjeld Flarup - Mit sind er mere åbent end min tegnebog
  Forssavej 49, 7600 Struer, Tlf: 40 29 41 49
  Den ikke akademiske hjemmeside for liberalismen - www.liberalismen.dk


