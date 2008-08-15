Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7F3LET2004849
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 23:21:14 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7F3Ktdx000357
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 23:21:04 -0400
Received: by wf-out-1314.google.com with SMTP id 25so698709wfc.6
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 20:20:54 -0700 (PDT)
Message-ID: <443ddfb30808142020n4694e927r6a14fd095585604a@mail.gmail.com>
Date: Fri, 15 Aug 2008 10:20:54 +0700
From: "Nakarin Lamangthong" <lnakarin@gmail.com>
To: "Nakarin Lamangthong" <lnakarin@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <20080815000205.GA1359@daniel.bse>
MIME-Version: 1.0
References: <443ddfb30808141632l30b6fbefgda1bb2a1f6bbe028@mail.gmail.com>
	<20080815000205.GA1359@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Cc: 
Subject: Re: Commell MP-878D first time error
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

Hi, Daniel
>As your card can't be detected, you need to load the bttv module
>with pll=3D28 to be able to decode PAL signals.

How can i do that?  Please tell me the step that fix it.
Thanks,

lnakarin


On 15/08/2008, Daniel Gl=F6ckner <daniel-gl@gmx.net> wrote:
>
> On Fri, Aug 15, 2008 at 06:32:21AM +0700, Nakarin Lamangthong wrote:
> > I'm newbie for LinuxTV, I have a Capture Mini-pci Card form Commell
> MP-878D
>
> > bttv0: using:  *** UNKNOWN/GENERIC ***  [card=3D0,autodetected]
>
> As your card can't be detected, you need to load the bttv module
> with pll=3D28 to be able to decode PAL signals.
>
> > How do i fix this error?
> >
> > bt878_probe: card id=3D[0x0], Unknown card.
> > Exiting..
> > bt878: probe of 0000:00:0e.1 failed with error -22
>
> Ignore this error.
> It tells you that your card is none of the bt878 cards known to use the
> audio part to transport DVB data.
>
> Daniel
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
