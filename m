Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jw4ab-0002cK-B8
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 02:11:27 +0200
From: allan k <sonofzev@iinet.net.au>
To: stev391@email.com
In-Reply-To: <20080513235526.5A85ABE4079@ws1-9.us4.outblaze.com>
References: <20080513235526.5A85ABE4079@ws1-9.us4.outblaze.com>
Date: Wed, 14 May 2008 10:11:15 +1000
Message-Id: <1210723875.9616.1.camel@media1>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will	it
	be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Don't worry about it. 

I have a remote (Fusion MCE, that I bought for a pack of smokes as my
Fusion USB remote is on my frontend only box in the bedroom). 

It is more of a nice to have, as the express remote is better laid out,
and better looking than the Fusion MCE). 

cheers

Allan
On Wed, 2008-05-14 at 09:55 +1000, stev391@email.com wrote:
> Allan,
> 
> lirc support for the remote is not one of priorities as I'm using an
> iMon VFD display that includes a remote control that has patches
> available against the lirc CVS.
> 
> However I can glance at it if I have time and see if I can implement
> an appropriate solution.
> 
> Stephen
> 
>         ----- Original Message -----
>         From: "allan k" 
>         To: stev391@email.com
>         Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express
>         - When will it be
>         Date: Wed, 14 May 2008 09:37:44 +1000
>         
>         
>         Also, just wondering if anyone was planning to look at
>         building lirc
>         based remote support for the packaged remote (not ir-tty as I
>         don't want
>         to remap the shortcut keys)
>         On Tue, 2008-05-13 at 18:57 +1000, stev391@email.com wrote:
>         > Allan,
>         >
>         > If you have used the v4l-dvb hg drivers and my patch the
>         card should
>         > auto detect, however if you want to force it, the number
>         should be 10.
>         >
>         > If you are using Chris Pascoe's xc-test branch then 5 is the
>         correct
>         > card number, but again it should auto detect.
>         >
>         > Please advise which driver source you have been using.
>         >
>         > Regards Stephen.
>         >
>         > ----- Original Message -----
>         > From: "allan k" To: stev391@email.com
>         > Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual
>         Express
>         > - When will it be
>         > Date: Tue, 13 May 2008 18:19:27 +1000
>         >
>         >
>         > Hi Steve
>         > I had the wrong card number selected. I have changed to
>         card=5
>         > and the
>         > tuner is now working correctly.
>         >
>         > I haven't restarted the machine, but will do so later and
>         > confirm
>         > whether I am getting the same problem as you saw on one of
>         > your boxes.
>         >
>         > cheers
>         >
>         > Allan
>         >
>         >
>         >
>         >
>         >
>         >
>         >
>         >
>         > On Sat, 2008-05-10 at 18:14 +1000, stev391@email.com wrote:
>         > > Allan,
>         > >
>         > > It was tested with in two different machines against the
>         > cx23885
>         > > version of the card. However the next day I built another
>         > machine
>         > > with this card and I ran into errors in my dmesg stating
>         > that the
>         > > firmware version doesn't match. I haven't had enough time
>         to
>         > find out
>         > > why this has happened, but I think the tuner is not being
>         > reset
>         > > properly. What are your results of running this patch?
>         > >
>         > > Regards,
>         > >
>         > > Stephen
>         > >
>         > > ----- Original Message -----
>         > > From: "sonofzev@iinet.net.au" To: > 
>         > linux-dvb@linuxtv.org, stev391@email.com
>         > > Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual
>         > Express
>         > > - When will it be
>         > > Date: Thu, 08 May 2008 18:02:00 +0800
>         > >
>         > >
>         > > Hi Stephen, Has this been tested with the > 
>         > newer cx23885 version of the
>         > > card or only the older cx88 version. I have had 
>         > > no success with my cx23885 version. cheers
>         > >
>         > > Allan
>         > >
>         > >
>         > > On Tue May 6 11:39 , stev391@email.com sent:
>         > >
>         > > G'day,
>         > >
>         > > I was just wondering when Chris Pascoe's code for the
>         > > DViCO Fusion HDTV Dual Express will be merged into the
>         > > v4l-dvb tree, as there have been some minor updates
>         > > that increase the stability of the card that are not
>         > > in his tree.
>         > >
>         > > Attached is a patch for merging the relevant sections
>         > > back into the v4l-dvb tree (and including updating
>         > > Kconfig). This has been successfully tested on two
>         > > different PCs with this card (working with gxine and
>         > > mythtv, in Melbourne, Australia).
>         > >
>         > > Regards,
>         > > Stephen.
>         > >
>         > >
>         > > -- See Exclusive Video: 10th > Annual Young Hollywood
>         > > Awards
>         > >
>         > >
>         > >
>         > > -- See Exclusive Video: 10th Annual Young Hollywood Awards
>         > >
>         >
>         > -- See Exclusive Video: 10th Annual Young Hollywood Awards
>         >
> 
> -- 
> See Exclusive Video: 10th Annual Young Hollywood Awards
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
