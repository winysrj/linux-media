Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1Jw4dU-0003FK-Lu
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 02:14:30 +0200
From: allan k <sonofzev@iinet.net.au>
To: stev391@email.com
In-Reply-To: <20080513235244.BF9E4BE4078@ws1-9.us4.outblaze.com>
References: <20080513235244.BF9E4BE4078@ws1-9.us4.outblaze.com>
Date: Wed, 14 May 2008 10:14:17 +1000
Message-Id: <1210724057.9616.5.camel@media1>
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

Cool. 

I'll try your sources out later and provide feedback. (I have the same
issue as I run a Fusion Lite on the system as well). 

With regards to attenuation, there is a "pass through" port on my
Kingray antenna amplifier. From your feedback it looks like that if I
use the pass through port, I may get a better picture. 

cheers

Allan
On Wed, 2008-05-14 at 09:52 +1000, stev391@email.com wrote:
> Allan,
> 
> I have had similar issues to what you have described, with usually
> good reception channels having degraded quality.  
> 
> One solution that I have used is to place an attenuator in line to
> reduce the signal. This card has a good sensitivity for low reception
> levels however the dynamic range of the card is not good enough to
> handle what the older more common TV cards require for reception
> levels.
> 
> I have had no issue with Chris Pascoe's drivers, the only problem is
> that his branch is now get dated and some of my other dvb gear does
> not work reliably under his branch.  This is why I'm trying to
> generate a patch that works against the v4l-dvb tree.
> 
> Also can you tell me what programs you are using to watch TV with?
> With gxine I have no problem with my patch however when I run mythtv
> occassionally it crashes my tuner. I have yet to accurately determine
> why this is happening, and what I need to do to ensure that a
> userspace program doesn't crash my hardware.
> 
> Regards,
> Stephen.
> 
> 
>         ----- Original Message -----
>         From: "allan k" 
>         To: stev391@email.com
>         Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express
>         - When will it be
>         Date: Wed, 14 May 2008 09:30:29 +1000
>         
>         
>         Hi Steve
>         
>         I've been using Chris Pascoe's sources. I turned off the
>         forced card
>         number and the auto-detection seems to be working.
>         
>         I don't know if it's weather related or if it's to do with
>         additional
>         interference from the card, but since I got it working,
>         channel 9 (which
>         is usually very good) and ABC reception (which seems to come
>         in and out)
>         has gone to unwatchable. Any thoughts on this? (should I run
>         separate
>         cables from my antenna amplifier to each card, or is using the
>         out port
>         on the Fusion Lite to the Express okay?)
>         
>         I'm studying for an exam next week, but if you'd like me to
>         test your
>         sources I can try that after next week.
>         
>         cheers
>         
>         Allan
>         
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
