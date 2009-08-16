Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7G63V3N025559
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 02:03:31 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7G63F9R011607
	for <video4linux-list@redhat.com>; Sun, 16 Aug 2009 02:03:16 -0400
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 66FFA8180C9
	for <video4linux-list@redhat.com>;
	Sun, 16 Aug 2009 08:03:12 +0200 (CEST)
Received: from tele (qrm29-1-82-245-201-222.fbx.proxad.net [82.245.201.222])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 2DC058180BC
	for <video4linux-list@redhat.com>;
	Sun, 16 Aug 2009 08:03:09 +0200 (CEST)
Date: Sun, 16 Aug 2009 08:03:09 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Message-ID: <20090816080309.3f19a067@tele>
In-Reply-To: <1250383433.28382.2.camel@localhost.localdomain>
References: <4A872D3F.6020003@ntnu.no>
	<1250383433.28382.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

On Sun, 16 Aug 2009 03:43:52 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sat, 2009-08-15 at 23:48 +0200, Haavard Holm wrote:
	[snip]
> > My obeservation is : Depending on what my camera focus on, the
> > framerate varies from 5 to 15 fps. I have tried several times, same
> > result.
	[snip]
> I have observed similar issues with uvc camera on my aspire one (low
> frame rate while the illumination is low)
> 
> Probably this is a hardware issue, and maybe there is a control to
> turn this off.

Hello,

The frame rate depends on the exposure time. If auto exposure is set,
you may have such a behaviour.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
