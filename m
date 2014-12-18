Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55900 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaLRIZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:25:01 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so891182wiv.14
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 00:25:00 -0800 (PST)
Date: Thu, 18 Dec 2014 09:24:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv2 0/3] hdmi: add unpack and logging functions
Message-ID: <20141218082457.GB29856@ulmo>
References: <1417522126-31771-1-git-send-email-hverkuil@xs4all.nl>
 <54895C92.9000007@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <54895C92.9000007@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2014 at 09:57:54AM +0100, Hans Verkuil wrote:
> Hi Thierry,
>=20
> On 12/02/14 13:08, Hans Verkuil wrote:
> > This patch series adds new HDMI 2.0/CEA-861-F defines to hdmi.h and
> > adds unpacking and logging functions to hdmi.c. It also uses those
> > in the V4L2 adv7842 driver (and they will be used in other HDMI drivers
> > once this functionality is merged).
> >=20
> > Patches 2 and 3 have been posted before by Martin Bugge. It stalled, but
> > I am taking over from Martin to try and get this is. I want to use this
> > in a bunch of v4l2 drivers, so I would really like to see this merged.
> >=20
> > Changes since v1:
> >=20
> > - rename HDMI_CONTENT_TYPE_NONE to HDMI_CONTENT_TYPE_GRAPHICS to conform
> >   to CEA-861-F.
> > - added missing HDMI_AUDIO_CODING_TYPE_CXT.
> > - Be explicit: out of range values are called "Invalid", reserved
> >   values are called "Reserved".
> > - Incorporated most of Thierry's suggestions. Exception: I didn't
> >   create ..._get_name(buffer, length, ...) functions. I think it makes
> >   the API awkward and I am not convinced that it is that useful.
> >   I also kept "No Data" since that's what CEA-861-F calls it. I also
> >   think that "No Data" is a better description than "None" since it
> >   really means that nobody bothered to fill this in.
> >=20
> > Please let me know if there are more things that need to be addressed in
> > these patches before they can be merged.
>=20
> Any comments about this v2?

Sorry for taking so long. This got burried under a lot of other stuff. I
have some minor comments to patch 2/3, but on the whole this looks very
nice.

> If not, is this something you or someone else from dri-devel will
> take, or can it be merged through the media git repository?

I'm not aware of anyone currently doing work on this for DRM, so I think
it'd be fine if you took it through the media git tree, especially since
patch 3/3 clearly belongs there.

If we ever need to resolve dependencies between this and new work in DRM
we could set up a stable branch containing patches 1/3 and 2/3 which can
be merged into both trees.

Thierry

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUko9ZAAoJEN0jrNd/PrOhgIcP/RgWFpAF0AZYpMBb/E2HoFYd
3Or27TkpZKKurvS7XAkF88SJSpVzyhHCAGC/PBICKpBRQFagR8ZOOdaWUxkVlkVM
m0VlnDg618sbc5vXPHLi77aN85/8xruOXre326mcE7Hzu23Dm4UJ9BX7ToHEc/qn
TaOY8q/Q9c/L/MSuy5rxnjwrKPgMUWQupMYyTwahGrnWR6ZUCxNF1hoDXiK77hSr
yoyX9VkyBIzprJ2lOVRZFgHJkk5ATWpDKACyyG3kM/HO7+MQM/cMMci0pS7x5Fs1
cFvLh7twWBA1qoY+RMxpcy6TE8ehPweJobMSoPL9vxa3HM4TSVQ+0FmKBMW1uL1W
Ynl5pCGhJU/OCAckKqa6EeRQ4CteswUfUDaOkFC05jLs7Yx1PqrIFXQnLENwv5If
Voa0HCZAwTQwcgSA4qmjb0HobFpT+UPKZJtVTkDSPkZOz9mSXHh46+1oX/6Lthfd
gO1NiIRazm9WjWVGgmMQPK86LeuofxZjTfQOdRbrn85CTvTqYzNcJfB9Sq66wHPY
yiovfT2wM1IE2DOllY3MpS04d8v1AW/Spm9/qUe0g36q8+myKQffoEmWqTtMGb8t
8nlt3bEwA5onkGVcxohZ/5dj0T8xA1YBKKN1vBWKo1pEBwxKFzG7zpOBuldvlemR
6ivbzhAoLJ4YRDI+XRVU
=orBJ
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
