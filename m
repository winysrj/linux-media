Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2FNIQO7024171
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 19:18:26 -0400
Received: from smtp107.rog.mail.re2.yahoo.com (smtp107.rog.mail.re2.yahoo.com
	[68.142.225.205])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2FNHm8X021413
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 19:17:48 -0400
Message-ID: <47DC5915.4010709@rogers.com>
Date: Sat, 15 Mar 2008 19:17:41 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Another very basic question...
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
