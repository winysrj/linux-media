Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:42557 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab0JFOEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 10:04:53 -0400
Date: Wed, 6 Oct 2010 16:04:41 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-Id: <20101006160441.6ee9583d.ospite@studenti.unina.it>
In-Reply-To: <20101006134855.43879d74@tele>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_16_04_41_+0200_mHK/xQ8KF+JVamhN"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Wed__6_Oct_2010_16_04_41_+0200_mHK/xQ8KF+JVamhN
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__6_Oct_2010_16_04_41_+0200_gsPZwTn=SghI+OF/"


--Multipart=_Wed__6_Oct_2010_16_04_41_+0200_gsPZwTn=SghI+OF/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Oct 2010 13:48:55 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 6 Oct 2010 12:33:21 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > with 2.6.36-rc6 I can't use the ov534 gspca subdriver (with PS3 eye)
> > anymore, when I try to capture video in dmesg I get:
> > gspca: no transfer endpoint found
> >=20
> > If I revert commit 35680ba I can make video capture work again but I
> > still don't get the audio device in pulseaudio, it shows up in
> > alsamixer but if I try to select it, on the console I get:
> > cannot load mixer controls: Invalid argument
> >=20
[...]
>=20
> I think I see why the commit prevents the webcam to work: as it is
> done, the choice of the alternate setting does not work with bulk
> transfer. A simple fix could be to also check bulk transfer when
> skipping an alt setting in the function get_ep().
>

