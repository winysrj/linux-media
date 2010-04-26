Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:57262 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0DZQw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 12:52:59 -0400
Date: Mon, 26 Apr 2010 18:52:46 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Xawtv sparc 64bit fix
Message-ID: <20100426185246.174c0197@borg.bxl.tuxicoman.be>
In-Reply-To: <4BD47410.9000006@redhat.com>
References: <20100423170316.12e01bfc@borg.bxl.tuxicoman.be>
	<4BD47410.9000006@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/8B8Cybmk5I/Rl5PSbO2Kaja"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/8B8Cybmk5I/Rl5PSbO2Kaja
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi Mauro,

Thanks for the feedback. Here is the fixed version.

Cheers,
  Guy

On Sun, 25 Apr 2010 13:55:44 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Guy Martin wrote:
> >=20
> > Hi,
> >=20
> > Here is an old patch of mine which I tried to submit in 2006 but
> > never got it. I didn't really know who was xawtv's maintainer at
> > that time.
> >=20
> >=20
> >=20
> > The calculation to compute the 64bit alignement in struct-dump.c is
> > plain wrong. The alignment has to be computed with a structure
> > containing a char and then a 64bit integer and then substract the
> > pointer of the 64bit int to the one of the char.
> >=20
> > This fix v4l-info doing a Bus Error on sparc with structs containing
> > 64 bit integer following a non 64bit field aligned on a 8 byte
> > boundary like v4l2_standard.
> >=20
> >=20
> > Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
>=20
> I tried to compile it (x86_64 arch) and your patch produced two
> warnings:
>=20
> ../structs/struct-dump.c: In function =E2=80=98print_struct=E2=80=99:
> ../structs/struct-dump.c:48: warning: cast from pointer to integer of
> different size ../structs/struct-dump.c:48: warning: cast from
> pointer to integer of different size
>=20
> Could you please fix it?
>=20
> >=20
> >=20
> > Regards,
> >   Guy
> >=20
>=20
>=20


--MP_/8B8Cybmk5I/Rl5PSbO2Kaja
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xawtv-struct-dump.diff

diff --git a/structs/struct-dump.c b/structs/struct-dump.c
index 0ee7fc8..49bfe2d 100644
--- a/structs/struct-dump.c
+++ b/structs/struct-dump.c
@@ -43,7 +43,9 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 	int16_t  s16;
 	uint8_t  u8;
 	int8_t   s8;
-	int al = sizeof(long)-1; /* struct + union + 64bit alignment */
+	struct al64_t { char c; uint64_t t; } al64_t;
+	int al = sizeof(long)-1; /* struct + union */
+	int al64 = (unsigned long)&al64_t.t - (unsigned long)&al64_t.c - 1; /* 64 bit alignement */
 	void *p;
 	unsigned int i,j,first;
 
@@ -149,7 +151,7 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 			ptr += 4;
 			break;
 		case BITS64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			u64 = *((uint64_t*)ptr);
 			first = 1;
 			fprintf(fp,"0x%" PRIx64 " [",u64);
@@ -166,13 +168,13 @@ int print_struct(FILE *fp, struct struct_desc *desc, void *data,
 			break;
 
 		case UINT64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			u64 = *((uint64_t*)ptr);
 			fprintf(fp,"%" PRIu64,u64);
 			ptr += 8;
 			break;
 		case SINT64:
-			ptr = (void*)(((intptr_t)ptr + al) & ~al);
+			ptr = (void*)(((intptr_t)ptr + al64) & ~al64);
 			s64 = *((int64_t*)ptr);
 			fprintf(fp,"%" PRId64,s64);
 			ptr += 8;

--MP_/8B8Cybmk5I/Rl5PSbO2Kaja--
