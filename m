Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6UFVOF8014755
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 11:31:24 -0400
Received: from mail-yx0-f202.google.com (mail-yx0-f202.google.com
	[209.85.210.202])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6UFV8qh003565
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 11:31:08 -0400
Received: by yxe40 with SMTP id 40so2721943yxe.23
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 08:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A71BA59.8030605@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
	<4A706591.2090707@gmail.com>
	<829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>
	<4A71A11A.8070903@gmail.com>
	<829197380907300640g2b0df1ddm31cdef61c4565d25@mail.gmail.com>
	<4A71ABDB.2070100@gmail.com>
	<829197380907300732q4cd9b684g8a6bc520f734ee0a@mail.gmail.com>
	<4A71BA59.8030605@gmail.com>
Date: Thu, 30 Jul 2009 11:31:07 -0400
Message-ID: <829197380907300831j65ec1800ke806667ba2d18290@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
	No Composite Input
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

On Thu, Jul 30, 2009 at 11:20 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> ok sure, but I'm looking something kind of weird with this driver, let me
> explain, with a regular bttv card that I have here that it have 4 inputs,
> xawtv first start try to use lets says s-video, then I changed to
> composite1, close xawtv and next time is set as default as composite1 (no
> xawtv config file), in that way if then I use vlc or ffplay they take that
> input as default. But with this em28xx driver every time that xawtv start it
> set to use the first input witch is s-video no matter to what do I change
> the previous time...
>
> any ideas about why?, or it is just a different way that both drivers
> handled this?

Hmm..  I don't know.  I would have to look at the source code to answer that.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
