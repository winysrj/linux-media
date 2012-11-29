Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39924 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab2K2Trw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 14:47:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TeA5Z-0004ef-P8
	for linux-media@vger.kernel.org; Thu, 29 Nov 2012 20:48:01 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 20:48:01 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 20:48:01 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: ivtv driver inputs randomly "block"
Date: Thu, 29 Nov 2012 14:47:39 -0500
Message-ID: <50B7BBDB.9040508@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org>  <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>  <50B60D54.4010302@interlinx.bc.ca>  <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>  <50B69C08.7050401@interlinx.bc.ca>  <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>  <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com> <1354204218.2505.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC97ED571BA9B07C088B5C16A"
In-Reply-To: <1354204218.2505.13.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC97ED571BA9B07C088B5C16A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-11-29 10:50 AM, Andy Walls wrote:
>=20
> until the problem appears.

I'm afraid I didn't notice the problem until about 40m into the
recording bug given that MythTV is in a loop repeatedly opening the
card and trying to use it perhaps the high volume even 40 minutes into
the recording is useful.

> Then once you experience the problem change
> it to high volume
>=20
> # echo 0x47f > /sys/module/ivtv/parameters/debug

It seems to be a loop of:

Nov 29 14:39:47 cmurrell kernel: [953479.593771] ivtv0:  file: Encoder po=
ll
Nov 29 14:39:47 cmurrell kernel: [953479.594127] ivtv0:  ioctl: V4L2_ENC_=
CMD_STOP
Nov 29 14:39:47 cmurrell kernel: [953479.594131] ivtv0:  file: close() of=
 encoder MPG
Nov 29 14:39:47 cmurrell kernel: [953479.594134] ivtv0:  info: close stop=
ping capture
Nov 29 14:39:47 cmurrell kernel: [953479.594137] ivtv0:  info: Stop Captu=
re
Nov 29 14:39:47 cmurrell kernel: [953479.594142] ivtv0:  mb: MB Call: CX2=
341X_ENC_STOP_CAPTURE
Nov 29 14:39:49 cmurrell kernel: [953481.592013] ivtv0:  warn: encoder MP=
G: EOS interrupt not received! stopping anyway.
Nov 29 14:39:49 cmurrell kernel: [953481.592021] ivtv0:  warn: encoder MP=
G: waited 2000 ms.
Nov 29 14:39:49 cmurrell kernel: [953481.692036] ivtv0:  mb: MB Call: CX2=
341X_ENC_STOP_CAPTURE
Nov 29 14:39:49 cmurrell kernel: [953481.692138] ivtv0 encoder MPG: VIDIO=
C_ENCODER_CMD cmd=3D1, flags=3D1
Nov 29 14:39:49 cmurrell kernel: [953481.692161] ivtv0:  file: close enco=
der MPG
Nov 29 14:39:49 cmurrell kernel: [953481.692165] ivtv0:  file: close() of=
 encoder MPG
