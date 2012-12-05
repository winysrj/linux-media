Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interlinx.bc.ca ([216.58.37.5]:56969 "EHLO
	linux.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2LEOML (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 09:12:11 -0500
Received: from [IPv6:2001:4978:161:0:214:d1ff:fe13:45ac] (pc.interlinx.bc.ca [IPv6:2001:4978:161:0:214:d1ff:fe13:45ac])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by linux.interlinx.bc.ca (Postfix) with ESMTPSA id 546859095
	for <linux-media@vger.kernel.org>; Wed,  5 Dec 2012 09:12:06 -0500 (EST)
Message-ID: <50BF5635.9090307@interlinx.bc.ca>
Date: Wed, 05 Dec 2012 09:12:05 -0500
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: ivtv driver inputs randomly "block"
References: <k93vu3$ffi$1@ger.gmane.org>  <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>  <50B60D54.4010302@interlinx.bc.ca>  <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>  <50B69C08.7050401@interlinx.bc.ca>  <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>  <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com> <1354204218.2505.13.camel@palomino.walls.org> <50B7BBDB.9040508@interlinx.bc.ca> <50BBB10B.2020306@interlinx.bc.ca>
In-Reply-To: <50BBB10B.2020306@interlinx.bc.ca>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA72D8D91A032F4E107F55181"
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA72D8D91A032F4E107F55181
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-12-02 02:50 PM, Brian J. Murrell wrote:
>=20
> Was this information helpful?  If not, please let me know what else I
> can provide to give you something you can diagnose with.

Here's something interesting...

When a tuner/encoder is blocking reads, the following is printed to the
kernel log:

[1451927.797336] ivtv1:  file: open encoder MPG
[1451927.797344] ivtv1:  mb: MB Call: CX2341X_ENC_PING_FW
[1451927.797413] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451927.797513] ivtv1 encoder MPG: unknown ioctl 'T', dir=3D--, #1 (0x00=
005401) error -22
[1451927.797531] ivtv1:  info: Start encoder stream encoder MPG
[1451927.797535] ivtv1:  mb: MB Call: CX2341X_ENC_SET_DMA_BLOCK_SIZE
[1451927.797539] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VERT_CROP_LINE
[1451927.797609] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451927.797679] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451927.797752] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451927.797831] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451927.797904] ivtv1:  mb: MB Call: CX2341X_ENC_SET_PLACEHOLDER
[1451927.797907] ivtv1:  mb: MB Call: CX2341X_ENC_SET_NUM_VSYNC_LINES
[1451927.797911] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821351] ivtv1:  info: Setup VBI API header 0x0000bd03 pkts 1 buf=
fs 4 ln 24 sz 1456
[1451927.821358] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_CONFIG
[1451927.821439] ivtv1:  info: Setup VBI start 0x002fea04 frames 4 fpi 1
[1451927.821442] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821519] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821595] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821673] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821750] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821828] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821905] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.821980] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822056] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822135] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822211] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822289] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822367] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822443] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822519] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822594] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822672] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822749] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822827] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822902] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.822979] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823057] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823134] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823211] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823287] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823363] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823438] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823516] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823593] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823670] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823747] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823826] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823902] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.823979] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824095] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824174] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824248] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824324] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824400] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824478] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824554] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824629] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824706] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824782] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824857] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.824934] ivtv1:  mb: MB Call: CX2341X_ENC_SET_VBI_LINE
[1451927.825009] ivtv1:  mb: MB Call: CX2341X_ENC_SET_PGM_INDEX_INFO
[1451927.825079] ivtv1:  info: PGM Index at 0x00180150 with 400 elements
[1451927.825082] ivtv1:  mb: MB Call: CX2341X_ENC_SET_OUTPUT_PORT
[1451927.825086] ivtv1:  mb: MB Call: CX2341X_ENC_SET_FRAME_RATE
[1451927.832028] ivtv1:  mb: MB Call: CX2341X_ENC_SET_FRAME_SIZE
[1451927.832042] ivtv1:  mb: MB Call: CX2341X_ENC_SET_STREAM_TYPE
[1451927.832046] ivtv1:  mb: MB Call: CX2341X_ENC_SET_BIT_RATE
[1451927.832051] ivtv1:  mb: MB Call: CX2341X_ENC_SET_AUDIO_PROPERTIES
[1451927.832055] ivtv1:  mb: MB Call: CX2341X_ENC_MUTE_AUDIO
[1451927.832130] ivtv1:  mb: MB Call: CX2341X_ENC_SET_ASPECT_RATIO
[1451927.832144] ivtv1:  mb: MB Call: CX2341X_ENC_SET_GOP_PROPERTIES
[1451927.832148] ivtv1:  mb: MB Call: CX2341X_ENC_SET_GOP_CLOSURE
[1451927.832151] ivtv1:  mb: MB Call: CX2341X_ENC_SET_FRAME_DROP_RATE
[1451927.832154] ivtv1:  mb: MB Call: CX2341X_ENC_MUTE_VIDEO
[1451927.832267] ivtv1:  mb: MB Call: CX2341X_ENC_SET_DNR_FILTER_MODE
[1451927.832271] ivtv1:  mb: MB Call: CX2341X_ENC_SET_DNR_FILTER_PROPS
[1451927.832274] ivtv1:  mb: MB Call: CX2341X_ENC_SET_SPATIAL_FILTER_TYPE=

[1451927.832277] ivtv1:  mb: MB Call: CX2341X_ENC_SET_CORING_LEVELS
[1451927.832282] ivtv1:  mb: MB Call: CX2341X_ENC_MISC
[1451928.140030] ivtv1:  mb: MB Call: CX2341X_ENC_INITIALIZE_INPUT
[1451928.144018] ivtv1:  mb: MB Call: CX2341X_ENC_START_CAPTURE
[1451934.405980] ivtv1:  info: User stopped encoder MPG
[1451934.406074] ivtv1:  file: close encoder MPG
[1451934.406079] ivtv1:  file: close() of encoder MPG
[1451934.406082] ivtv1:  info: close stopping capture
[1451934.406085] ivtv1:  info: Stop Capture
[1451934.406089] ivtv1:  mb: MB Call: CX2341X_ENC_STOP_CAPTURE
[1451934.504032] ivtv1:  mb: MB Call: CX2341X_ENC_STOP_CAPTURE

The read(2) from /dev/video1 just doesn't get any data given to it
while this is happening.

Cheers,
b.



--------------enigA72D8D91A032F4E107F55181
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC/VjYACgkQl3EQlGLyuXCOLQCfbywgaewP9j90Zut6wBGmaguj
uqgAniZxMyKn7fuoQ9yXcNXfaA5DOyq8
=wAZQ
-----END PGP SIGNATURE-----

--------------enigA72D8D91A032F4E107F55181--
