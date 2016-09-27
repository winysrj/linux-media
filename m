Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:45257 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbcI0HKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 03:10:41 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: yfw <nh26223@gmail.com>, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <1685763.WH6ULF9Rxs@avalon>
References: <20160920170441.GA10705@uda0271908> <b73898d0-b5ff-d591-0946-acf127453aba@gmail.com> <87k2e358cx.fsf@linux.intel.com> <1685763.WH6ULF9Rxs@avalon>
Date: Tue, 27 Sep 2016 10:10:24 +0300
Message-ID: <87lgyd4y3j.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:
> Hi Felipe,
>
> On Friday 23 Sep 2016 11:27:26 Felipe Balbi wrote:
>> yfw <nh26223@gmail.com> writes:
>> >>>>>> Here's one that actually compiles, sorry about that.
>> >>>>>=20
>> >>>>> No worries, I was sleeping ;-)
>> >>>>>=20
>> >>>>> I will test it out early next week. Thanks.
>> >>>>=20
>> >>>> meanwhile, how about some instructions on how to test this out myse=
lf?
>> >>>> How are you using g_webcam and what are you running on host side? G=
ot a
>> >>>> nice list of commands there I can use? I think I can get to bottom =
of
>> >>>> this much quicker if I can reproduce it locally ;-)
>> >>>=20
>> >>> On device side:
>> >>> - first patch g_webcam as in my first email in this thread to enable
>> >>>   640x480@30fps;
>> >>> - # modprobe g_webcam streaming_maxpacket=3D3072
>> >>> - then run uvc-gadget to feed the YUV frames;
>> >>> 	http://git.ideasonboard.org/uvc-gadget.git
>> >>=20
>> >> as is, g_webcam never enumerates to the host. It's calls to
>> >> usb_function_active() and usb_function_deactivate() are unbalanced. Do
>> >> you have any other changes to g_webcam?
>> >=20
>> > With uvc function gadget driver, user daemon uvc-gadget must be started
>> > before connect to host. Not sure whether g_webcam has same requirement.
>>=20
>> f_uvc.c should be handling that by means for usb_function_deactivate().
>>=20
>> I'll try keeping cable disconnected until uvc-gadget is running.
>
> Things might have changed since we've discussed the issue several years a=
go,=20
> but back then at least the musb UDC started unconditionally connected.

That's kinda of not the case anymore. We deactivate during function
registration if a certain flag is set.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX6htgAAoJEMy+uJnhGpkGp4UQAMil4N3G0adrPlb8nR2mJjer
Y6t3eyyjzcqPLL4krnXWhhTzDQ0V0CYrC63frRZ6c//MEZ0J+EAeqa0goMwzqoLm
mqRh32Zz4V+C/XS0vwVTGCUx/ouzmMZXwfkHi4FRPbOYwuswPjZvd1P++qyzGZDi
/ljFNHpGdt7nf8Zc/PdPoozwVyu7Vy8ql076GQX0MS7NckzyQasSevpw0YiWLjVK
ja8whZG0NM5n3gPmXxFmUsDp1uMKIPJeIoYDEfbPLsfFXmMJiBo2Qa89dCw2UYAi
qu3TFsfoaZfCUsC8UPGehRj9sVAiYacrlbYlTuTLXbUYf4IWqRwdURTXOYL0RhSe
ZlrchouKVR/qVKZKCcoVtTN/HVCM2+5qDW+YtljjQijRp1SJ6rFFTZsbNqQxa3po
1VnGAKNf+geJvdXCzkd4kgL0lGpOoyW88P3GfQmBi1EZ+obkF+LqFrO7ZVOnPBGy
HhWyqaMmBdhiSCy3NQfRVZAMdba0LufCfA9uQNj+fmOANfLKZqLf46d6/u5Lruhl
BNFPa7k8P4PYilBn7v6MfqL9egbA+0AYRW1uBvIu4cmKgruBPNuBlfm5DHO81Eom
inbSxp8cUImtIiX/o5OE3eJKOxPuoN3cVc6LAcgMDtBw0aEgGQsN2yqEjYwOaJ3S
aGRtLwdwT1atQJf52y1b
=/RZF
-----END PGP SIGNATURE-----
--=-=-=--
