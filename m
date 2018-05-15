Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43904 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbeEOUTz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 16:19:55 -0400
Subject: Re: [PATCH v4 0/6] Asynchronous UVC
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <20180515162233.2937906e@vento.lan>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <91961caf-0f0b-fa58-ea01-b3dd37b67e88@ideasonboard.com>
Date: Tue, 15 May 2018 21:19:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180515162233.2937906e@vento.lan>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Q22FGMRUcTl6nX5baMBsJDOh2P5qK2GmN"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q22FGMRUcTl6nX5baMBsJDOh2P5qK2GmN
Content-Type: multipart/mixed; boundary="GNcDqujzJW4Mg1cCBrkRwBwQNyqNKFVrV";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
 Olivier BRAUN <olivier.braun@stereolabs.com>,
 Troy Kisky <troy.kisky@boundarydevices.com>,
 Randy Dunlap <rdunlap@infradead.org>, Philipp Zabel <philipp.zabel@gmail.com>
Message-ID: <91961caf-0f0b-fa58-ea01-b3dd37b67e88@ideasonboard.com>
Subject: Re: [PATCH v4 0/6] Asynchronous UVC
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com>
 <20180515162233.2937906e@vento.lan>
In-Reply-To: <20180515162233.2937906e@vento.lan>

--GNcDqujzJW4Mg1cCBrkRwBwQNyqNKFVrV
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On 15/05/18 20:22, Mauro Carvalho Chehab wrote:
> Em Tue, 27 Mar 2018 17:45:57 +0100
> Kieran Bingham <kieran.bingham@ideasonboard.com> escreveu:
>=20
>> The Linux UVC driver has long provided adequate performance capabiliti=
es for
>> web-cams and low data rate video devices in Linux while resolutions we=
re low.
>>
>> Modern USB cameras are now capable of high data rates thanks to USB3 w=
ith
>> 1080p, and even 4k capture resolutions supported.
>>
>> Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BR=
IO
>> (isochronous transfers) can generate more data than an embedded ARM co=
re is
>> able to process on a single core, resulting in frame loss.
>>
>> A large part of this performance impact is from the requirement to
>> =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination fr=
ames. This unfortunate
>> requirement is due to the UVC protocol allowing a variable length head=
er, and
>> thus it is not possible to provide the target frame buffers directly.
>>
>> Extra throughput is possible by moving the actual memcpy actions to a =
work
>> queue, and moving the memcpy out of interrupt context thus allowing wo=
rk tasks
>> to be scheduled across multiple cores.
>>
>> This series has been tested on both the ZED and BRIO cameras on arm64
>> platforms, and with thanks to Randy Dunlap, a Dynex 1.3MP Webcam, a So=
nix USB2
>> Camera, and a built in Toshiba Laptop camera, and with thanks to Phili=
pp Zabel
>> for testing on a Lite-On internal Laptop Webcam, Logitech C910 (USB2 i=
soc),
>> Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).=

>>
>> As far as I am aware iSight devices, and devices which use UVC to enco=
de data
>> (output device) have not yet been tested - but should find no ill effe=
ct (at
>> least not until they are tested of course :D )
>>
>> Tested-by: Randy Dunlap <rdunlap@infradead.org>
>> Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
>>
>> v2:
>>  - Fix race reported by Guennadi
>>
>> v3:
>>  - Fix similar race reported by Laurent
>>  - Only queue work if required (encode/isight do not queue work)
>>  - Refactor/Rename variables for clarity
>>
>> v4:
>>  - (Yet another) Rework of the uninitialise path.
>>    This time to hopefully clean up the shutdown races for good.
>>    use usb_poison_urb() to halt all URBs, then flush the work queue
>>    before freeing.
>>  - Rebase to latest linux-media/master
>=20
> Kieran/Laurent,
>=20
> What's the status of this patchset?

I believe v4 was my final version (until someone tells me otherwise), and=
 fixed
all known races. Unless there has been bitrot since I posted  (was last r=
ebased
at v4.16-rc4 ?) ...

It would be good to at least get it in -next for a while if not mainline.=
=2E.

Laurent ?

The latest version is available in a branch at :
  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git uvc/asy=
nc/v4

Let me know if I need to post a rebased version.
--
Kieran


>=20
> Regards,
> Mauro
>=20
>>
>> Kieran Bingham (6):
>>   media: uvcvideo: Refactor URB descriptors
>>   media: uvcvideo: Convert decode functions to use new context structu=
re
>>   media: uvcvideo: Protect queue internals with helper
>>   media: uvcvideo: queue: Simplify spin-lock usage
>>   media: uvcvideo: queue: Support asynchronous buffer handling
>>   media: uvcvideo: Move decode processing to process context
>>
>>  drivers/media/usb/uvc/uvc_isight.c |   6 +-
>>  drivers/media/usb/uvc/uvc_queue.c  | 102 +++++++++++++----
>>  drivers/media/usb/uvc/uvc_video.c  | 180 +++++++++++++++++++++-------=
--
>>  drivers/media/usb/uvc/uvcvideo.h   |  59 ++++++++--
>>  4 files changed, 266 insertions(+), 81 deletions(-)
>>
>> base-commit: a77cfdf6bd06eef0dadea2b541a7c01502b1b4f6
>=20
>=20
>=20
> Thanks,
> Mauro
>=20


--GNcDqujzJW4Mg1cCBrkRwBwQNyqNKFVrV--

--Q22FGMRUcTl6nX5baMBsJDOh2P5qK2GmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlr7QOYACgkQoR5GchCk
Yf06tg/+MNpCR/VlcWTFNDQwprxVYF2uNX3OOv48yNlYX6hvWoBRWqheDNEFHN9X
+93G4bj66ggm4IDuTYlvJ/rVgZl3+T4lLXEUXqZFEnKoyuhcYOcEvgqtX2b78c+1
iSwCgdvS1QEHHIC1bsVN5+0cMce6pTkTXssV7L79S/n+xuBhr0+IZ2NhNrvt9ExG
wEJadG3yV7fK+9JDf/u0CCBBuYb+L9WbdeTOvREvD/DpLsPu1yaou7XbLpbZfOn7
To2Q1QItZaUnryFOltic+ksJNcPWUsrH7N81sQTbzisBLLY6RR6Dlezyk7Q2zTFy
gJA/A8QwVCHiTBSbC04hsfiHrmuVskTQPefUBrnQMc4jznI9dpOWtJzh+HATC+jD
4NjCkGD9T6t4ieNB+rvIxudQtYBHGoPBAFU5z6NA4+B0+yH0mh999KRNbqASXsMR
0u8QRPAglUVMlJeW4il6jPmUt89yciFbQx+HxnodMONyUucXBqrb+9zzLJEQ+U8V
q1aCBxpxVxDqVNVguVpxmso1++YYb0gxxgLGVkVuwBD4/7bR6zXy5kf9BLhVko28
6/weWDyijRt9px7J9qB+4Vvh6bMDTFTzk/MRiXWDFCzjujrSzjZ8OM/EGeG5XTbJ
+eg5G5FmeKkCC49rHtGvjmNe6k28JZJqHLuZuaTUhz2jtxByIDw=
=9B6Y
-----END PGP SIGNATURE-----

--Q22FGMRUcTl6nX5baMBsJDOh2P5qK2GmN--
