Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:27799 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752768AbcI0HOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 03:14:24 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Bin Liu <b-liu@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        nh26223@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <20160926140248.GF31827@uda0271908>
References: <20160920170441.GA10705@uda0271908> <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908> <87oa3go065.fsf@linux.intel.com> <87lgyknyp7.fsf@linux.intel.com> <87d1jw6yfd.fsf@linux.intel.com> <20160922133327.GA31827@uda0271908> <87a8ezn2av.fsf@linux.intel.com> <20160922201131.GD31827@uda0271908> <87shsr5a3e.fsf@linux.intel.com> <20160926140248.GF31827@uda0271908>
Date: Tue, 27 Sep 2016 10:14:07 +0300
Message-ID: <87inth4xxc.fsf@linux.intel.com>
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
> On Fri, Sep 23, 2016 at 10:49:57AM +0300, Felipe Balbi wrote:
>>=20
>> Hi,
>>=20
>> Bin Liu <b-liu@ti.com> writes:
>> > +Fengwei Yin per his request.
>> >
>> > On Thu, Sep 22, 2016 at 10:48:40PM +0300, Felipe Balbi wrote:
>> >>=20
>> >> Hi,
>> >>=20
>> >> Bin Liu <b-liu@ti.com> writes:
>> >>=20
>> >> [...]
>> >>=20
>> >> >> Here's one that actually compiles, sorry about that.
>> >> >
>> >> > No worries, I was sleeping ;-)
>> >> >
>> >> > I will test it out early next week. Thanks.
>> >>=20
>> >> meanwhile, how about some instructions on how to test this out myself?
>> >> How are you using g_webcam and what are you running on host side? Got=
 a
>> >> nice list of commands there I can use? I think I can get to bottom of
>> >> this much quicker if I can reproduce it locally ;-)
>> >
>> > On device side:
>> > - first patch g_webcam as in my first email in this thread to enable
>> >   640x480@30fps;
>> > - # modprobe g_webcam streaming_maxpacket=3D3072
>> > - then run uvc-gadget to feed the YUV frames;
>> > 	http://git.ideasonboard.org/uvc-gadget.git
>>=20
>> as is, g_webcam never enumerates to the host. It's calls to
>
> Right, on mainline kernel (I tested 4.8.0-rc7) g_webcam is broken with
> DWC3, g_webcam does not enumerate on the host. But it works on v4.4.21.

There aren't that many changes related to g_webcam though.

$ git log --oneline --no-merges v4.4..HEAD -- drivers/usb/gadget/function/f=
_uvc.c drivers/usb/gadget/legacy/webcam.c drivers/usb/gadget/function/uvc*
4fbac5206afd usb: gadget: uvc: Add missing call for additional setup data
bd610c5aa9fc usb: gadget: uvc: Fix return value in case of error
36c0f8b32c4b [media] vb2: replace void *alloc_ctxs by struct device *alloc_=
devs
1ae1602de028 configfs: switch ->default groups to a linked list
d6dd645eae76 [media] media: videobuf2: Move timestamp to vb2_buffer
df9ecb0cad14 [media] vb2: drop v4l2_format argument from queue_setup
0aecfc1b359d usb: gadget: composite: remove redundant bcdUSB setting in leg=
acy

>> uvc-gadget keeps printing this error message:
>>=20
>>  159         if ((ret =3D ioctl(dev->fd, VIDIOC_DQBUF, &buf)) < 0) {
>>  160                 printf("Unable to dequeue buffer: %s (%d).\n", stre=
rror(errno),
>>  161                         errno);
>>  162                 return ret;
>>  163         }
>
> I removed this printf, since it floods the console if start uvc-gadget
> before connect to the host.

fair enough

> BTY, you don't have to start uvc-gadget first then connect usb cable. I
> keep the cable always connected.

good to know. Thanks

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX6hw/AAoJEMy+uJnhGpkGHYEP/jjCvSKn2WD2I+aiMtS31n8A
DeAke8blDzaNtfFvkpOOjIWwPEcr1zfoYtSaWd+MzVIdVNbDre6aTcy5SxABNHMs
NGKdZjkHvbcOi97V56RZITBcqUBzPFJUGC6jFHh3KYjdWW1xjqvbqouQJfLv1Rgk
x4WTVhYTG/6w+7yLUvciRX9/Yrp2uZK+ARKT8KbWRMwsX/xcbGeX7S6pLbcijgLb
K5RjwxV5K3EskUXoNY0xgODQ/dHToX1XYPjkTz2zw4EpwST/Rc6+FPmvpJzIBwco
pdRf6M0X7R459mW266Glj6gbji8z4sp16/7xp560Zaw0eEvhiGfIexmgxK+3jyA9
4JbQ6nD553ou+uw7LfLxFG7vXWABiEuv7VwGQIwOP0j+wE2JUOJgotZ5WsnFWtyO
r6Hktq/ohHP3wzfpnudjodRXDg70AM8pR5rSb9I2ZL0yn16uPfr5e8z+iyd0tbB6
xayYha29nExdOBDnWHLIp197w1EEMGWHugTkYUgcFoYL/qaN2rM3mnfqg9QKPCUs
hJT4401njNTcjb8Jr5k11lRhCs/YnrS+bExfmaHa22g9Ys2/Qz859dpPAgcSyVQh
fc89hpDN5262vyABecjesQACWBAWBb4Kh8NAUmx2bqfsZmObNOONJoPVayniHpEP
6rrmj9RhGXEdr5DbN40N
=c7fT
-----END PGP SIGNATURE-----
--=-=-=--
