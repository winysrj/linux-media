Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:53425 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756294AbcHXNuI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 09:50:08 -0400
Date: Wed, 24 Aug 2016 15:49:34 +0200
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] v4l2-async: Always unregister the subdev on
 failure
Message-ID: <20160824154934.07f75979@avionic-0020>
In-Reply-To: <38e4b736-b053-05e0-112b-550411ecb56c@xs4all.nl>
References: <1462981201-14768-1-git-send-email-alban.bedel@avionic-design.de>
        <429cc087-85e3-7bfa-b0b6-ab9434e5d47c@osg.samsung.com>
        <20160511183252.6270d740@avionic-0020>
        <38e4b736-b053-05e0-112b-550411ecb56c@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AcTbSniZ/wTXtYlT40_Sr8_"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/AcTbSniZ/wTXtYlT40_Sr8_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Jul 2016 13:55:44 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 05/11/2016 06:32 PM, Alban Bedel wrote:
> > On Wed, 11 May 2016 12:22:44 -0400
> > Javier Martinez Canillas <javier@osg.samsung.com> wrote:
> >  =20
> >> Hello Alban,
> >>
> >> On 05/11/2016 11:40 AM, Alban Bedel wrote: =20
> >>> In v4l2_async_test_notify() if the registered_async callback or the
> >>> complete notifier returns an error the subdev is not unregistered.
> >>> This leave paths where v4l2_async_register_subdev() can fail but
> >>> leave the subdev still registered.
> >>>
> >>> Add the required calls to v4l2_device_unregister_subdev() to plug
> >>> these holes.
> >>>
> >>> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> >>> ---
> >>>  drivers/media/v4l2-core/v4l2-async.c | 10 ++++++++--
> >>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l=
2-core/v4l2-async.c
> >>> index ceb28d4..43393f8 100644
> >>> --- a/drivers/media/v4l2-core/v4l2-async.c
> >>> +++ b/drivers/media/v4l2-core/v4l2-async.c
> >>> @@ -121,13 +121,19 @@ static int v4l2_async_test_notify(struct v4l2_a=
sync_notifier *notifier,
> >>> =20
> >>>  	ret =3D v4l2_subdev_call(sd, core, registered_async);
> >>>  	if (ret < 0 && ret !=3D -ENOIOCTLCMD) {
> >>> +		v4l2_device_unregister_subdev(sd);
> >>>  		if (notifier->unbind)
> >>>  			notifier->unbind(notifier, sd, asd);
> >>>  		return ret;
> >>>  	}
> >>> =20
> >>> -	if (list_empty(&notifier->waiting) && notifier->complete)
> >>> -		return notifier->complete(notifier);
> >>> +	if (list_empty(&notifier->waiting) && notifier->complete) {
> >>> +		ret =3D notifier->complete(notifier);
> >>> +		if (ret < 0) {
> >>> +			v4l2_device_unregister_subdev(sd); =20
> >>
> >> Isn't a call to notifier->unbind() missing here as well?
> >>
> >> Also, I think the error path is becoming too duplicated and complex, so
> >> maybe we can have a single error path and use goto labels as is common
> >> in Linux? For example something like the following (not tested) can be
> >> squashed on top of your change: =20
> >=20
> > Yes, that look better. I'll test it and report tomorrow. =20
>=20
> I haven't heard anything back about this. Did you manage to test it?

Yes, that's working fine. Sorry for the delay, I'm sending the v2 patch.

Alban


--Sig_/AcTbSniZ/wTXtYlT40_Sr8_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXvaXuAAoJEHSUmkuduC285AUQANhHvlzcasSofAqH4eHyyrUY
wM4whFXW9djk6FnM++djql7Au10dlCDk4u36mo0hq13fa6OM81o/OeXb+SifK9mO
64mH9C0YreGLlXeJ9VOO1REDd3Scu4L5i9Hpra2DxYkkTQS0CC+uAuZ5kWp25csT
NyV69kHw4NDJZdzzha0ABfjniEQq/aD0vZnTITjhZs2Trkl8zRaiXEePhRMqUUGn
4agczXV82kW89FCmAVXSNOqHP/pWko7sIWtFNnFbwo42bCbxRNbIcEXh+ZA+EVSq
pwX9gG1d5vnFxH3gyDeTeDY2nk/e2gQunYxKHrGERN6S+Xd0dNwrDP/2lDz+Ke05
qDdu8cxuCbxv91gng3sqmACC0qR/z6VIThiS01SCgRzMLOv0ZuF8Rj/Ii3kvdmrN
WME0kxTfpim3+bdHRUo+GZhcT5eEGVU7MqcyA/ysjS1NEF5+SAZa9lW2XEDsJK9i
4nzfy2o6N0VF6bWWjPYt8bwN24+i4KYKcstmHxCIRDxskJi3VEakoXGoO04Ecow7
bwTXroOni2xgoyGEX16lIfZBdl4WWgLZeLN0kU+LzPOrknbbu13EjDHa3W2wA2tb
8aG5Of5d3bqMb/f/di/RztVYA2NpO4PcXM8D1/iacXiMn0Mq0ePrbpxzdmTAgnXR
AKzc/oitUEwM4xEdYwBd
=JFl1
-----END PGP SIGNATURE-----

--Sig_/AcTbSniZ/wTXtYlT40_Sr8_--
