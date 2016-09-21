Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47007 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752548AbcIUIB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 04:01:29 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Bin Liu <b-liu@ti.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <20160920170441.GA10705@uda0271908>
References: <20160920170441.GA10705@uda0271908>
Date: Wed, 21 Sep 2016 11:01:21 +0300
Message-ID: <871t0d4r72.fsf@linux.intel.com>
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
> Hi,
>
> I am trying to check Isoch high bandwidth transfer with g_webcam.ko in
>  high-speed connection.
>
> First I hacked webcam.c as follows to enable 640x480@30fps mode.
>
> diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/lega=
cy/webcam.c
> index 72c976b..9eb315f 100644
> --- a/drivers/usb/gadget/legacy/webcam.c
> +++ b/drivers/usb/gadget/legacy/webcam.c
> @@ -191,15 +191,15 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) uvc_f=
rame_yuv_360p =3D {
>         .bFrameIndex            =3D 1,
>         .bmCapabilities         =3D 0,
>         .wWidth                 =3D cpu_to_le16(640),
> -       .wHeight                =3D cpu_to_le16(360),
> +       .wHeight                =3D cpu_to_le16(480),
>         .dwMinBitRate           =3D cpu_to_le32(18432000),
>         .dwMaxBitRate           =3D cpu_to_le32(55296000),
> -       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(460800),
> -       .dwDefaultFrameInterval =3D cpu_to_le32(666666),
> +       .dwMaxVideoFrameBufferSize      =3D cpu_to_le32(614400),
> +       .dwDefaultFrameInterval =3D cpu_to_le32(333333),
>         .bFrameIntervalType     =3D 3,
> -       .dwFrameInterval[0]     =3D cpu_to_le32(666666),
> -       .dwFrameInterval[1]     =3D cpu_to_le32(1000000),
> -       .dwFrameInterval[2]     =3D cpu_to_le32(5000000),
> +       .dwFrameInterval[0]     =3D cpu_to_le32(333333),
> +       .dwFrameInterval[1]     =3D cpu_to_le32(666666),
> +       .dwFrameInterval[2]     =3D cpu_to_le32(1000000),
>  };
>
> then loaded g_webcam.ko as
>
> # modprobe g_webcam streaming_maxpacket=3D3072
>
> The endpoint descriptor showing on the host is
>
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x8d  EP 13 IN
>         bmAttributes            5
>           Transfer Type            Isochronous
>           Synch Type               Asynchronous
>           Usage Type               Data
>         wMaxPacketSize     0x1400  3x 1024 bytes
>         bInterval               1
>
> However the usb bus trace shows only one transaction with 1024-bytes pack=
et in
> every SOF. The host only sends one IN packet in every SOF, I am expecting=
 2~3
> 1024-bytes transactions, since this would be required to transfer 640x480=
@30fps
> YUV frames in high-speed.
>
> DId I miss anything in the setup?

MUSB or DWC3? This looks like a UDC bug to me. Can you show a screenshot
of your bus analyzer? When host sends IN token, are you replying with
DATA0, DATA1 or DATA2?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX4j5RAAoJEMy+uJnhGpkGARIP/jTyBFWM1nlmVdyl3loYukP8
tUSZ8LCD+5YHvP9GFqg53YxjTkJBIa/jb8A6UXZ5h4Y2mFr3uB2iLVopXkHpyTj3
dZodqfb3uWkQ8itoEyqlRTuvNlpdCSupCzlo4nhxmC6+y2njP5layP6eOWXu3AYR
1Fuyhw6mAVYh5H+SM2uZEPijGmkojPRw2BPBivFyLHYY2QBUFx7EOKhZwbVR/ra+
D+zvzKpm+p8BTXt2Kw25bjEjkLt6Yxqzs2aFGTNS/mQB6kL75mg51n0a7nBLlE+o
p2Ag5wNPXQLvNFqoK8U2BQ3FxE80b9lN8pnwNzcsEm4yCb2tWDj1pAXpeonJUN31
bs+emboQXBMeL7vVSQ55VDkaKNdB0vgFjF0H4pYTVNNLH8+622+Gcv6OJZnhhcgE
sNtn/xpfSUgwyraxWw3nQ7DFIeVzg6wLEHg8cdNG/KePLQ3qmw8f4Anun2mNoWBk
i/ZtiyBiEFtkkRalh2UpbGjYdl8i6fMykzBmeXcubAAc86iUGboSjJxnhMntgwFE
6laZkYY8KyePknL+AZSxyaoA7dRUOD568+0QBlFhyxG4xPDdiAzBTOV5UzQisiRa
LQLg107y2dSlCgzigMb7NPoSUbfyI/rebjPBtcl0dkdBebFFnyMljGB9Mc1xcGPt
koFfcEeNapB7YLvfrJMr
=H+Cx
-----END PGP SIGNATURE-----
--=-=-=--
