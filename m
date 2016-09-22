Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:37141 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbcIVHiJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 03:38:09 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Bin Liu <b-liu@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <20160921132702.GA18578@uda0271908>
References: <20160920170441.GA10705@uda0271908> <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908>
Date: Thu, 22 Sep 2016 10:37:06 +0300
Message-ID: <87oa3go065.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Bin Liu <b-liu@ti.com> writes:
> On Wed, Sep 21, 2016 at 11:01:21AM +0300, Felipe Balbi wrote:
>>=20
>> Hi,
>>=20
>> Bin Liu <b-liu@ti.com> writes:
>> > Hi,
>> >
>> > I am trying to check Isoch high bandwidth transfer with g_webcam.ko in
>> >  high-speed connection.
>> >
>> > First I hacked webcam.c as follows to enable 640x480@30fps mode.
>> >
>> > diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/l=
egacy/webcam.c
>> > index 72c976b..9eb315f 100644
>> > --- a/drivers/usb/gadget/legacy/webcam.c
>> > +++ b/drivers/usb/gadget/legacy/webcam.c
>> > @@ -191,15 +191,15 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) uv=
c_frame_yuv_360p =3D {
>> >         .bFrameIndex            =3D 1,
>> >         .bmCapabilities         =3D 0,
>> >         .wWidth                 =3D cpu_to_le16(640),
>> > -       .wHeight                =3D cpu_to_le16(360),
>> > +       .wHeight                =3D cpu_to_le16(480),
>> >         .dwMinBitRate           =3D cpu_to_le32(18432000),
>> >         .dwMaxBitRate           =3D cpu_to_le32(55296000),
>> > -       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(460800),
>> > -       .dwDefaultFrameInterval =3D cpu_to_le32(666666),
>> > +       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(614400),
>> > +       .dwDefaultFrameInterval =3D cpu_to_le32(333333),
>> >         .bFrameIntervalType     =3D 3,
>> > -       .dwFrameInterval[0]     =3D cpu_to_le32(666666),
>> > -       .dwFrameInterval[1]     =3D cpu_to_le32(1000000),
>> > -       .dwFrameInterval[2]     =3D cpu_to_le32(5000000),
>> > +       .dwFrameInterval[0]     =3D cpu_to_le32(333333),
>> > +       .dwFrameInterval[1]     =3D cpu_to_le32(666666),
>> > +       .dwFrameInterval[2]     =3D cpu_to_le32(1000000),
>> >  };
>> >
>> > then loaded g_webcam.ko as
>> >
>> > # modprobe g_webcam streaming_maxpacket=3D3072
>> >
>> > The endpoint descriptor showing on the host is
>> >
>> >       Endpoint Descriptor:
>> >         bLength                 7
>> >         bDescriptorType         5
>> >         bEndpointAddress     0x8d  EP 13 IN
>> >         bmAttributes            5
>> >           Transfer Type            Isochronous
>> >           Synch Type               Asynchronous
>> >           Usage Type               Data
>> >         wMaxPacketSize     0x1400  3x 1024 bytes
>> >         bInterval               1
>> >
>> > However the usb bus trace shows only one transaction with 1024-bytes p=
acket in
>> > every SOF. The host only sends one IN packet in every SOF, I am expect=
ing 2~3
>> > 1024-bytes transactions, since this would be required to transfer 640x=
480@30fps
>> > YUV frames in high-speed.
>> >
>> > DId I miss anything in the setup?
>>=20
>> MUSB or DWC3? This looks like a UDC bug to me. Can you show a screenshot
>
> Happened on both MUSB and DWC3.
>
>> of your bus analyzer? When host sends IN token, are you replying with
>
> The trace screenshot on DWC3 is attached.
>
>> DATA0, DATA1 or DATA2?
>
> Good hint! It is DATA0!

yeah, should've been DATA2. I'll check if we're missing anything for
High Bandwidth Iso on DWC3. Can you confirm if it works of tails on
DWC3? On your follow-up mail you mentioned it's a bug in MUSB. What
about DWC3?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX44oiAAoJEMy+uJnhGpkGQ8sQALMDkVl/ROg3ELm0oxJMrQd0
hMQTV/uFTnKGPZI//O7SUIg5YT5+18E3L1CMDW8ybF0nHEyKKIA57Br6d9P3iTGl
e/1ls30ied3+5VvBDWj1i1HarwETn4Ya9qydg4f5PUWt0XEsrarlUUAHRQKuoytO
aZPx4FSwfExnluCg510oQGPrB0GoyJjZe/zXZkmlXD3VWHutU+NzirEFfWdPPoeE
nZunkoBiBNIApq3MWY8GOLj2QNRINHMcY2sYDhrCilZ/lx+2JDdTIpBIjA+BRAW7
BZUCEjHcHSV9vhLAiWyj9AfHPwp27JvpYmaMj3/kM0d3Wu9MwFepYQiL54+nkxrA
oQ3fIj9owq0mSCwebybsIhEz/you7eQ7LMbdNmKlyr44SA4FuRRshG70I/TTvcLJ
mbvq9qsRcLEhkyOpQORla2a5p1aqwxrlp0gMaS602NaQMHXqvIYz2+qpD2mGKCEN
c8HIZlwtUIN/r71eHlcQtktXO18kBdrjDJ4DdFkIofEbNOuuHTQ2NTH4Ic+icbtR
N9e5VyVRG9VDnsF1VCSN2zvJsAvb2N+rgtdg8zvUPOljgkphLFu9meGJ1DctLQ2M
wFFdNuhY1jVkgHYlhy82QxXaB+SAioykMZ9RtPZqRzx3DyosMNXZIcDd74TK5ZkH
sfzwpqWBCt+M0jeln44y
=RGga
-----END PGP SIGNATURE-----
--=-=-=--
