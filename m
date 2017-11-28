Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37407 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbdK1Pfo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 10:35:44 -0500
Date: Tue, 28 Nov 2017 16:35:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas van Kleef <thomas@vitsch.nl>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128153533.ncqe4lkgjdzjiyuw@flea.home>
References: <1511880674-3399460038.fc60fb9a7b@prakkezator.vehosting.nl>
 <54da46c6-48d1-544c-1379-d8e4d1aad089@vitsch.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zyqetl7zntby4ype"
Content-Disposition: inline
In-Reply-To: <54da46c6-48d1-544c-1379-d8e4d1aad089@vitsch.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zyqetl7zntby4ype
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 28, 2017 at 03:51:14PM +0100, Thomas van Kleef wrote:
> On 28-11-17 13:26, Maxime Ripard wrote:
> > On Tue, Nov 28, 2017 at 12:20:59PM +0100, Thomas van Kleef wrote:
> >>> So, I have been rebasing to 4.14.0 and have the cedrus driver working.
> >> I have pulled linux-mainline 4.14.0. Then pulled the requests2 branch =
=66rom Hans
> >> Verkuil's media_tree. I have a patch available of the merge between th=
ese 2
> >> branches.
> >> After this I pulled the sunxi-cedrus repository from Florent Revests g=
ithub. I
> >> believe this one is the same as the ones you are cloning right now.
> >> I have merged this and have a patch available for this as well.
> >>
> >> So to summarize:
> >>  o pulled linux 4.14 from:
> >>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >>  o pulled requests2 from:
> >>     https://git.linuxtv.org/hverkuil/media_tree.git?h=3Drequests2
> >>     will be replaced with the work, when it is done, in:
> >>      https://git.linuxtv.org/hverkuil/media_tree.git?h=3Dctrl-req-v2
> >>  o pulled linux-sunxi-cedrus from:
> >>     https://github.com/FlorentRevest/linux-sunxi-cedrus
> >>
> >>  o merged and made patch between linux4.14 and requests2
> >>  o merged and made patch with linux-sunxi-cedrus
> >>  o Verified that the video-engine is decofing mpeg-2 on the Allwinner =
A20.
> >>
> >> So maybe if someone is interested in this, I could place the patches s=
omewhere?
> >> Just let me know.
> >=20
> > Please create a pull request on the github repo. The point we set it
> > up was to share code. Forking repos and so on is kind of pointless.
> >=20
> So, I started with linux-mainline 4.14 and created a pull request with th=
at commit.
> Never made one before so if I did something wrong tell me.
>=20
> The following changes since commit e1d1ea549b57790a3d8cf6300e6ef86118d692=
a3:
>=20
>   Merge tag 'fbdev-v4.15' of git://github.com/bzolnier/linux (2017-11-20 =
21:50:24 -1000)
>=20
> are available in the git repository at:
>=20
>   https://github.com/thomas-vitsch/linux-a20-cedrus.git=20
>=20
> for you to fetch changes up to 508ad12eb737fde07f4a25446ed941a01480d6dc:
>=20
>   Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20-ced=
rus into linux-sunxi-cedrus-a20 (2017-11-28 15:28:18 +0100)
>=20
> ----------------------------------------------------------------
> Bob Ham (1):
>       sunxi-cedrus: Fix compilation errors from bad types under GCC 6.2
>=20
> Florent Revest (8):
>       cherry-pick sunxi_cedrus
>       cherry-pick sunxi_cedrus
>       v4l: Add MPEG4 low-level decoder API control
>       media: platform: Add Sunxi Cedrus decoder driver
>       sunxi-cedrus: Add a MPEG 2 codec
>       sunxi-cedrus: Add a MPEG 4 codec
>       sunxi-cedrus: Add device tree binding document
>       cherry-pick sunxi_cedrus
>=20
> Hans Verkuil (15):
>       videodev2.h: add max_reqs to struct v4l2_query_ext_ctrl
>       videodev2.h: add request to v4l2_ext_controls
>       videodev2.h: add request field to v4l2_buffer.
>       vb2: add allow_requests flag
>       v4l2-ctrls: add request support
>       v4l2-ctrls: add function to apply a request.
>       v4l2-ctrls: implement delete request(s)
>       v4l2-ctrls: add VIDIOC_REQUEST_CMD
>       v4l2: add initial V4L2_REQ_CMD_QUEUE support
>       vb2: add helper function to queue request-specific buffer.
>       v4l2-device: keep track of registered video_devices
>       v4l2-device: add v4l2_device_req_queue
>       vivid: add request support for video capture.
>       v4l2-ctrls: add REQ_KEEP flag
>       Documentation: add v4l2-requests.txt
>=20
> Icenowy Zheng (2):
>       sunxi-cedrus: add syscon support
>       cherry-pick sunxi_cedrus
>=20
> Thomas van Kleef (11):
>       Appears that the requests2 API is currently based on linux 3.9 :(. =
Made some changes that needed to be merged manually, let's hope I did not m=
ake to many errors
>       Fixed last missing calls for a buildable kernel with the requests2 =
API. Tested with a mock mem2mem device which selects the VIDEOBUF2_CORE.
>       Kconfig option used to enable the VIDEOBUF2_CORE
>       Fix sun5i-a13 merge errors. Mainline has moved some device nodes wh=
ich resulted in nodes existing multiple times in device trees.
>       o Added reserved memory region for the video-engine.     o Added de=
vice node for the video engine.
>       style commit
>       Apply patch which adds requests2 branch from media-tree:     https:=
//git.linuxtv.org/hverkuil/media_tree.git?h=3Drequests2
>       Apply patch which adds linux-sunxi-cedrus from: https://github.com/=
FlorentRevest/sunxi-cedrus-drv-video
>       Add reserved region and video-engine node to sun7i.dtsi
>       Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20=
-cedrus into linux-a20-cedrus
>       Merge branch 'master' of https://github.com/thomas-vitsch/linux-a20=
-cedrus into linux-sunxi-cedrus-a20
>=20
> Vitsch Electronics (1):
>       Update README

So there's a couple of issues with those patches (the pull request
itself is fine though :))

