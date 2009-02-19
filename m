Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1JN97WG001457
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 18:09:07 -0500
Received: from mail-in-15.arcor-online.net (mail-in-15.arcor-online.net
	[151.189.21.55])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1JN8stw008082
	for <video4linux-list@redhat.com>; Thu, 19 Feb 2009 18:08:54 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: John Pilkington <J.Pilk@tesco.net>
In-Reply-To: <499D5D4C.8070803@tesco.net>
References: <498C3AD4.1070907@tesco.net>
	<1233958764.2466.72.camel@pc10.localdom.local>
	<4990B315.8000309@tesco.net>
	<1234228256.3932.15.camel@pc10.localdom.local>
	<499C0E76.9000907@tesco.net>
	<1235000333.2486.35.camel@pc10.localdom.local>
	<499D4FD2.6010503@tesco.net> <499D5D4C.8070803@tesco.net>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 00:09:56 +0100
Message-Id: <1235084996.3514.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l_list <video4linux-list@redhat.com>
Subject: Re: Hauppauge HVR-1110 analog audio problem - success
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

Hi John,

Am Donnerstag, den 19.02.2009, 13:23 +0000 schrieb John Pilkington:
> John Pilkington wrote:
> > hermann pitton wrote:
> >> Am Mittwoch, den 18.02.2009, 13:34 +0000 schrieb John Pilkington:
> >>> < older stuff deleted>
> > 
> >>
> >> tvtime -v --device=/dev/video2 and then
> >> "sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp3 -t ossdsp -w -r 32000 
> >> /dev/dsp"
> > 
> > [John@gateway ~]$ sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp3 -t ossdsp 
> > -w -r 32000 /dev/dsp
> > sox: invalid option -- 'w'
> > sox: SoX v14.2.0
> > 
> > Failed: invalid option
> > 
> > 
> > Hi Hermann, and thanks again. My card shows up as /dev/video0, but the 
> > sox produces this. I got it before and wonder why?  I can't find a 
> > sensible-looking instance of -w in my docs or on the sox site.  Is it a 
> > switch to pcm, is it tied to oss?

sorry, I forgot that the -w option is deprecated with recent sox
versions like shipped with Fedora 10. It forces 16bit (2byte, one word
-w) sample size, default is 8bit only. The -2 option does the same and
should still be valid.

> > Cheers, John
> 
> It works in tvtime, antenna and composite, with
> 
> > sox -c 2 -s -u -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -u -r 32000 /dev/dsp
> 
> Maybe the alsa-plugins-oss helped.  More experiments still to do, but it 
> does work.

Uff ;) 

If you get some time for it you might test on the Avermedia Super 007
and report if we can remove the FIXME.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