Nov 29 14:39:49 cmurrell kernel: [953481.692208] ivtv0:  file: open encod=
er MPG
Nov 29 14:39:49 cmurrell kernel: [953481.692211] ivtv0:  mb: MB Call: CX2=
341X_ENC_PING_FW
Nov 29 14:39:49 cmurrell kernel: [953481.692272] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953481.692348] ivtv0:  ioctl: V4L2_ENC_=
CMD_START
Nov 29 14:39:49 cmurrell kernel: [953481.692352] ivtv0:  info: Start enco=
der stream encoder MPG
Nov 29 14:39:49 cmurrell kernel: [953481.692356] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_DMA_BLOCK_SIZE
Nov 29 14:39:49 cmurrell kernel: [953481.692359] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VERT_CROP_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.692422] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953481.692485] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953481.692553] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953481.692617] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953481.692684] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_PLACEHOLDER
Nov 29 14:39:49 cmurrell kernel: [953481.692688] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_NUM_VSYNC_LINES
Nov 29 14:39:49 cmurrell kernel: [953481.692691] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.718739] ivtv0:  info: Setup VBI =
API header 0x0000bd03 pkts 1 buffs 4 ln 24 sz 1456
Nov 29 14:39:49 cmurrell kernel: [953481.718746] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_CONFIG
Nov 29 14:39:49 cmurrell kernel: [953481.718830] ivtv0:  info: Setup VBI =
start 0x002fea04 frames 4 fpi 1
Nov 29 14:39:49 cmurrell kernel: [953481.718834] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.718906] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.718978] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719052] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719126] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719196] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719269] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719352] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719445] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719522] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719592] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719662] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719732] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719807] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719893] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.719967] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720060] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720144] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720213] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720283] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720351] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720421] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720497] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720566] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720635] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720707] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720778] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720852] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720922] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.720993] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721063] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721137] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721208] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721278] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721348] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721417] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721492] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721561] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721629] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721700] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721770] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721845] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721914] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.721984] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.722054] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.722256] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_VBI_LINE
Nov 29 14:39:49 cmurrell kernel: [953481.722348] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_PGM_INDEX_INFO
Nov 29 14:39:49 cmurrell kernel: [953481.722412] ivtv0:  info: PGM Index =
at 0x00180150 with 400 elements
Nov 29 14:39:49 cmurrell kernel: [953481.722415] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_OUTPUT_PORT
Nov 29 14:39:49 cmurrell kernel: [953481.722419] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_FRAME_RATE
Nov 29 14:39:49 cmurrell kernel: [953481.727659] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_FRAME_SIZE
Nov 29 14:39:49 cmurrell kernel: [953481.727672] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_STREAM_TYPE
Nov 29 14:39:49 cmurrell kernel: [953481.727676] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_BIT_RATE
Nov 29 14:39:49 cmurrell kernel: [953481.727681] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_AUDIO_PROPERTIES
Nov 29 14:39:49 cmurrell kernel: [953481.727686] ivtv0:  mb: MB Call: CX2=
341X_ENC_MUTE_AUDIO
Nov 29 14:39:49 cmurrell kernel: [953481.727757] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_ASPECT_RATIO
Nov 29 14:39:49 cmurrell kernel: [953481.727761] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_GOP_PROPERTIES
Nov 29 14:39:49 cmurrell kernel: [953481.727765] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_GOP_CLOSURE
Nov 29 14:39:49 cmurrell kernel: [953481.727769] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_FRAME_DROP_RATE
Nov 29 14:39:49 cmurrell kernel: [953481.727772] ivtv0:  mb: MB Call: CX2=
341X_ENC_MUTE_VIDEO
Nov 29 14:39:49 cmurrell kernel: [953481.727883] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_DNR_FILTER_MODE
Nov 29 14:39:49 cmurrell kernel: [953481.727886] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_DNR_FILTER_PROPS
Nov 29 14:39:49 cmurrell kernel: [953481.727890] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_SPATIAL_FILTER_TYPE
Nov 29 14:39:49 cmurrell kernel: [953481.727894] ivtv0:  mb: MB Call: CX2=
341X_ENC_SET_CORING_LEVELS
Nov 29 14:39:49 cmurrell kernel: [953481.727898] ivtv0:  mb: MB Call: CX2=
341X_ENC_MISC
Nov 29 14:39:49 cmurrell kernel: [953482.044030] ivtv0:  mb: MB Call: CX2=
341X_ENC_INITIALIZE_INPUT
Nov 29 14:39:49 cmurrell kernel: [953482.047873] ivtv0:  mb: MB Call: CX2=
341X_ENC_START_CAPTURE
Nov 29 14:39:49 cmurrell kernel: [953482.060040] ivtv0 encoder MPG: VIDIO=
C_ENCODER_CMD cmd=3D0, flags=3D0
Nov 29 14:39:49 cmurrell kernel: [953482.060347] ivtv0:  file: Encoder po=
ll

Cheers,
b.



--------------enigC97ED571BA9B07C088B5C16A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC3u9wACgkQl3EQlGLyuXBvVgCg32Q/PH+WYm85RwighQnCQhMz
ZWAAoLCl31ujzGxAlKjJdC/ubuFMV93f
=iVKM
-----END PGP SIGNATURE-----

--------------enigC97ED571BA9B07C088B5C16A--

