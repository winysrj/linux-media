Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60598 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbdINK2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:28:30 -0400
Subject: Re: as3645a flash userland interface
To: Pavel Machek <pavel@ucw.cz>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd> <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
 <20170912215529.GA17218@amd> <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
 <CGME20170914092415epcas2p26c049a698851778673034c16afb290b9@epcas2p2.samsung.com>
 <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
 <20170914100718.GA3843@amd>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <fe79ac76-5458-94ca-ba61-b1d57dd7c468@linux.intel.com>
Date: Thu, 14 Sep 2017 13:28:25 +0300
MIME-Version: 1.0
In-Reply-To: <20170914100718.GA3843@amd>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rFGVvDL23ikOeRt0JaKfX988RiQMeOQDP"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rFGVvDL23ikOeRt0JaKfX988RiQMeOQDP
Content-Type: multipart/mixed; boundary="NwRtuWsBTtP1pw2mxu4LG2TQRi1mr3GsV";
 protected-headers="v1"
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>, Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
 laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org, sre@kernel.org
Message-ID: <fe79ac76-5458-94ca-ba61-b1d57dd7c468@linux.intel.com>
Subject: Re: as3645a flash userland interface
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
 <20170912084236.1154-25-sakari.ailus@linux.intel.com>
 <20170912103628.GB27117@amd> <7b679cb3-ce58-e1d1-60bf-995896bf46eb@gmail.com>
 <20170912215529.GA17218@amd> <21824758-28a1-7007-6db5-86a900025d14@gmail.com>
 <CGME20170914092415epcas2p26c049a698851778673034c16afb290b9@epcas2p2.samsung.com>
 <4bf12e8e-beff-0199-cdee-4a52ebe7cdaf@samsung.com>
 <20170914100718.GA3843@amd>
In-Reply-To: <20170914100718.GA3843@amd>

--NwRtuWsBTtP1pw2mxu4LG2TQRi1mr3GsV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Pavel and others,

On 09/14/17 13:07, Pavel Machek wrote:
> Hi!
>=20
>>>>>> What directory are the flash controls in?
>>>>>>
>>>>>> /sys/class/leds/led-controller:flash ?
>>>>>>
>>>>>> Could we arrange for something less generic, like
>>>>>>
>>>>>> /sys/class/leds/main-camera:flash ?
>>>>>
>>>>> I'd rather avoid overcomplicating this. LED class device name patte=
rn
>>>>> is well defined to devicename:colour:function
>>>>> (see Documentation/leds/leds-class.txt, "LED Device Naming" section=
).
>>>>>
>>>>> In this case "flash" in place of the "function" segment makes the
>>>>> things clear enough I suppose.
>>>>
>>>> It does not.
>>>>
>>>> Phones usually have two cameras, front and back, and these days both=

>>>> cameras have their flash.
>>>>
>>>> And poor userspace flashlight application can not know if as3645
>>>> drivers front LED or back LED. Thus, I'd set devicename to
>>>> front-camera or main-camera -- because that's what it is associated
>>>> with. Userspace does not care what hardware drives the LED, but need=
s
>>>> to know if it is front or back camera.
>>>
>>> The name of a LED flash class device isn't fixed and is derived
>> >from DT label property. Name in the example of some DT bindings
>>> will not force people to apply similar pattern for the other
>>> drivers and even for the related one. No worry about having
>>> to keep anything forever basing on that.
>>
>> Isn't the V4L2 subdev/Media Controller API supposed to provide means
>> for associating flash LEDs with camera sensors? You seem to be=20

It should, and will, but doesn't do that yet. The information will soon
available to the kernel but even that's not yet in mainline.

insisting
>> on using the sysfs leds interface for that, which is not a primary
>> interface for camera flash AFAICT.
>=20
> a) subdev/media controller API currently does not provide such means.
>=20
> b) if we have /sys/class/leds interface to userland, it should be
> useful.
>=20
> c) having flashlight application going through media controller API is
> a bad joke.

d) V4L2 sub-devices are always related to a master device (that usually
has the DMA engine). In the absence of that, there will be no sub-device
node either. In other words, if you don't have a camera, you won't have
a sub-device. And it's perfectly possible to have a flash LED without a
camera.

For what's worth, I think there was a Nokia (S30 ?) phone long, long
time ago with a torch LED but no camera. 1100 maybe? The old one, not
the new one.

--=20
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com


--NwRtuWsBTtP1pw2mxu4LG2TQRi1mr3GsV--

--rFGVvDL23ikOeRt0JaKfX988RiQMeOQDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEAREIAB0WIQTw0Dd6DU8lp5I47+VtQDYbbijBkwUCWbpZyQAKCRBtQDYbbijB
kwS5AP0UU6vmsmp9D+Mf0ruBcZvusVSSTht2k7kROrIJI+65IAD/bJvt5TUuCNvN
UNCr6FvPnGcqavDYIZsAM57ovjhX4BE=
=LkLl
-----END PGP SIGNATURE-----

--rFGVvDL23ikOeRt0JaKfX988RiQMeOQDP--
