Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m415wqoW026614
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 01:58:52 -0400
Received: from smtp2b.orange.fr (smtp2b.orange.fr [80.12.242.145])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m415wcjj015782
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 01:58:39 -0400
Date: Thu, 1 May 2008 07:58:31 +0200
From: mahakali <mahakali@orange.fr>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080501055831.GA6321@orange.fr>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
	<1209507302.3456.83.camel@pc10.localdom.local>
	<20080430155851.GA5818@orange.fr>
	<1209592608.31036.36.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1209592608.31036.36.camel@pc10.localdom.local>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Card Asus P7131 hybrid > no signal
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

On Wed, Apr 30, 2008 at 11:56:48PM +0200, hermann pitton wrote :
> Hi,
> 
> Am Mittwoch, den 30.04.2008, 17:58 +0200 schrieb mahakali:
> > On Wed, Apr 30, 2008 at 12:15:02AM +0200, hermann pitton wrote :
> 
> > > 
> > > Hello,
> > > 
> > > if you have card=112 tuner=61 auto detected something goes very wrong.
> > > 
> > > On any recent "official" code the card should be auto detected as
> > > card=112, tuner=54, which is the tda8290 analog IF demodulator within
> > > the saa7131e and behind its i2c gate is a tda8275ac1 at address 0x61
> > > which is correct in your logs.
> > > 
> > > Hopefully you are only confusing tuner address 61 with tuner type,
> > > auto detection should be OK then.
> > >
> > module saa7134 is now loading with following parameters :
> > 
> > card=112 tuner=54 i2c_scan=1 secam=L
> >  
> > > Analog TV is on the upper antenna connector (cable TV) and you need a
> > > saa7134 insmod option "secam=L" in France. ("modinfo saa7134")
> > > On La Corse may still be some "secam=Lc" broadcast, not sure about that.
> 
> > I don't have any upper or lower connector , only right and link.
> > °right connector is described as RF-FM and link as CAT-TV
> 
> That's OK.

I read somewhere you have to inverse the connectors, so for analog TV
you plug in the CAT-TV connector (?)  
> > > DVB-T (numerique) is on the lower antenna connector where also is
> > > radio/FM.
> > > 
> > > We have many reports that there often is an positive offset of about
> > > 166000Hz needed in France, which you don't seem to use on your digital
> > > tuning attempt. If this is needed and missing, the tda10046 will fail.
> > > You might try to add it.
> > > 
> > > Download dvb-apps from linuxtv.org mercurial and check if there is an
> > > updated initial scan file for your region in scan/dvb-t.
> > 
> > Nothing new.

> >  Itried it now with fr_Auxerre + offset
> > #### Auxerre - Molesmes ####
> > #R1
> > T 570166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > #R2
> > T 794166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > #R3
> > T 770166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > #R4
> > T 546166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > #R5
> > T 586166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > #R6
> > T 562166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> > 
> > but scanning fails ..... 
> >  
> > > You can also try to "scan" on a known frequency and bandwidth and set
> > > the rest to AUTO AUTO ... or get "wscan" or try with "kaffeine".

What do you mean by "the rest" ? Could you give an example line ??

 
> > Any idea ??
> 
> Not much more. Maybe some other value is wrong, which other digital
> demods tolerate. That was that with try AUTO there, except for frequency
> and bandwidth.
> 
> > 
> > Thanks
> > 
> > mahakali
> > 
> > PS :
> > I was asking myself , perhaps is something wrong with the connection, I
> > had to  put together cable and plug, so perhaps a bad electrical
> > transmission (??) but as I already said tvtime is dectecting some
> > channels but no image
> > 
> 
> I'm not aware of issues for DVB-T. There was trouble for such boards
> with LNA recently on devel stuff, but as far as I know it did not make
> it out to a kernel.
> 
> We have definitely issues on analog, but I can't test SECAM_L.

So I was fixed till now with analog, I could give digital a chance.
Where I am living  we get TNT, so digital TV
In the card package I got  a little black antenna, do I need other stuff
to get it working ? And how to do it? 

> 
> After ioctl2 conversion, the apps don't let the user select specific
> subnorms like PAL_I, PAL_BG, PAL_DK and SECAM_L, SECAM_DK, SECAM_Lc
> anymore.
> 
> What one can only select is visible here.
> http://linuxtv.org/hg/v4l-dvb/rev/aa554a86b38a

Code is at this time to complex for me.
> 
>
Thanks for all ...

mahakali 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
