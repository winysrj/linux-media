Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1JvooM-0006Ro-4k
	for linux-dvb@linuxtv.org; Tue, 13 May 2008 09:20:37 +0200
From: allan k <sonofzev@iinet.net.au>
To: stev391@email.com
In-Reply-To: <20080510081424.8288B1CE7C0@ws1-6.us4.outblaze.com>
References: <20080510081424.8288B1CE7C0@ws1-6.us4.outblaze.com>
Date: Tue, 13 May 2008 17:21:08 +1000
Message-Id: <1210663268.12303.1.camel@media1>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi Steve 

I'll try it in the next couple of days. 

cheers

Allan
On Sat, 2008-05-10 at 18:14 +1000, stev391@email.com wrote:
> Allan,
> 
> It was tested with in two different machines against the cx23885
> version of the card.  However the next day I built another machine
> with this card and I ran into errors in my dmesg stating that the
> firmware version doesn't match.  I haven't had enough time to find out
> why this has happened, but I think the tuner is not being reset
> properly. 
> 
> What are your results of running this patch?
> 
> Regards,
> 
> Stephen
> 
>         ----- Original Message -----
>         From: "sonofzev@iinet.net.au" 
>         To: linux-dvb@linuxtv.org, stev391@email.com
>         Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express
>         - When will it be
>         Date: Thu, 08 May 2008 18:02:00 +0800
>         
>         
>         Hi Stephen, 
>         
>         Has this been tested with the newer cx23885 version of the
>         card or only the older cx88 version. 
>         I have had no success with my cx23885 version. 
>         
>         cheers
>         
>         Allan
>         
>         
>         On Tue May 6 11:39 , stev391@email.com sent:
>         
>                 G'day,
>                 
>                 I was just wondering when Chris Pascoe's code for the
>                 DViCO Fusion HDTV Dual Express will be merged into the
>                 v4l-dvb tree, as there have been some minor updates
>                 that increase the stability of the card that are not
>                 in his tree.
>                 
>                 Attached is a patch for merging the relevant sections
>                 back into the v4l-dvb tree (and including updating
>                 Kconfig).  This has been successfully tested on two
>                 different PCs with this card (working with gxine and
>                 mythtv, in Melbourne, Australia).
>                 
>                 Regards,
>                 Stephen.
>                 
>                 
>                 -- 
>                 See Exclusive Video: 10th Annual Young Hollywood
>                 Awards
>                 
>         
> 
> -- 
> See Exclusive Video: 10th Annual Young Hollywood Awards
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
