Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QHFePW007089
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 12:15:40 -0500
Received: from smtp-vbr3.xs4all.nl (smtp-vbr3.xs4all.nl [194.109.24.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QHF6UK017363
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 12:15:06 -0500
Received: from tschai.lan (cm-84.208.70.98.getinternet.no [84.208.70.98])
	(authenticated bits=0)
	by smtp-vbr3.xs4all.nl (8.13.8/8.13.8) with ESMTP id m1QHF5FW026595
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 18:15:06 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 26 Feb 2008 18:15:05 +0100
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<47C44499.7050506@mediaxim.be>
In-Reply-To: <47C44499.7050506@mediaxim.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200802261815.05108.hverkuil@xs4all.nl>
Content-Transfer-Encoding: 8bit
Subject: Re: Grabbing 4:3 and 16:9
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

On Tuesday 26 February 2008 17:55:53 Michel Bardiaux wrote:
> Daniel Glöckner wrote:
> > On Tue, Feb 26, 2008 at 12:19:39PM +0100, Michel Bardiaux wrote:
> >> Here in Belgium the broadcasts is sometimes 4:3, sometimes 16:9.
> >> Currently, the card goes automatically in letterbox mode when it
> >> receives 16:9, and our software captures the 4:3 frames at size
> >> 704x576.
> >
> > The card does not go into letterbox mode. It's the broadcaster who
> > squeezes the 16:9 picture into 432 lines surrounded by 144 black
> > lines.
>
> Let me rephrase to check I understood correctly. In analog TV, there
> are no anamorphic broadcasts. When the WSS (accessible via /dev/vbi,
> right?) states 16:9, then a 16:9 (sic) TV switches to a mode where it
> crops 2x72 lines, then stretches the image both horizontally and
> vertically to fill the whole 16:9 screen. Am I correct?

Yes, this is really true. Remember that the broadcast should still work 
when received by an old 4:3 TV. The only way to ensure that it still 
looks OK is to letterbox it. As mentioned before PALPlus allows the 
broadcaster to encode additional information encoded in the black bars 
to improve the image quality (never looked into that, though).

BTW, WSS does allow anamorphic broadcasts, although it is very rare. I 
saw it once, but I've always suspected that someone made a 
configuration error because anamorphic broadcasts look squashed on 
normal 4:3 TVs.

> I must admit I have difficulty believing that. Could you give me the
> URLs of sites explaining all that?

http://en.wikipedia.org/wiki/Widescreen_signaling

http://en.wikipedia.org/wiki/PALPlus

Regards,

	Hans

>
> > Some fill the chroma part of the black lines with a PALPlus helper
> > signal. Although the algorithms to decode PALPlus are well
> > documented in ETS 300 731, I have never seen a software
> > implementation.
> >
> >> 1. How do I sense from the software that the mode is currently
> >> 16:9 or 4:3?
> >
> > Some broadcasters use WSS to signal 16:9.
> > In Germany some signal 4:3 even on 16:9 shows.
> > Read ETSI EN 300 294.
> >
> >> 2. How do I setup the bttv so that it does variable anamorphosis
> >> instead of letterboxing? If that is at all possible of course...
> >
> > You can't. Bttv can't stretch vertically.
> >
> >   Daniel



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
