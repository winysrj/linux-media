Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7G69RCm026825
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 02:09:27 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7G69Dx0014470
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 02:09:13 -0400
Received: by qw-out-2122.google.com with SMTP id 5so676112qwi.39
	for <video4linux-list@redhat.com>; Sat, 15 Aug 2009 23:09:13 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
In-Reply-To: <20090816080309.3f19a067@tele>
References: <4A872D3F.6020003@ntnu.no>
	<1250383433.28382.2.camel@localhost.localdomain>
	<20090816080309.3f19a067@tele>
Content-Type: text/plain
Date: Sun, 16 Aug 2009 09:09:08 +0300
Message-Id: <1250402948.16203.1.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Varying frame rate
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

On Sun, 2009-08-16 at 08:03 +0200, Jean-Francois Moine wrote:
> On Sun, 16 Aug 2009 03:43:52 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Sat, 2009-08-15 at 23:48 +0200, Haavard Holm wrote:
> 	[snip]
> > > My obeservation is : Depending on what my camera focus on, the
> > > framerate varies from 5 to 15 fps. I have tried several times, same
> > > result.
> 	[snip]
> > I have observed similar issues with uvc camera on my aspire one (low
> > frame rate while the illumination is low)
> > 
> > Probably this is a hardware issue, and maybe there is a control to
> > turn this off.
> 
> Hello,
> 
> The frame rate depends on the exposure time. If auto exposure is set,
> you may have such a behaviour.
Exactly, that is what I was trying to say, but didn't...

Best regards,
	Maxim Levitsky

> 
> Best regards.
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
