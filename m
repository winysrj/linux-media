Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GHI83B022786
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:18:08 -0400
Received: from web56412.mail.re3.yahoo.com (web56412.mail.re3.yahoo.com
	[216.252.111.91])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2GHHWYN008493
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:17:32 -0400
Date: Sun, 16 Mar 2008 10:17:26 -0700 (PDT)
From: r bartlett <techwritebos@yahoo.com>
To: video4linux-list@redhat.com
In-Reply-To: <20080316160007.A646C6191C9@hormel.redhat.com>
MIME-Version: 1.0
Message-ID: <895427.896.qm@web56412.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: Another very basic question (the bozo with the WinTV-HVR-1800)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I greatly appreciate the answers and am sorry to have posted in a way that wasn't kosher.  Not that it's any excuse, but I've had trouble replying to the thread because I get a batch mail with all the day's replies bundled into one,  and I'm more used to online forums than lists.  I haven't figured out the best way to retain the threading, and I actually _have_ been reading the wikis.  For weeks.  :-)  Posting here is a last resort, and part of the frustration is that if one gets a small thing wrong (in my case, one problem was that I was trying to use ATSC scanning when I should have been using QAM...a simple error but for weeks it stumped me).  The wikis are almost unintelligible in places, and assume a vast body of tv-related knowledge that I just don't have (nor, frankly, would many people who just want to put in a tv tuner card and watch tv).  I'm posting here in this forum as a last resort for questions that probably ARE answerable in the wikis, but I just didn't find
 them, either by searching for terms that aren't right or by looking in the wrong places.  It's a chicken-and-egg thing:  you can't understand the wikis until you know what the terms are, and you can't understand the terms until you've learned the wikis.

If anyone out there involved in documentation is interested in working on versions that are more bozo-friendly, I'd be happy to help.  For example, one thing that seems universally lacking in much Linux-related documentation (such as Man pages) is examples.  Even a distro-specific example, "in XYZ distro /this/directory/this/command but yours may differ" is a huge help.  The wiki about DVB Search is one of the best I've seen thus far in this tv search, because it's clear, concise, and includes examples.

In any case, I greatly appreciate the answers and suggestions; it sounds like at this point, I've done what I can and have the few unencrypted digital channels configured properly.  I'll sign off and if I have questions in the future I'll try to ask them in the proper way.  Thanks for the tips on how to do that.  I'm sorry my posts got people (understandably) perturbed. 


video4linux-list-request@redhat.com wrote:

From: CityK <cityk@rogers.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Sat, 15 Mar 2008 18:40:12 -0400
Subject: Another very basic question...

 I'm going to be blunt about something -- you're not being particularly 
helpful to yourself or the list:
- To yourself because you're not being very efficient.
- To the list because you're breeching etiquette.

Here are a few tips:

1 - instead of breaking threading, and opposed to having a zillion 
different threads essentially all about the same things, keep your 
content within one i.e. the original message ... having a contiguous 
thread will also help those who may, in future, search the lists for 
similar problems

2 - entitle your threads appropriately  -- i.e. "another very basic 
question ... " or "the final inch" are not very helpful  .... the last 
one in particular, given the thousand or so emails I receive each week 
from China, Russia etc etc regarding viagra, penis enlargement etc etc 
etc ... if your goal is to get/reach those who are most capable of 
helping you, you're certainly going about it the wrong way ... (i) busy 
people will browse over items that don't seem interesting or appear on 
the surface to possibly be spam  and (ii) please don't ambiguious 
messages  as it just ends up wasting others time in trying to figure out 
what your question is/relates too (i.e. perfect example: Merc trying to 
figure out what you were talking about in this thread)

3 - a number of the "basic questions" you have posed are readily 
answered in the wikis ... so, in posting here about these elementary 
issues,  you've wasted your and my (and others) time too ...
- your time because you likely could have read about the solutions 
quicker then you typed/enquired about them
- my and others time because we've already spent considerable time 
trying to document such elementary questions in the wiki ... and my time 
again in having to compose this message to draw light to this fact

