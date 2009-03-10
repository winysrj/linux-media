Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2AJkuGu025028
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 15:46:56 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net
	(pne-smtpout2-sn1.fre.skanova.net [81.228.11.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2AJkbk0011804
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 15:46:37 -0400
Message-ID: <49B6C39B.5030308@gmail.com>
Date: Tue, 10 Mar 2009 20:46:35 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Marco Baldo <marco.baldo.ve@gmail.com>
References: <757044da0903100159p45c69bf6k518c56eb36ad67a6@mail.gmail.com>
In-Reply-To: <757044da0903100159p45c69bf6k518c56eb36ad67a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, m560x-driver-devel@sourceforge.net
Subject: Re: About support for the ALi m5602 usb bridge
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Marco Baldo wrote:
> Hi,
> I have a Asus A6K notebook with the webcam sensor mounted upside down.
> Please insert this model too, in the patch released by Erik Andren:
> 
> +	{
> +		.ident = "ASUS A6K",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "A6K")
> +		}
> +	},
> 
> I did it and my webcam works now.

Quirk added, thanks for reporting.

Best regards,
Erik

> 
> Best regards
> Marco Baldo
> Italy
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm2w5oACgkQN7qBt+4UG0FJnQCZAf3kHt4R3OGo1sj6HjZ9JNX/
ODAAn39NRHJ4p0CeuWJ1IfPLtK3spiHx
=wKbf
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
