Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from v1696.ncsrv.de ([89.110.150.180] helo=duerrhauer.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@duerrhauer.de>) id 1JNr9q-00059U-0f
	for linux-dvb@linuxtv.org; Sat, 09 Feb 2008 15:58:22 +0100
Message-ID: <47ADBF84.60006@duerrhauer.de>
Date: Sat, 09 Feb 2008 15:58:12 +0100
From: =?ISO-8859-1?Q?Christian_D=FCrrhauer?= <christian@duerrhauer.de>
MIME-Version: 1.0
To: christian@duerrhauer.de
References: <47AD998C.8090809@duerrhauer.de> <47ADBE15.1040908@duerrhauer.de>
In-Reply-To: <47ADBE15.1040908@duerrhauer.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] gentoo: v4l-dvb-hg doesn't compile with kernel
	2.6.24-gentoo
Reply-To: christian@duerrhauer.de
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christian D=FCrrhauer wrote:
> Christian D=FCrrhauer wrote:
> =

> I add a link to somebody else with the same problem:
> http://www.alionet.org/index.php?showtopic=3D19216
> =


sorry, I didn't get my previous mail now, I see, so I am adding it.
What went wrong I don't know.

Christian

Hi,

the v4l-dvb-hg doesn't compile with the new kernel 2.6.24-gentoo. I am =

pretty sure I followed the instruction from the vdr-wiki for installing =

the drivers (kernel options). I have just for security rebuild the =

kernel using genkernel --clean --menuconfig all.

As the ebuild is just pulling the source from mercurial, I thought, I =

just leave a message here and maybe somebody can look into it.

   CC [M] =

/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.o
   CC [M] =

/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/stk-webcam.o
   CC [M] =

/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/stk-sensor.o
In file included from =

/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.c:34:
include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a =

function)
make[2]: *** =

[/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/bt87x.o] =

Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** =

[_module_/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l] =

Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.24-gentoo'
make: *** [default] Error 2
  *
  * ERROR: media-tv/v4l-dvb-hg-0.1-r2 failed.
  * Call stack:
  *          ebuild.sh, line 1701:  Called dyn_compile
  *          ebuild.sh, line 1039:  Called qa_call 'src_compile'
  *          ebuild.sh, line   44:  Called src_compile
  *          ebuild.sh, line 1383:  Called linux-mod_src_compile
  *   linux-mod.eclass, line  519:  Called die
  * The specific snippet of code:
  *                      emake HOSTCC=3D"$(tc-getBUILD_CC)" =

CC=3D"$(get-KERNEL_CC)" LDFLAGS=3D"$(get_abi_LDFLAGS)" \
  *                                ${BUILD_FIXES} ${BUILD_PARAMS} =

${BUILD_TARGETS} \
  *                              || die "Unable to make ${BUILD_FIXES} =

${BUILD_PARAMS} ${BUILD_TARGETS}."
  *  The die message:
  *   Unable to make  KDIR=3D/usr/src/linux default.
  *
  * If you need support, post the topmost build error, and the call =

stack if relevant.
  * A complete build log is located at =

'/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/temp/build.log'.
  *

Any help is greatly appreciated! :-)

Kind regards,

Christian




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
