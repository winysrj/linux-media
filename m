Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TFRFKY027665
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:27:15 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6TFR3w8008187
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 11:27:04 -0400
Received: by gxk21 with SMTP id 21so1557985gxk.3
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 08:27:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A706591.2090707@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
	<4A706591.2090707@gmail.com>
Date: Wed, 29 Jul 2009 11:27:03 -0400
Message-ID: <829197380907290827l461f42behe0a7a473b9e9a407@mail.gmail.com>
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

On Wed, Jul 29, 2009 at 11:06 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> Yeap, it have a turner becouse it is the robotis bioloid wireless camera
> set, that have this receiver recognized as the PointNix... witch use
> channels, 1, 2, 3. 4 to get the image wirelessly from the camera, no idea
> about what turner chip it use, going to see if I can take some photos of the
> PCB, but it is still with warrantie so I a little concern about it...

I just looked at the site, and I do not believe the device actually
has a tuner.  While you can pick which input to select, that is not
the same as a device that has an RF tuner and demodulator.

That said, I suspect you will find that once you get the latest code
installed, everything will work according to your expectations without
any additional code changes required.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
