Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60915 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbZKMUEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 15:04:21 -0500
Received: by bwz27 with SMTP id 27so3835181bwz.21
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 12:04:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091113193405.GA9499@pathfinder.pcs.usp.br>
References: <20091113193405.GA9499@pathfinder.pcs.usp.br>
Date: Fri, 13 Nov 2009 21:04:23 +0100
Message-ID: <62e5edd40911131204w2b8203eexc079ae46d88f1d0d@mail.gmail.com>
Subject: Re: new sensor for a t613 camera
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Nicolau Werneck <nwerneck@gmail.com>
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/13 Nicolau Werneck <nwerneck@gmail.com>:
> Hello.
>
> I bought me a new webcam. lsusb said me it was a 17a1:0128 device, for
> which the gspca_t613 module is available. But it did not recognize the
> sensor number, 0x0802.
>
> I fiddled with the driver source code, and just made it recognize it
> as a 0x0803 sensor, called "others" in the code, and I did get images
> from the camera. But the colors are extremely wrong, like the contrast
> was set to a very high number. It's probably some soft of color
> encoding gone wrong...
>
> How can I start hacking this driver to try to make my camera work
> under Linux?
>

If possible you could open the camera to investigate if there is
anything printed on the sensor chip. This might give you a clue to
what sensor it is.

Best regards,
Erik

Ps. This mailing list is deprecated, use linux-media@vger.kernel.org instead.

> Thanks,
>  ++nicolau
>
>
>
> --
> Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
> http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
> Linux user #460716
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkr9tK0ACgkQ0rVki0eJAyeHIwCfXRAkTzirALNp/+F2TGlu6E8+
> jycAnA4IIh30NnZFxDB/M0da0OiSLmFI
> =OfDV
> -----END PGP SIGNATURE-----
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
