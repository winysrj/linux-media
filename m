Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35957 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750867AbeDNBS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 21:18:26 -0400
From: "Jasmin J." <jasmin@anw.at>
Subject: Re: Smatch and sparse errors
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
References: <20180411122728.52e6fa9a@vento.lan>
Message-ID: <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
Date: Sat, 14 Apr 2018 03:18:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180411122728.52e6fa9a@vento.lan>
Content-Type: multipart/mixed;
 boundary="------------986356970D990F77FFFB9A4F"
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------986356970D990F77FFFB9A4F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hello Mauro/Hans!

> There is already an upstream patch for hidding it:
The patch from https://patchwork.kernel.org/patch/10334353 will not
apply at the smatch tree.

Attached is an updated version for smatch.

Even with the patched tools, sparse still complains:
 CC      drivers/media/cec/cec-core.o
/opt/media_test/media-git/include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:533:48: warning: constant 0xffffc90000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:624:29: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1098:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1795:27: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1887:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:151:25: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:236:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/dma-mapping.h:235:35: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/dma-mapping.h:238:33: warning: constant 0xffffea0000000000 is so big it is unsigned long

 CC      drivers/media/usb/gspca/gl860/gl860-mi2020.o
/opt/media_test/media-git/include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:533:48: warning: constant 0xffffc90000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:624:29: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1098:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1795:27: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/mm.h:1887:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:151:25: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:236:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
/opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long

But other warnings are gone with the patch.

The daily build is running on a machine of Hans. He need to update the
tools there.

@Hans:
Until this patches are in upstream, we need to patch smatch/sparse on the fly
in build.sh after pulling the last tools version.

BR,
   Jasmin

--------------986356970D990F77FFFB9A4F
Content-Type: text/x-patch;
 name="v4-smatch-add--Wpointer-arith-flag-to-toggle-sizeof-void-warnings.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="v4-smatch-add--Wpointer-arith-flag-to-toggle-sizeof-void-war";
 filename*1="nings.patch"

diff --git a/evaluate.c b/evaluate.c
index 1533730..815e7e1 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2090,7 +2090,8 @@ static struct symbol *evaluate_sizeof(struct expres=
sion *expr)
 	size =3D type->bit_size;
=20
 	if (size < 0 && is_void_type(type)) {
-		warning(expr->pos, "expression using sizeof(void)");
+		if (Wpointer_arith)
+			warning(expr->pos, "expression using sizeof(void)");
 		size =3D bits_in_char;
 	}
=20
@@ -2101,7 +2102,8 @@ static struct symbol *evaluate_sizeof(struct expres=
sion *expr)
 	}
=20
 	if (is_function(type->ctype.base_type)) {
-		warning(expr->pos, "expression using sizeof on a function");
+		if (Wpointer_arith)
+			warning(expr->pos, "expression using sizeof on a function");
 		size =3D bits_in_char;
 	}
=20
diff --git a/lib.c b/lib.c
index 69b5ab8..ed4a74f 100644
--- a/lib.c
+++ b/lib.c
@@ -234,6 +234,7 @@ int Wnon_pointer_null =3D 1;
 int Wold_initializer =3D 1;
 int Wone_bit_signed_bitfield =3D 1;
 int Wparen_string =3D 0;
+int Wpointer_arith =3D 0;
 int Wptr_subtraction_blows =3D 0;
 int Wreturn_void =3D 0;
 int Wshadow =3D 0;
@@ -453,6 +454,7 @@ static const struct warning {
 	{ "return-void", &Wreturn_void },
 	{ "shadow", &Wshadow },
 	{ "sizeof-bool", &Wsizeof_bool },
+	{ "pointer-arith", &Wpointer_arith },
 	{ "transparent-union", &Wtransparent_union },
 	{ "typesign", &Wtypesign },
 	{ "undef", &Wundef },
diff --git a/lib.h b/lib.h
index 0838342..a86615b 100644
--- a/lib.h
+++ b/lib.h
@@ -120,6 +120,7 @@ extern int Wnon_pointer_null;
 extern int Wold_initializer;
 extern int Wone_bit_signed_bitfield;
 extern int Wparen_string;
+extern int Wpointer_arith;
 extern int Wptr_subtraction_blows;
 extern int Wreturn_void;
 extern int Wshadow;
diff --git a/sparse.1 b/sparse.1
index acdce53..53eff87 100644
--- a/sparse.1
+++ b/sparse.1
@@ -265,6 +265,19 @@ initializer.  GCC allows this syntax as an extension=
=2E  With
 Sparse does not issue these warnings by default.
 .
 .TP
+.B \-Wpointer\-arith
+Warn about anything that depends on the \fBsizeof\fR a void or function =
type.
+
+C99 does not allow the \fBsizeof\fR operator to be applied to function t=
ypes
+or to incomplete types such as void. GCC allows \fBsizeof\fR to be appli=
ed to
+these types as an extension and assigns these types a size of \fI1\fR. W=
ith
+\fB\-pointer\-arith\fR, Sparse will warn about pointer arithmetic on voi=
d
+or function pointers, as well as expressions which directly apply the
+\fBsizeof\fR operator to void or function types.
+
+Sparse does not issue these warnings by default.
+.
+.TP
 .B \-Wptr\-subtraction\-blows
 Warn when subtracting two pointers to a type with a non-power-of-two siz=
e.
=20


--------------986356970D990F77FFFB9A4F--
