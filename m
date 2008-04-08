Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38Mp2MH020705
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 18:51:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38MoaWN006484
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 18:50:36 -0400
Date: Tue, 8 Apr 2008 19:49:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080408194959.6d696b0b@gaivota>
In-Reply-To: <1207693265.5135.14.camel@pc08.localdom.local>
References: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
	<200804081733.54539.zzam@gentoo.org>
	<1207693265.5135.14.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
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

On Wed, 09 Apr 2008 00:21:05 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi,
> 
> Am Dienstag, den 08.04.2008, 17:33 +0200 schrieb Matthias Schwarzott:
> > On Dienstag, 8. April 2008, Eduard Huguet wrote:
> > > Hi,
> > >     Things are very quiet lately regarding this card. Is there any
> > > possibility that the card gets supported in any near future? I know
> > > Matthias  Schwarzot had been working on it, but there's no messages from
> > > him lately on the list.
> > >
> > > Best regards,
> > >   Eduard
> > 
> > I did not made any progress since last time we corresponded.
> > 
> > But: I think we agree that the patch that only adds composite and s-video 
> > support works.
> > So we could request pulling it into v4l-dvb repository.
> > 
> > Regards
> > Matthias
> > 
> 
> Matthias, attached is your patch after some fixes against checkpatch.pl
> on "make commit".
> 
> Hartmut, can you have a look at it and, if no further issues,
> pull it in?

Don't mind. I've already applied it. 

> Reviewed-by: Hermann Pitton <hermann.pitton@arcor.de>

I've added your reviewed-by on -git.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