Thanks, the following change fixes it, was this what you had in mind?

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/=
gspca.c
index b984610..30e0b32 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -651,7 +651,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_de=
v *gspca_dev)
                                   : USB_ENDPOINT_XFER_ISOC;
        i =3D gspca_dev->alt;                     /* previous alt setting */
        if (gspca_dev->cam.reverse_alts) {
-               if (gspca_dev->audio)
+               if (gspca_dev->audio && !gspca_dev->cam.bulk)
                        i++;
                while (++i < gspca_dev->nbalt) {
                        ep =3D alt_xfer(&intf->altsetting[i], xfer);
@@ -659,7 +659,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_de=
v *gspca_dev)
                                break;
                }
        } else {
-               if (gspca_dev->audio)
+               if (gspca_dev->audio && !gspca_dev->cam.bulk)
                        i--;
                while (--i >=3D 0) {
                        ep =3D alt_xfer(&intf->altsetting[i], xfer);


> About audio stream, I do not see how it can have been broken.
>

PS3 Eye audio is working with linux-2.6.33.7 it is broken in
linux-2.6.35.7 already, I'll try to further narrow down the interval.
Ah, alsamixer doesn't work even when the device is OK in pulseaudio...

> Might you send me the full USB information of your webcam?
>

You can find lsusb output attached.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Multipart=_Wed__6_Oct_2010_16_04_41_+0200_gsPZwTn=SghI+OF/
Content-Type: application/octet-stream;
 name="lsusb_pseye.log"
Content-Disposition: attachment;
 filename="lsusb_pseye.log"
Content-Transfer-Encoding: base64

CkJ1cyAwMDEgRGV2aWNlIDAwNDogSUQgMTQxNToyMDAwIE5hbSBUYWkgRSZFIFByb2R1Y3RzIEx0
ZC4gb3IgT21uaVZpc2lvbiBUZWNobm9sb2dpZXMsIEluYy4gU29ueSBQbGF5c3RhdGlvbiBFeWUK
RGV2aWNlIERlc2NyaXB0b3I6CiAgYkxlbmd0aCAgICAgICAgICAgICAgICAxOAogIGJEZXNjcmlw
dG9yVHlwZSAgICAgICAgIDEKICBiY2RVU0IgICAgICAgICAgICAgICAyLjAwCiAgYkRldmljZUNs
YXNzICAgICAgICAgICAgMCAoRGVmaW5lZCBhdCBJbnRlcmZhY2UgbGV2ZWwpCiAgYkRldmljZVN1
YkNsYXNzICAgICAgICAgMCAKICBiRGV2aWNlUHJvdG9jb2wgICAgICAgICAwIAogIGJNYXhQYWNr
ZXRTaXplMCAgICAgICAgNjQKICBpZFZlbmRvciAgICAgICAgICAgMHgxNDE1IE5hbSBUYWkgRSZF
IFByb2R1Y3RzIEx0ZC4gb3IgT21uaVZpc2lvbiBUZWNobm9sb2dpZXMsIEluYy4KICBpZFByb2R1
Y3QgICAgICAgICAgMHgyMDAwIFNvbnkgUGxheXN0YXRpb24gRXllCiAgYmNkRGV2aWNlICAgICAg
ICAgICAgMS4wMAogIGlNYW51ZmFjdHVyZXIgICAgICAgICAgIDEgT21uaVZpc2lvbiBUZWNobm9s
b2dpZXMsIEluYy4KICBpUHJvZHVjdCAgICAgICAgICAgICAgICAyIFVTQiBDYW1lcmEtQjQuMDQu
MjcuMQogIGlTZXJpYWwgICAgICAgICAgICAgICAgIDAgCiAgYk51bUNvbmZpZ3VyYXRpb25zICAg
ICAgMQogIENvbmZpZ3VyYXRpb24gRGVzY3JpcHRvcjoKICAgIGJMZW5ndGggICAgICAgICAgICAg
ICAgIDkKICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDIKICAgIHdUb3RhbExlbmd0aCAgICAg
ICAgICAxNDIKICAgIGJOdW1JbnRlcmZhY2VzICAgICAgICAgIDMKICAgIGJDb25maWd1cmF0aW9u
VmFsdWUgICAgIDEKICAgIGlDb25maWd1cmF0aW9uICAgICAgICAgIDAgCiAgICBibUF0dHJpYnV0
ZXMgICAgICAgICAweDgwCiAgICAgIChCdXMgUG93ZXJlZCkKICAgIE1heFBvd2VyICAgICAgICAg
ICAgICA1MDBtQQogICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAgICAgIGJMZW5ndGggICAgICAg
ICAgICAgICAgIDkKICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgNAogICAgICBiSW50ZXJm
YWNlTnVtYmVyICAgICAgICAwCiAgICAgIGJBbHRlcm5hdGVTZXR0aW5nICAgICAgIDAKICAgICAg
Yk51bUVuZHBvaW50cyAgICAgICAgICAgMwogICAgICBiSW50ZXJmYWNlQ2xhc3MgICAgICAgMjU1
IFZlbmRvciBTcGVjaWZpYyBDbGFzcwogICAgICBiSW50ZXJmYWNlU3ViQ2xhc3MgICAgICAwIAog
ICAgICBiSW50ZXJmYWNlUHJvdG9jb2wgICAgICAwIAogICAgICBpSW50ZXJmYWNlICAgICAgICAg
ICAgICAwIAogICAgICBFbmRwb2ludCBEZXNjcmlwdG9yOgogICAgICAgIGJMZW5ndGggICAgICAg
ICAgICAgICAgIDcKICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA1CiAgICAgICAgYkVu
ZHBvaW50QWRkcmVzcyAgICAgMHg4MSAgRVAgMSBJTgogICAgICAgIGJtQXR0cmlidXRlcyAgICAg
ICAgICAgIDIKICAgICAgICAgIFRyYW5zZmVyIFR5cGUgICAgICAgICAgICBCdWxrCiAgICAgICAg
ICBTeW5jaCBUeXBlICAgICAgICAgICAgICAgTm9uZQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAg
ICAgICAgICAgIERhdGEKICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMjAwICAxeCA1MTIg
Ynl0ZXMKICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgICAwCiAgICAgIEVuZHBvaW50IERl
c2NyaXB0b3I6CiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNwogICAgICAgIGJEZXNj
cmlwdG9yVHlwZSAgICAgICAgIDUKICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDAyICBF
UCAyIE9VVAogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDIKICAgICAgICAgIFRyYW5z
ZmVyIFR5cGUgICAgICAgICAgICBCdWxrCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAgICAgICAg
ICAgTm9uZQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAgIERhdGEKICAgICAgICB3
TWF4UGFja2V0U2l6ZSAgICAgMHgwMjAwICAxeCA1MTIgYnl0ZXMKICAgICAgICBiSW50ZXJ2YWwg
ICAgICAgICAgICAgICAwCiAgICAgIEVuZHBvaW50IERlc2NyaXB0b3I6CiAgICAgICAgYkxlbmd0
aCAgICAgICAgICAgICAgICAgNwogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUKICAg
ICAgICBiRW5kcG9pbnRBZGRyZXNzICAgICAweDgzICBFUCAzIElOCiAgICAgICAgYm1BdHRyaWJ1
dGVzICAgICAgICAgICAgMwogICAgICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAgICAgIEludGVy
cnVwdAogICAgICAgICAgU3luY2ggVHlwZSAgICAgICAgICAgICAgIE5vbmUKICAgICAgICAgIFVz
YWdlIFR5cGUgICAgICAgICAgICAgICBEYXRhCiAgICAgICAgd01heFBhY2tldFNpemUgICAgIDB4
MDA0MCAgMXggNjQgYnl0ZXMKICAgICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgIDEwCiAgICBJ
bnRlcmZhY2UgRGVzY3JpcHRvcjoKICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQogICAg
ICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0CiAgICAgIGJJbnRlcmZhY2VOdW1iZXIgICAgICAg
IDEKICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAgMAogICAgICBiTnVtRW5kcG9pbnRzICAg
ICAgICAgICAwCiAgICAgIGJJbnRlcmZhY2VDbGFzcyAgICAgICAgIDEgQXVkaW8KICAgICAgYklu
dGVyZmFjZVN1YkNsYXNzICAgICAgMSBDb250cm9sIERldmljZQogICAgICBiSW50ZXJmYWNlUHJv
dG9jb2wgICAgICAwIAogICAgICBpSW50ZXJmYWNlICAgICAgICAgICAgICAwIAogICAgICBBdWRp
b0NvbnRyb2wgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAgICAgICAgYkxlbmd0aCAgICAgICAgICAg
ICAgICAgOQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgMzYKICAgICAgICBiRGVzY3Jp
cHRvclN1YnR5cGUgICAgICAxIChIRUFERVIpCiAgICAgICAgYmNkQURDICAgICAgICAgICAgICAg
MS4wMAogICAgICAgIHdUb3RhbExlbmd0aCAgICAgICAgICAgNDIKICAgICAgICBiSW5Db2xsZWN0
aW9uICAgICAgICAgICAxCiAgICAgICAgYmFJbnRlcmZhY2VOciggMCkgICAgICAgMgogICAgICBB
dWRpb0NvbnRyb2wgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAgICAgICAgYkxlbmd0aCAgICAgICAg
ICAgICAgICAxMgogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgMzYKICAgICAgICBiRGVz
Y3JpcHRvclN1YnR5cGUgICAgICAyIChJTlBVVF9URVJNSU5BTCkKICAgICAgICBiVGVybWluYWxJ
RCAgICAgICAgICAgICAxCiAgICAgICAgd1Rlcm1pbmFsVHlwZSAgICAgIDB4MDIwMSBNaWNyb3Bo
b25lCiAgICAgICAgYkFzc29jVGVybWluYWwgICAgICAgICAgMgogICAgICAgIGJOckNoYW5uZWxz
ICAgICAgICAgICAgIDQKICAgICAgICB3Q2hhbm5lbENvbmZpZyAgICAgMHgwMDAwCiAgICAgICAg
aUNoYW5uZWxOYW1lcyAgICAgICAgICAgMCAKICAgICAgICBpVGVybWluYWwgICAgICAgICAgICAg
ICAwIAogICAgICBBdWRpb0NvbnRyb2wgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAgICAgICAgYkxl
bmd0aCAgICAgICAgICAgICAgICAgOQogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgMzYK
ICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAzIChPVVRQVVRfVEVSTUlOQUwpCiAgICAg
ICAgYlRlcm1pbmFsSUQgICAgICAgICAgICAgMgogICAgICAgIHdUZXJtaW5hbFR5cGUgICAgICAw
eDAxMDEgVVNCIFN0cmVhbWluZwogICAgICAgIGJBc3NvY1Rlcm1pbmFsICAgICAgICAgIDEKICAg
ICAgICBiU291cmNlSUQgICAgICAgICAgICAgICAzCiAgICAgICAgaVRlcm1pbmFsICAgICAgICAg
ICAgICAgMCAKICAgICAgQXVkaW9Db250cm9sIEludGVyZmFjZSBEZXNjcmlwdG9yOgogICAgICAg
IGJMZW5ndGggICAgICAgICAgICAgICAgMTIKICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAg
IDM2CiAgICAgICAgYkRlc2NyaXB0b3JTdWJ0eXBlICAgICAgNiAoRkVBVFVSRV9VTklUKQogICAg
ICAgIGJVbml0SUQgICAgICAgICAgICAgICAgIDMKICAgICAgICBiU291cmNlSUQgICAgICAgICAg
ICAgICAxCiAgICAgICAgYkNvbnRyb2xTaXplICAgICAgICAgICAgMQogICAgICAgIGJtYUNvbnRy
b2xzKCAwKSAgICAgIDB4MDAKICAgICAgICBibWFDb250cm9scyggMSkgICAgICAweDAyCiAgICAg
ICAgICBWb2x1bWUKICAgICAgICBibWFDb250cm9scyggMikgICAgICAweDAyCiAgICAgICAgICBW
b2x1bWUKICAgICAgICBibWFDb250cm9scyggMykgICAgICAweDAyCiAgICAgICAgICBWb2x1bWUK
ICAgICAgICBibWFDb250cm9scyggNCkgICAgICAweDAyCiAgICAgICAgICBWb2x1bWUKICAgICAg
ICBpRmVhdHVyZSAgICAgICAgICAgICAgICAwIAogICAgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAg
ICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkKICAgICAgYkRlc2NyaXB0b3JUeXBlICAgICAg
ICAgNAogICAgICBiSW50ZXJmYWNlTnVtYmVyICAgICAgICAyCiAgICAgIGJBbHRlcm5hdGVTZXR0
aW5nICAgICAgIDAKICAgICAgYk51bUVuZHBvaW50cyAgICAgICAgICAgMAogICAgICBiSW50ZXJm
YWNlQ2xhc3MgICAgICAgICAxIEF1ZGlvCiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAgIDIg
U3RyZWFtaW5nCiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAgIDAgCiAgICAgIGlJbnRlcmZh
Y2UgICAgICAgICAgICAgIDAgCiAgICBJbnRlcmZhY2UgRGVzY3JpcHRvcjoKICAgICAgYkxlbmd0
aCAgICAgICAgICAgICAgICAgOQogICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgICA0CiAgICAg
IGJJbnRlcmZhY2VOdW1iZXIgICAgICAgIDIKICAgICAgYkFsdGVybmF0ZVNldHRpbmcgICAgICAg
MQogICAgICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAxCiAgICAgIGJJbnRlcmZhY2VDbGFzcyAg
ICAgICAgIDEgQXVkaW8KICAgICAgYkludGVyZmFjZVN1YkNsYXNzICAgICAgMiBTdHJlYW1pbmcK
ICAgICAgYkludGVyZmFjZVByb3RvY29sICAgICAgMCAKICAgICAgaUludGVyZmFjZSAgICAgICAg
ICAgICAgMCAKICAgICAgQXVkaW9TdHJlYW1pbmcgSW50ZXJmYWNlIERlc2NyaXB0b3I6CiAgICAg
ICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNwogICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAg
ICAgMzYKICAgICAgICBiRGVzY3JpcHRvclN1YnR5cGUgICAgICAxIChBU19HRU5FUkFMKQogICAg
ICAgIGJUZXJtaW5hbExpbmsgICAgICAgICAgIDIKICAgICAgICBiRGVsYXkgICAgICAgICAgICAg
ICAgICAxIGZyYW1lcwogICAgICAgIHdGb3JtYXRUYWcgICAgICAgICAgICAgIDEgUENNCiAgICAg
IEF1ZGlvU3RyZWFtaW5nIEludGVyZmFjZSBEZXNjcmlwdG9yOgogICAgICAgIGJMZW5ndGggICAg
ICAgICAgICAgICAgMTEKICAgICAgICBiRGVzY3JpcHRvclR5cGUgICAgICAgIDM2CiAgICAgICAg
YkRlc2NyaXB0b3JTdWJ0eXBlICAgICAgMiAoRk9STUFUX1RZUEUpCiAgICAgICAgYkZvcm1hdFR5
cGUgICAgICAgICAgICAgMSAoRk9STUFUX1RZUEVfSSkKICAgICAgICBiTnJDaGFubmVscyAgICAg
ICAgICAgICA0CiAgICAgICAgYlN1YmZyYW1lU2l6ZSAgICAgICAgICAgMgogICAgICAgIGJCaXRS
ZXNvbHV0aW9uICAgICAgICAgMTYKICAgICAgICBiU2FtRnJlcVR5cGUgICAgICAgICAgICAxIERp
c2NyZXRlCiAgICAgICAgdFNhbUZyZXFbIDBdICAgICAgICAxNjAwMAogICAgICBFbmRwb2ludCBE
ZXNjcmlwdG9yOgogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDkKICAgICAgICBiRGVz
Y3JpcHRvclR5cGUgICAgICAgICA1CiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4NCAg
RVAgNCBJTgogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDUKICAgICAgICAgIFRyYW5z
ZmVyIFR5cGUgICAgICAgICAgICBJc29jaHJvbm91cwogICAgICAgICAgU3luY2ggVHlwZSAgICAg
ICAgICAgICAgIEFzeW5jaHJvbm91cwogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAg
IERhdGEKICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMzAwICAxeCA3NjggYnl0ZXMKICAg
ICAgICBiSW50ZXJ2YWwgICAgICAgICAgICAgICA0CiAgICAgICAgYlJlZnJlc2ggICAgICAgICAg
ICAgICAgMAogICAgICAgIGJTeW5jaEFkZHJlc3MgICAgICAgICAgIDAKICAgICAgICBBdWRpb0Nv
bnRyb2wgRW5kcG9pbnQgRGVzY3JpcHRvcjoKICAgICAgICAgIGJMZW5ndGggICAgICAgICAgICAg
ICAgIDcKICAgICAgICAgIGJEZXNjcmlwdG9yVHlwZSAgICAgICAgMzcKICAgICAgICAgIGJEZXNj
cmlwdG9yU3VidHlwZSAgICAgIDEgKEVQX0dFTkVSQUwpCiAgICAgICAgICBibUF0dHJpYnV0ZXMg
ICAgICAgICAweDAxCiAgICAgICAgICAgIFNhbXBsaW5nIEZyZXF1ZW5jeQogICAgICAgICAgYkxv
Y2tEZWxheVVuaXRzICAgICAgICAgMCBVbmRlZmluZWQKICAgICAgICAgIHdMb2NrRGVsYXkgICAg
ICAgICAgICAgIDAgVW5kZWZpbmVkCkRldmljZSBRdWFsaWZpZXIgKGZvciBvdGhlciBkZXZpY2Ug
c3BlZWQpOgogIGJMZW5ndGggICAgICAgICAgICAgICAgMTAKICBiRGVzY3JpcHRvclR5cGUgICAg
ICAgICA2CiAgYmNkVVNCICAgICAgICAgICAgICAgMi4wMAogIGJEZXZpY2VDbGFzcyAgICAgICAg
ICAgIDAgKERlZmluZWQgYXQgSW50ZXJmYWNlIGxldmVsKQogIGJEZXZpY2VTdWJDbGFzcyAgICAg
ICAgIDAgCiAgYkRldmljZVByb3RvY29sICAgICAgICAgMCAKICBiTWF4UGFja2V0U2l6ZTAgICAg
ICAgIDY0CiAgYk51bUNvbmZpZ3VyYXRpb25zICAgICAgMQpEZXZpY2UgU3RhdHVzOiAgICAgMHgw
MDAwCiAgKEJ1cyBQb3dlcmVkKQo=

--Multipart=_Wed__6_Oct_2010_16_04_41_+0200_gsPZwTn=SghI+OF/--

--Signature=_Wed__6_Oct_2010_16_04_41_+0200_mHK/xQ8KF+JVamhN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkysgfkACgkQ5xr2akVTsAG3JQCfRX4gSHOxF3l9YFiAm9HEYTF5
qQAAn2hXJvhVC05KdCSOpEfvXeTnyHTS
=Tqw7
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_16_04_41_+0200_mHK/xQ8KF+JVamhN--
