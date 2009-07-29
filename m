Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TEgmWE012585
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 10:42:48 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6TEgVac026571
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 10:42:31 -0400
Received: by qw-out-2122.google.com with SMTP id 5so378510qwi.39
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 07:42:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
Date: Wed, 29 Jul 2009 10:42:30 -0400
Message-ID: <829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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

On Wed, Jul 29, 2009 at 10:34 AM, Devin
Heitmueller<dheitmueller@kernellabs.com> wrote:
> I can tell from the dmesg output that the code you are running in
> still very old.  The current code will now dump out the "Alternate
> Setting" lines and will identify the device as an "em28xx/saa713x
> reference design".

Correction: I meant to say the "current code will *not* dump out"
instead of "will now dump out".

Also, rereading your email, are you sure the device has a tuner?  Do
you know what tuner chip it contains?  If not, can you send digital
photos of the PCB?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