4 - please don't top post




From: CityK <cityk@rogers.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Sat, 15 Mar 2008 19:17:41 -0400
Subject: Another very basic question...

 >
> I've got a WinTV-HVR-1800, which has an analog tuner and a ATSC/QAM tuner.  The \
> analog side seems to not yet be supported (It works -- I can boot to Vista and watch \
> the analog side) by Linux,  
>
> ...
>
> > From reading other posts and following a few other forums, it looks like the analog \
> > part is still not supported by the 2.6.24 kernel. 
>   

That's correct, analog is currently not supported under Linux ... except 
for preliminary/experimental support available in one of stoth's Hg repos 

> but I was wondering whether I can tweak my channels.conf \
> or something and get more digital channels.
>
> I'm kind of new to the various ATSC, QAM, NTSC_M stuff.  My assumption up to this \
> point has been that if I want to watch the full range of channels (1-120) or \
> something, I need to do it through analog.
>
> My system is Comcast Digital cable with OnDemand, a Comcast-supplied box (looks \
> small, like a router, not a PVR) and remote control (neither of which I'm currently \
> using), and a Y-split cable line that goes directly to my tv card.  Currently I'm \
> seeing things like NBC, CBS, ABC, PBS (a few channels), FOX, CW...and a few local \
> stations.  If it's also possible to tune to Food Network, Sci-fi, Cartoon Network, \
> etc, that would be great.  These stations come in fine on my regular television with \
> no box or anything -- just the cable line going into the house.  I'm guessing that if \
> more channels were _going_ to come in at all on my tuner card, they'd already be \
> coming in.  :-)  But I could be wrong. 
>
> ....
>
> > But if these other channels are \
> > available on the digital side, that'd be cool.  My tuning, thus far, has only been \
> > on QAM256. 
>
>   

The Food network etc channels you are seeing on your tv (cable straight 
from wall to tv) are analog channels.  As your tv card currently doesn't 
support analog, these won't work.  If your cable co. transmits 
unencrypted digital versions of those channels, your card would work.  
Doesn't sound like that is the case for you....In other words, there are 
no "tweaks" for your channels.conf file that are going to acquire those 
channels.

> ATSC (antenna, right?) didn't come in at all.  

Yes, ATSC is digital over/off-the-air and requires an antenna for 
reception .... it uses 8VSB modulation.

Digital cable in North America (which isn't ATSC, but is highly 
conformative and interoperative with ATSC, and where the remaining 
differences being defined by SCTE etc standards)  typically/by defacto 
uses QAM (Quadrature Amplitude Modulation).

> I haven't tried HRC or \
> > the others. Just us-Cable-Standard-center-frequencies-QAM256, which found about 350 \
> > signals, of which only about 10 were actual working channels.
>   

Certainly sounds like your cable operator/supplier uses centre frequencies

> Is it possible to have more channels come in?  

Only if they are unencrypted.

> Should plug in my Comcast box and \
> use a different method to scan for channels?  (I've tried plugging in the box but \
> that seems to kill my digital signal entirely -- I then don't get any channels)
>   

Doesn't work that way.  Can't remember if I wrote about it in the wiki 
or not, but I do have a bookmark handy;  See:
http://archive2.avsforum.com/avs-vb/showthread.php?p=7328646&&#post7328646

The post is a bit dated now, and in reference to something else, but it 
should contain an explanation regarding why  
STB_RF_output--to--digital_tuner_card_RF_input doesn't work.

> Thanks for putting up with these really basic questions.  I apologize in \
> advance...and greatly appreciate the help!

NP -- but please do heed the advice in the previous message.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


       
---------------------------------
Looking for last minute shopping deals?  Find them fast with Yahoo! Search.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
