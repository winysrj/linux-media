Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:36336 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753537AbeGESE2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 14:04:28 -0400
Subject: Re: Video capturing
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
References: <7a41465a-483b-9ce5-4e8f-1f005e2060f9@kaa.org.ua>
 <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
 <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
 <849d57db07c1c1825f0d215a7e55682d36dd2298.camel@ndufresne.ca>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Message-ID: <53aab93d-cd1b-9848-7be8-2cc604c5bd3d@kaa.org.ua>
Date: Thu, 5 Jul 2018 21:04:34 +0300
MIME-Version: 1.0
In-Reply-To: <849d57db07c1c1825f0d215a7e55682d36dd2298.camel@ndufresne.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NlFpFCE93AnksNd26LWY9fCtqHnpaEUuc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NlFpFCE93AnksNd26LWY9fCtqHnpaEUuc
Content-Type: multipart/mixed; boundary="lFlre0kbN4Mp6OhwK0w8Og14rIFuvHoRn";
 protected-headers="v1"
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: DVB_Linux_Media <linux-media@vger.kernel.org>
Message-ID: <53aab93d-cd1b-9848-7be8-2cc604c5bd3d@kaa.org.ua>
Subject: Re: Video capturing
References: <7a41465a-483b-9ce5-4e8f-1f005e2060f9@kaa.org.ua>
 <CAKQmDh-ALkK+6HkzN1SjXgeoGsZNUZYkb__N4063M7U5aRsAnw@mail.gmail.com>
 <b1e0a06c-ee55-252a-ded5-22b421e2a7e5@kaa.org.ua>
 <849d57db07c1c1825f0d215a7e55682d36dd2298.camel@ndufresne.ca>
In-Reply-To: <849d57db07c1c1825f0d215a7e55682d36dd2298.camel@ndufresne.ca>

--lFlre0kbN4Mp6OhwK0w8Og14rIFuvHoRn
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

05.07.18 16:52, Nicolas Dufresne =D0=BF=D0=B8=D1=88=D0=B5:
> Le jeudi 05 juillet 2018 =C3=A0 16:35 +0300, Oleh Kravchenko a =C3=A9cr=
it :
>=20
> And do you get the same with GStreamer ?
> gst-launch-1.0 v4l2src device=3D/dev/video1 norm=3DPAL ! videoconvert !=
 autovideosink

Doesn't work:

$ v4l2-ctl -d /dev/video2 --all
Driver Info (not using libv4l2):
        Driver name   : cx231xx
        Card type     : Astrometa T2hybrid
        Bus info      : usb-0000:01:00.0-7
        Driver version: 4.16.18
        Capabilities  : 0x85200011
                Video Capture
                VBI Capture
                Read/Write
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x05200001
                Video Capture
                Read/Write
                Streaming
                Extended Pix Format
Priority: 2
Video input : 1 (Composite1: no signal, no hsync lock.)
Video Standard =3D 0x000000ff
        PAL-B/B1/G/H/I/D/D1/K
Format Video Capture:
        Width/Height      : 720/576
        Pixel Format      : 'YUYV'
        Field             : Interlaced
        Bytes per Line    : 1440
        Size Image        : 829440
        Colorspace        : SMPTE 170M
        Transfer Function : Default
        YCbCr Encoding    : Default
        Quantization      : Default
        Flags             :=20
Crop Capability Video Capture:
        Bounds      : Left 0, Top 0, Width 720, Height 576
        Default     : Left 0, Top 0, Width 720, Height 576
        Pixel Aspect: 54/59
Streaming Parameters Video Capture:
        Frames per second: 25.000 (25/1)
        Read buffers     : 2

User Controls

                     brightness (int)    : min=3D0 max=3D255 step=3D1 def=
ault=3D128 value=3D128 flags=3Dslider
                       contrast (int)    : min=3D0 max=3D127 step=3D1 def=
ault=3D64 value=3D64 flags=3Dslider
                     saturation (int)    : min=3D0 max=3D127 step=3D1 def=
ault=3D64 value=3D64 flags=3Dslider
                            hue (int)    : min=3D-128 max=3D127 step=3D1 =
default=3D0 value=3D0 flags=3Dslider
                         volume (int)    : min=3D0 max=3D65535 step=3D655=
 default=3D60928 value=3D60928 flags=3Dslider
                        balance (int)    : min=3D0 max=3D65535 step=3D655=
 default=3D32768 value=3D32768 flags=3Dslider
                           bass (int)    : min=3D0 max=3D65535 step=3D655=
 default=3D32768 value=3D32768 flags=3Dslider
                         treble (int)    : min=3D0 max=3D65535 step=3D655=
 default=3D32768 value=3D32768 flags=3Dslider
                           mute (bool)   : default=3D0 value=3D1


$ gst-launch-1.0 v4l2src device=3D/dev/video2 norm=3DPAL ! videoconvert !=
 autovideosink
Setting pipeline to PAUSED ...
ERROR: Pipeline doesn't want to pause.
ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Failed to=
 get setting of tuner 0 on device '/dev/video2'.
Additional debug info:
/tmp/portage/media-plugins/gst-plugins-v4l2-1.12.4/work/gst-plugins-good-=
1.12.4/sys/v4l2/v4l2_calls.c(190): gst_v4l2_fill_lists (): /GstPipeline:p=
ipeline0/GstV4l2Src:v4l2src0:
system error: Inappropriate ioctl for device
Setting pipeline to NULL ...
Freeing pipeline ...

--=20
Best regards,
Oleh Kravchenko



--lFlre0kbN4Mp6OhwK0w8Og14rIFuvHoRn--

--NlFpFCE93AnksNd26LWY9fCtqHnpaEUuc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEC/TM5t+2NenFhW0Q0xNJm20pl4wFAls+XbYACgkQ0xNJm20p
l4walw//Ty6pgcNe47klkBqcKtpvwKjDL9az1PI3VM7ONOgifsLYAm4Qz1me1VDT
ueYuCsQ8yMu+vvjmlzP7ZfaNkWGeKbECvSdcu3AmrTUAeA6tjcJEc3cdRaigt8xR
tri3S2lJuELhDDs0lGBukhoTLqxOuwqscfh4aa4BCChSjt6YK64QDb4ZntS79Zxa
eS5w1TbsGkd4isExjQBa2T2LdPjDGcyKzWCWgtN64ZagjMSyNdUh/Y4p8zVbWFF8
OMTmTAk/QVQdd7TYqBqZ31arxyiEfZCW3KVwmWs5TAlBUfngPereF5sc/K27Ot8I
4rSLIlRQkyMkeWPWk1OTrKdza2+te0XMVsfivOq9KGp0ihrNVpQBXMwGtM7k0oZp
T8BF5cjLpjYlEA2/MYZpQ1zU84w6PPRTQV+KiY+ANxTHDFsI07PETPl0A+4CvF0A
FY/bm739yHsH+8MnhVxQ60qi1IDSkF6bdFvLqbToUuyDWmojn/4OndUceRUWAJ3d
Afa3O8h+GNplbZdNJ8ZYlvSXk1uHqmmqz3amvCFTHYVMY74YU3s2AutiOspbgJrK
crzDbnvUWbyaoaaDyPihTfqaqQH+8NwavK+ARJgsWPT0guzgrLaWvydevlGAz7SN
vsyKl73epqvwlRgIdN1KyWKeLKNPw3wbiVyTos776GFPHzJyl9c=
=WJjg
-----END PGP SIGNATURE-----

--NlFpFCE93AnksNd26LWY9fCtqHnpaEUuc--
