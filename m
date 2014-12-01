Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64704 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaLAPdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 10:33:36 -0500
Received: by mail-pd0-f180.google.com with SMTP id p10so11133904pdj.39
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 07:33:35 -0800 (PST)
Date: Mon, 1 Dec 2014 16:33:31 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/3] hdmi: added unpack and logging functions for
 InfoFrames
Message-ID: <20141201153329.GC11943@ulmo.nvidia.com>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
 <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl>
 <20141201131507.GB11763@ulmo.nvidia.com>
 <547C71BF.4040907@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <547C71BF.4040907@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 02:48:47PM +0100, Hans Verkuil wrote:
> Hi Thierry,
>=20
> Thanks for the review, see my comments below.
>=20
> On 12/01/2014 02:15 PM, Thierry Reding wrote:
> > On Fri, Nov 28, 2014 at 03:50:50PM +0100, Hans Verkuil wrote:
[...]
> >> +{
> >> +	switch (type) {
> >> +	case HDMI_INFOFRAME_TYPE_VENDOR: return "Vendor";
> >> +	case HDMI_INFOFRAME_TYPE_AVI: return "Auxiliary Video Information (A=
VI)";
> >> +	case HDMI_INFOFRAME_TYPE_SPD: return "Source Product Description (SP=
D)";
> >> +	case HDMI_INFOFRAME_TYPE_AUDIO: return "Audio";
> >=20
> > I'd prefer "case ...:" and "return ...;" on separate lines for
> > readability.
>=20
> I actually think that makes it *less* readable. If you really want that, =
then I'll
> change it, but I would suggest that you try it yourself first to see if i=
t is
> really more readable for you. It isn't for me, so I'll keep this for the =
next
> version.

I did, and I still think separate lines are more readable, especially if
you throw in a blank line after the "return ...;". Anyway, I could keep
my OCD in check if it weren't for the fact that half of these are the
cause for checkpatch to complain. And then if you change the ones that
checkpatch wants you to change, all the others would be inconsistent and
then I'd complain about the inconsistency...

checkpatch flagged a couple other issues, please make sure to address
those as well.

> > Maybe include the numerical value here? Of course that either means that
> > callers must pass in a buffer or we sacrifice thread-safety. The buffer
> > could be optional, somewhat like this:
> >=20
> > 	const char *hdmi_infoframe_get_name(char *buffer, size_t length,
> > 					    enum hdmi_infoframe_type type)
> > 	{
> > 		const char *name =3D NULL;
> >=20
> > 		switch (type) {
> > 		case HDMI_INFOFRAME_TYPE_VENDOR:
> > 			name =3D "Vendor";
> > 			break;
> > 		...
> > 		}
> >=20
> > 		if (buffer) {
> > 			if (!name)
> > 				snprintf(buffer, length, "unknown (%d)", type);
> > 			else
> > 				snprintf(buffer, length, name);
> >=20
> > 			name =3D buffer;
> > 		}
> >=20
> > 		return name;
> > 	}
> >=20
> > That way the function would be generally useful and could even be made
> > publicly available.
>=20
> I would do this only where it makes sense. Some of these fields have only=
 one or
> two reserved bits left, and in that case is it easier to just say somethi=
ng
> like "Reserved (3)" and do that for each reserved value.

Okay.

> >> +/**
> >> + * hdmi_infoframe_log() - log info of HDMI infoframe
> >> + * @dev: device
> >> + * @frame: HDMI infoframe
> >> + */
> >> +void hdmi_infoframe_log(struct device *dev, union hdmi_infoframe *fra=
me)
> >> +{
> >> +	switch (frame->any.type) {
> >> +	case HDMI_INFOFRAME_TYPE_AVI:
> >> +		hdmi_avi_infoframe_log(dev, &frame->avi);
> >> +		break;
> >> +	case HDMI_INFOFRAME_TYPE_SPD:
> >> +		hdmi_spd_infoframe_log(dev, &frame->spd);
> >> +		break;
> >> +	case HDMI_INFOFRAME_TYPE_AUDIO:
> >> +		hdmi_audio_infoframe_log(dev, &frame->audio);
> >> +		break;
> >> +	case HDMI_INFOFRAME_TYPE_VENDOR:
> >> +		hdmi_vendor_any_infoframe_log(dev, &frame->vendor);
> >> +		break;
> >> +	default:
> >> +		WARN(1, "Bad infoframe type %d\n", frame->any.type);
> >=20
> > Does it make sense for this to be WARN? It's perfectly legal for future
> > devices to expose new types of infoframes. Perhaps even expected. But if
> > we want to keep this here to help get bug reports so that we don't
> > forget to update this code, then maybe we should do the same wherever we
> > query the name of enum values above.
>=20
> I'll drop the WARN from the log function. I think it should also be dropp=
ed
> from the unpack. The only place it makes sense is for pack() since there =
the
> data comes from the driver, not from an external source.

Sounds good.

Thierry

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfIpJAAoJEN0jrNd/PrOhg84QAJYzcGJ/1vEcORT8UytrBD60
Gy0aw1BQOnhs/eGJmhXZ+bBxEZtVBKZRuoWJBifxnvz1I3I+FBQoLH0ZN6PzKLt/
eeT0us1xlc7SAqdA/SHYeSBfx+BA8tfzkzySgdiCVM69u5OxjNSTphy16xi7Od+M
w+1k5SseOWQ/tUoo1nVawfg/YpLv7g8+X3iQT7jRFLLvaiwJboPFMnwdEE/vcjEV
EYwhhv2vb0ZtxP8Y6usOlfAarojtY3dZ8E2pknd6MkIj7My2eMxcDPNaOfEU6Fy4
2Ky8u/rL3TVUO68Nv1cRcG5ee58SIfSmp5PcTmJIQ1Fe6gwc1oLY4tDPmagU3uQn
0hcPK3OZYmdgLGMn2GsuN8xm2CYzIks6xCDxrDjWmQqlZbNo614QBhhnS6C7Sxti
wmo/If8II/YBxFCk7osH9St4obJBj50NRgukJLEBNOXXHF72xQjhsjKpYIw/amhp
GR2XwIi01oC2s5F9aW2T6Orh64b40oshHk6DGtGfIyNCnI94XLXJ2s3ADL+jcjx7
sy2l18Co8Po2/gRjHQb43Obl91U6/svnUnxFiYt+XByQ/OaVn9Fl7/MwXz8SuWLb
xrqVUwRTFNhfGClug3RUzkQGgsKBhmCKYvzRYp6bTnE+xOYBpjaLTA5thNOhyS0h
Cb+JxrBwEf/a/G19o+N6
=0P6F
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