I'll try to break them down as much as possible.

A) If you want to have proper commit logs, you will usually do two
   things: first create a commit title, which is what appears in the
   above summary. That commit title should not be longer than 72
   characters, and it should explain roughly what you're trying to
   do. The actual description should be in the commit log itself, and
   you should document what is the issue you're trying to fix /
   improve, how you're doing it and why you've done it that way.

   The final line of that commit log shoud be your Signed-off-by,
   which is your agreement to the Developer Certificate of Origin
   (DCO), that you'll find documented here:
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst#n429

B) Please base your work on a known release (4.14) and not the middle
   of Linus' branch.

C) I'm not sure what you tried to do with the application of the
   request API patches (such as e1ca861c168f) but we want to have the
   whole commits in there, and not a patch adding all of them. This
   will make the work so much easier to rebase to a later version when
   some patches wouldn't have been merged and some would have.

D) Rebase :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--zyqetl7zntby4ype
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodgkEACgkQ0rTAlCFN
r3QYpw//Swvc3YJqY0ZWkpuuvxHoFvqx84H3dgZ4xSWaxXKH4DooQ/w2Utwc9Ka9
LtCpSVHrGVlQPVxVYHyy+AXTbmb0xRkW4j+R54dzs5WttjisTSMGrTckurehvnMU
aB8xJXhMX7O1ySOBxAz6/NULeT+QgPpiJ7Lr/XTvTOC3a9x+/YpIcxeU7onTNGhC
BvEAtv0Q2etzunEHH8Bc0o+m7q3mbnBxk/1tIJJ56JWWtHpbnEh7VY/tuzDFruYn
YnmCMHyX90/lmkqmBHVBKe+BzVsedD9Q8sMuN+kXexPkrype9LYc9tYp9dmZ1LHc
J/5YHB2wq3j5A7QHE2kteAVIhefcfq4KT+uPx0PBn3KilpfrNEBzuNBB35XD6DT8
QrHPQ74NI5eA6WNCYNxZGQ0wTA4TsBggOpiPkwdEjEw7Nz+SBs6sXWZlvO5Z4EAc
PzKx5kzchqCcUFYOLGhLb9noQPvLKRy7Z5VkDszjWcSH0NdltBQMz51DK9OC8V5y
JWk/hVeN/5zTJWz2p09dymr+PD/+l3tPyP9yHvjZrqz26BTUQ4dhtV5gZYKFNIFk
qrZrPnXo4xkLHVuAA9zVolUYtafXvTmBh+JjFQbOeiUXB3lbYVfyZcUssVDuvuk0
idHfxLao9u+L6UN9CFqL5kccWofz45j/ZB12EIZOdVHQq6Nss+Q=
=wSaS
-----END PGP SIGNATURE-----

--zyqetl7zntby4ype--
