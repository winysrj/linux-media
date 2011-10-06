Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44987 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826Ab1JFNXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 09:23:05 -0400
Received: by gyg10 with SMTP id 10so2549664gyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 06:23:05 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Evan Platt <evplatt@gmail.com>,
	Mauro Chehab <mchehab@infradead.org>
Subject: Re: Media_build Issue with altera on cx23885
Date: Thu, 6 Oct 2011 16:23:13 +0300
Cc: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
References: <CABHmaNMw8OUoSZ8XsWA_QQz5H9h6+3aVTVMcW30VzOCGTx7=gw@mail.gmail.com>
In-Reply-To: <CABHmaNMw8OUoSZ8XsWA_QQz5H9h6+3aVTVMcW30VzOCGTx7=gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BvajOjOs8BL66Q0"
Message-Id: <201110061623.13253.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_BvajOjOs8BL66Q0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
5 =D0=BE=D0=BA=D1=82=D1=8F=D0=B1=D1=80=D1=8F 2011 23:04:34 =D0=B0=D0=B2=D1=
=82=D0=BE=D1=80 Evan Platt =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> V4L-DVB was previously working correctly for me.  I was experiencing
> some problems which had been solved before by recompiling v4l.  So I
> cloned the latest media_build tree and ran the build process.
>=20
> Afterward, the driver does not load correctly and dmesg shows an error
> (cx23885: Unknown symbol altera_init (err 0)).  I know there was a
> change to move altera from staging to misc but I see that the changes
> were propogated to media_build on 9/26/11.
>=20
> I ran menuconfig and made sure that MISC_DEVICES was set to 'y' to
> include altera-stapl but to no avail.
>=20
> Please advise.
>=20
> Some relevant information:
>=20
> Device:  Hauppauge HVR-1250 Tuner
> Driver:  cx23885
> Environment: Ubuntu 11.04, 2.6.38-11-generic
>=20
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Evan,
Just try attached patch against media_build. It fixes altera-stapl build fo=
r=20
media_build tree.

Mauro, is this a correct patch?

=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_BvajOjOs8BL66Q0
Content-Type: text/x-patch;
  charset="us-ascii";
  name="misc-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="misc-fix.patch"

diff --git a/v4l/Makefile b/v4l/Makefile
index 311924e..14bfe46 100644
--- a/v4l/Makefile
+++ b/v4l/Makefile
@@ -257,6 +257,7 @@ links::
 	@find ../linux/drivers/media -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
 	@find ../linux/sound -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
 	@find ../linux/drivers/staging -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
+	@find ../linux/drivers/misc -name '*.[ch]' -type f -print0 | xargs -0n 255 ln -sf --target-directory=.
 
 config-compat.h:: $(obj)/.version .myconfig scripts/make_config_compat.pl
 	perl scripts/make_config_compat.pl $(SRCDIR) $(obj)/.myconfig $(obj)/config-compat.h
diff --git a/v4l/scripts/make_makefile.pl b/v4l/scripts/make_makefile.pl
index 1832e5b..112ef0d 100755
--- a/v4l/scripts/make_makefile.pl
+++ b/v4l/scripts/make_makefile.pl
@@ -205,6 +205,7 @@ open OUT, '>Makefile.media' or die 'Unable to write Makefile.media';
 open_makefile('../linux/drivers/media/Makefile');
 
 find({wanted => \&parse_dir, no_chdir => 1}, '../linux/drivers/staging');
+find({wanted => \&parse_dir, no_chdir => 1}, '../linux/drivers/misc');
 
 # Creating Install rule
 print OUT "media-install::\n";

--Boundary-00=_BvajOjOs8BL66Q0--
