Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout2.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1JNrOe-0006KC-9p
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 16:13:40 +0100
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org,
 christian@duerrhauer.de
Date: Sat, 9 Feb 2008 16:13:07 +0100
References: <47AD998C.8090809@duerrhauer.de> <47ADBE15.1040908@duerrhauer.de>
	<47ADBF84.60006@duerrhauer.de>
In-Reply-To: <47ADBF84.60006@duerrhauer.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EMcrHvCdONEdJdm"
Message-Id: <200802091613.08130.jareguero@telefonica.net>
Subject: Re: [linux-dvb] gentoo: v4l-dvb-hg doesn't compile with kernel
	2.6.24-gentoo
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_EMcrHvCdONEdJdm
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

El S=E1bado, 9 de Febrero de 2008, Christian D=FCrrhauer escribi=F3:
> Christian D=FCrrhauer wrote:
> > Christian D=FCrrhauer wrote:
> >
> > I add a link to somebody else with the same problem:
> > http://www.alionet.org/index.php?showtopic=3D19216
>
> sorry, I didn't get my previous mail now, I see, so I am adding it.
> What went wrong I don't know.
>
> Christian
>
> Hi,
>
> the v4l-dvb-hg doesn't compile with the new kernel 2.6.24-gentoo. I am
> pretty sure I followed the instruction from the vdr-wiki for installing
> the drivers (kernel options). I have just for security rebuild the
> kernel using genkernel --clean --menuconfig all.
>
> As the ebuild is just pulling the source from mercurial, I thought, I
> just leave a message here and maybe somebody can look into it.
>
>    CC [M]
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.o
>    CC [M]
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/stk-webcam.o
>    CC [M]
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/stk-sensor.o
> In file included from
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.c:34:
> include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a
> function)
> make[2]: ***
> [/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.o]
> Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: ***
> [_module_/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l]
> Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.24-gentoo'
> make: *** [default] Error 2
>   *
>   * ERROR: media-tv/v4l-dvb-hg-0.1-r2 failed.
>   * Call stack:
>   *          ebuild.sh, line 1701:  Called dyn_compile
>   *          ebuild.sh, line 1039:  Called qa_call 'src_compile'
>   *          ebuild.sh, line   44:  Called src_compile
>   *          ebuild.sh, line 1383:  Called linux-mod_src_compile
>   *   linux-mod.eclass, line  519:  Called die
>   * The specific snippet of code:
>   *                      emake HOSTCC=3D"$(tc-getBUILD_CC)"
> CC=3D"$(get-KERNEL_CC)" LDFLAGS=3D"$(get_abi_LDFLAGS)" \
>   *                                ${BUILD_FIXES} ${BUILD_PARAMS}
> ${BUILD_TARGETS} \
>   *                              || die "Unable to make ${BUILD_FIXES}
> ${BUILD_PARAMS} ${BUILD_TARGETS}."
>   *  The die message:
>   *   Unable to make  KDIR=3D/usr/src/linux default.
>   *
>   * If you need support, post the topmost build error, and the call
> stack if relevant.
>   * A complete build log is located at
> '/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/temp/build.log'.
>   *
>
> Any help is greatly appreciated! :-)
>
> Kind regards,
>
> Christian

I have the same problem with kernel 2.6.24 and current HG. The attached pat=
ch=20
solve the problem for me.

Jose Alberto

--Boundary-00=_EMcrHvCdONEdJdm
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="bt87x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bt87x.diff"

diff -r 93ef35d93d83 linux/sound/pci/bt87x.c
--- a/linux/sound/pci/bt87x.c	Fri Feb 08 14:07:04 2008 -0200
+++ b/linux/sound/pci/bt87x.c	Sat Feb 09 16:09:13 2008 +0100
@@ -28,7 +28,7 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 #include <asm/io.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)
 #include <sound/driver.h>
 #endif
 #include <sound/core.h>

--Boundary-00=_EMcrHvCdONEdJdm
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_EMcrHvCdONEdJdm--
