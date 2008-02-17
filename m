Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1HFaMvE024424
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 10:36:22 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1HFZvvt021268
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 10:35:58 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1062428rvb.51
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 07:35:52 -0800 (PST)
Message-ID: <d9def9db0802170735o5cae0622v79d151a354c68963@mail.gmail.com>
Date: Sun, 17 Feb 2008 16:35:52 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Daniel Gimpelevich" <daniel@gimpelevich.san-francisco.ca.us>
In-Reply-To: <pan.2008.02.16.19.30.41.575048@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <20080127173132.551401d9@tux.abusar.org.br>
	<20080128182634.345bd4e8@tux.abusar.org.br>
	<20080128184534.7af7a41b@gaivota>
	<20080128192230.59921445@tux.abusar.org.br>
	<20080129004104.17e20224@gaivota>
	<20080129021904.1d3047d1@tux.abusar.org.br>
	<20080129025020.60fa33de@gaivota>
	<20080129050103.2fae9d61@tux.abusar.org.br>
	<20080129122547.63214371@gaivota>
	<pan.2008.02.16.19.30.41.575048@gimpelevich.san-francisco.ca.us>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: When
	xc3028/xc2028 will be supported?
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

On 2/16/08, Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us> wrote:
> On Tue, 29 Jan 2008 12:25:47 -0200, Mauro Carvalho Chehab wrote:
>
> > Dâniel and others,
> >
> >> > Having this tested is a very good news! I'll need to merge this patch
> with two
> >> > other patches that adds DVB support for cx88/xc3028. If I can manage to
> have
> >> > some time for this merge, I'll commit and ask Linus to add this to
> 2.6.25.
> >>
> >> 	:)
> >
> > I've merged some patches from several authors, that add xc3028 support for
> > cx88.
> >
> > The experimental tree is available at:
> >
> > http://linuxtv.org/hg/~mchehab/cx88-xc2028
> >
> > This patch series adds support for the following boards:
> >
> >  59 -> DVICO HDTV5 PCI Nano                                [18ac:d530]
> >  60 -> Pinnacle Hybrid PCTV                                [12ab:1788]
> >  61 -> Winfast TV2000 XP Global                            [107d:6f18]
> >  62 -> PowerColor Real Angel 330                           [14f1:ea3d]
> >  63 -> Geniatech X8000-MT DVBT                             [14f1:8852]
> >  64 -> DViCO FusionHDTV DVB-T PRO                          [18ac:db30]
> >
> > In thesis, both analog and DVB support (for boards with DVB/ATSC) should
> be
> > working (*). Maybe analog audio may need an additional configuration for
> some
> > specific board (since they may require to add cfg.mts = 1 at xc3028
> > initialization code, on cx88-cards).
> >
> > Please test.
> >
> > (*) Pinnacle Hybrid PCTV support for DVB is not available yet.
> >
> > Cheers,
> > Mauro
>
> About ten weeks ago, the only support for the Powercolor Real Angel 330
> appeared to be in Markus's mercurial tree, so I tried it. It did not work,
> because the GPIO settings were all wrong. I ran some tests, and fixed the
> problems. I made Markus aware of my patch several times, and he always
> said he would soon add it to his tree along with many others he received.
> He apparently never got to it, and now his server seems to have
> disappeared from the web. If anyone still has a copy of his repository,
> the following patch against it makes all functions of this card work
> perfectly:
> http://pastebin.com/f44a13031
> Today, I noticed the new cx88-xc2028 tree on which Mauro has begun some
> work. I have not tried it, but in comparing the code to Markus's, most
> support appears to be missing. I thought that maybe I could try merging
> Markus's old tree with Mauro's new one, but the absence of Markus's server
> means I can't. If anyone here would like my assistance in reconciling the
> competing code in the two trees, please contact me off-list. Thank you.
>

the server should be back on monday.. there's some maintainance going
on by the other admin.. I have to wait for it too..

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
