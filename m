Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with SMTP id n5GD7RYE003478
	for <video4linux-list@redhat.com>; Tue, 16 Jun 2009 09:07:27 -0400
Received: from mail-yx0-f184.google.com (mail-yx0-f184.google.com
	[209.85.210.184])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n5GD79KU029532
	for <video4linux-list@redhat.com>; Tue, 16 Jun 2009 09:07:09 -0400
Received: by yxe14 with SMTP id 14so968163yxe.23
	for <video4linux-list@redhat.com>; Tue, 16 Jun 2009 06:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245156744.32512.1320634869@webmail.messagingengine.com>
References: <1244834106.19673.1320127457@webmail.messagingengine.com>
	<829197380906150812w3b524b9cw41e7e3b5e3d65f03@mail.gmail.com>
	<1245156744.32512.1320634869@webmail.messagingengine.com>
Date: Tue, 16 Jun 2009 09:07:09 -0400
Message-ID: <829197380906160607t34dcb04chcab5bf2344927c21@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Kay Wrobel <kwrobel@letterboxes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
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

On Tue, Jun 16, 2009 at 8:52 AM, Kay Wrobel<kwrobel@letterboxes.org> wrote:
> Devin,
>
> You're right. I'm not getting any audio from that device. My excitement
> was premature. The Composite video, however, works great now. Thanks for
> that.
>
> Kay

Just an FYI:  the fix went in last night so that the /dev/audio device
won't get created for the KWorld 2800d.  This will help eliminate user
confusion in the future (since users will now not see a audio device
that will never work).

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
