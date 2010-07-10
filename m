Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:38960 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab0GJJfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 05:35:53 -0400
Date: Sat, 10 Jul 2010 11:36:16 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Baker <kyleabaker@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Microsoft VX-1000 Microphone Drivers Crash in x86_64
Message-ID: <20100710113616.1ed63ebc@tele>
In-Reply-To: <AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
References: <AANLkTinFXtHdN6DoWucGofeftciJwLYv30Ll6f_baQtH@mail.gmail.com>
	<20100707074431.66629934@tele>
	<AANLkTimxJi3qvIImwUDZCzWSCC3fEspjAyeXg9Qkneyo@mail.gmail.com>
	<20100707110613.18be4215@tele>
	<AANLkTim6xCtIMxZj3f4wpY6eZTrJBEv6uvVZZoiX-mg6@mail.gmail.com>
	<20100708121454.75db358c@tele>
	<AANLkTilw1KxYanoQZEZVaiFCLfkdTpO72Z9xV73i4gm2@mail.gmail.com>
	<20100709200312.755e8069@tele>
	<AANLkTikxIJxuQiV_7PqPA5C6ZU5XhhmmQ3hAbIwWsrPT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Sj3/j/c7RrBBN+pJi54Mjy1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/Sj3/j/c7RrBBN+pJi54Mjy1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 9 Jul 2010 17:04:03 -0400
Kyle Baker <kyleabaker@gmail.com> wrote:

> I tried using a couple of USB sniffers in Windows 7, but I'm unable to
> find one that has an option to save in text mode as sniffbin.
> Apologies in advanced for the length of the log files that I managed

I could not use the "Simple USB Logger". With "SnoopyPro", it is easier:
- start ms-win
- start snoopypro
- open the binary log file
- select all
- expand
- select all
- copy
- start notepad
- paste
- save the log file
- and move it to Linux.

So, the GPIO register is the second one of the bridge. It is
initialized at line 71 of sonixj.c. May you change it from 0x40 to 0x44?
(see attached diff)

If this does not work, I saw some other little differences..

Best regards.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/Sj3/j/c7RrBBN+pJi54Mjy1
Content-Type: application/octet-stream; name=patch.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=patch.pat

LS0tIHNvbml4ai5jfgkyMDEwLTA2LTA0IDExOjM1OjU2LjAwMDAwMDAwMCArMDIwMAorKysgc29u
aXhqLmMJMjAxMC0wNy0xMCAxMTowMzowMi4wMDAwMDAwMDAgKzAyMDAKQEAgLTQ2OCw3ICs0Njgs
NyBAQCBzdGF0aWMgY29uc3QgdTggc25fb3Y3NjQ4WzB4MWNdID0gewogCiBzdGF0aWMgY29uc3Qg
dTggc25fb3Y3NjYwWzB4MWNdID0gewogLyoJcmVnMAlyZWcxCXJlZzIJcmVnMwlyZWc0CXJlZzUJ
cmVnNglyZWc3ICovCi0JMHgwMCwJMHg2MSwJMHg0MCwJMHgwMCwJMHgxYSwJMHgwMCwJMHgwMCwJ
MHgwMCwKKwkweDAwLAkweDYxLAkweDQ0LAkweDAwLAkweDFhLAkweDAwLAkweDAwLAkweDAwLAog
LyoJcmVnOAlyZWc5CXJlZ2EJcmVnYglyZWdjCXJlZ2QJcmVnZQlyZWdmICovCiAJMHg4MSwJMHgy
MSwJMHgwMCwJMHgwMCwJMHgwMCwJMHgwMCwJMHgwMCwJMHgwMCwKIC8qCXJlZzEwCXJlZzExCXJl
ZzEyCXJlZzEzCXJlZzE0CXJlZzE1CXJlZzE2CXJlZzE3ICovCg==

--MP_/Sj3/j/c7RrBBN+pJi54Mjy1--
