Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9IMlw9V021720
	for <video4linux-list@redhat.com>; Sun, 18 Oct 2009 18:47:58 -0400
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9IMleZh018938
	for <video4linux-list@redhat.com>; Sun, 18 Oct 2009 18:47:41 -0400
Received: by fxm5 with SMTP id 5so2438577fxm.3
	for <video4linux-list@redhat.com>; Sun, 18 Oct 2009 15:47:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1255899566299-3845932.post@n2.nabble.com>
References: <1244834106.19673.1320127457@webmail.messagingengine.com>
	<1255893257216-3845496.post@n2.nabble.com>
	<829197380910181308p1c43d6ean7dff216f28ff25c1@mail.gmail.com>
	<1255899566299-3845932.post@n2.nabble.com>
Date: Sun, 18 Oct 2009 18:47:39 -0400
Message-ID: <829197380910181547l39af23c4q2e25b94cca5c5a0a@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: chris snow <chsnow123@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Cc: video4linux-list@redhat.com
Subject: Re: SUCCESS - KWorld VS-USB2800D recognized as PointNix Intra-Oral
	Camera - No Composite Input
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

On Sun, Oct 18, 2009 at 4:59 PM, chris snow <chsnow123@gmail.com> wrote:
>
> Is this hardware any good? There is a lot of 1 star reviews on amazon.co.uk,
> but I'm not sure if it's user error rather than the hardware....
>
> Many thanks,
>
> Chris

It's not a bad piece of hardware in terms of capture quality.  Bear in
mind that it only has S-Video and composite inputs - it does not have
a tuner.  Also, the audio feed comes through the external cable, so
you need to hook that to the line-in on your soundcard.  It also
doesn't have an IR receiver or blaster, so not well suited for
controlling a cable box.

One more warning: they just released a new version of the product
which uses a different chip.  As a result, if you haven't bought it
yet you might end up with the new version, which *is* supported in the
latest v4l-dvb tree, but that support was introduced after Ubuntu 9.10
took the kernel.

In other words, it's all about what you intend to do with the product.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
