Return-path: <linux-media-owner@vger.kernel.org>
Received: from elara.tizoo.com ([212.147.77.196]:54462 "EHLO elara.tizoo.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbeICNki (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 09:40:38 -0400
Received: from adsl-178-39-78-65.adslplus.ch ([178.39.78.65]:59036 helo=[192.168.178.37])
        by elara.tizoo.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <tjenni@retrodragon.com>)
        id 1fwkmu-00AEPA-Ks
        for linux-media@vger.kernel.org; Mon, 03 Sep 2018 11:04:48 +0200
To: linux-media@vger.kernel.org
From: Thomas Jenni <tjenni@retrodragon.com>
Subject: not able to build libv4lconvert on Ubuntu 16.04
Message-ID: <63805c4f-09cd-8a98-c2d9-7ec3f97cfbfb@retrodragon.com>
Date: Mon, 3 Sep 2018 11:04:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there !

I've tried to build libv4lconvert (ubuntu 16.04, 64bits) cloning the git.=


After removing the first line of the Makefile in the libv4lconvert
directory (that was set to arm architecture), the problem was that it
didn't find "linux/videodev.h".

I tried:

sudo ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h

but that was the same.

I tried:

sudo ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

and then it told me a lot things (that i don't understand):

In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1:0,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from /usr/include/linux/ioctl.h:4,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from ../libv4lconvert/libv4lsyscall-priv.h:41,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from log.c:21:
log.c:42:11: error: =E2=80=98VIDIOCKEY=E2=80=99 undeclared here (not in a=
 function)
=C2=A0 [_IOC_NR(VIDIOCKEY)]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=
 "VIDIOCKEY",
=2E..

Here's the complete log:


bobby@bobby-E202SA:~/Bureau/libv4lconvert$ git clone
https://github.com/ashwing920/libv4lconvert.git
Clonage dans 'libv4lconvert'...
remote: Counting objects: 113, done.
remote: Total 113 (delta 0), reused 0 (delta 0), pack-reused 113
R=C3=A9ception d'objets: 100% (113/113), 522.41 KiB | 687.00 KiB/s, fait.=

R=C3=A9solution des deltas: 100% (24/24), fait.
V=C3=A9rification de la connectivit=C3=A9... fait.
bobby@bobby-E202SA:~/Bureau/libv4lconvert$ make
make: *** Pas de cible sp=C3=A9cifi=C3=A9e et aucun makefile n'a =C3=A9t=C3=
=A9 trouv=C3=A9. Arr=C3=AAt.
bobby@bobby-E202SA:~/Bureau/libv4lconvert$ cd li*
bobby@bobby-E202SA:~/Bureau/libv4lconvert/libv4lconvert$ make
make -C libv4lconvert V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4lconvert=C2=
=A0=C2=BB
cc -Wp,-MMD,"libv4lconvert.d",-MQ,"libv4lconvert.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o libv4lconvert.o libv4lconvert=
=2Ec
cc -Wp,-MMD,"sn9c10x.d",-MQ,"sn9c10x.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o sn9c10x.o sn9c10x.c
cc -Wp,-MMD,"pac207.d",-MQ,"pac207.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o pac207.o pac207.c
cc -Wp,-MMD,"mr97310a.d",-MQ,"mr97310a.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o mr97310a.o mr97310a.c
cc -Wp,-MMD,"flip.d",-MQ,"flip.o",-MP -c -I../include -I../../../include
-fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4=
l\"
-g -O1 -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes
-Wmissing-prototypes -o flip.o flip.c
cc -Wp,-MMD,"crop.d",-MQ,"crop.o",-MP -c -I../include -I../../../include
-fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4=
l\"
-g -O1 -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes
-Wmissing-prototypes -o crop.o crop.c
cc -Wp,-MMD,"jidctflt.d",-MQ,"jidctflt.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o jidctflt.o jidctflt.c
cc -Wp,-MMD,"rgbyuv.d",-MQ,"rgbyuv.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o rgbyuv.o rgbyuv.c
cc -Wp,-MMD,"sn9c2028-decomp.d",-MQ,"sn9c2028-decomp.o",-MP -c
-I../include -I../../../include -fvisibility=3Dhidden
-DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
sn9c2028-decomp.o sn9c2028-decomp.c
cc -Wp,-MMD,"bayer.d",-MQ,"bayer.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o bayer.o bayer.c
cc -Wp,-MMD,"hm12.d",-MQ,"hm12.o",-MP -c -I../include -I../../../include
-fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4=
l\"
-g -O1 -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes
-Wmissing-prototypes -o hm12.o hm12.c
cc -Wp,-MMD,"control/libv4lcontrol.d",-MQ,"control/libv4lcontrol.o",-MP
-c -I../include -I../../../include -fvisibility=3Dhidden
-DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
control/libv4lcontrol.o control/libv4lcontrol.c
control/libv4lcontrol.c: In function =E2=80=98v4lcontrol_create=E2=80=99:=

control/libv4lcontrol.c:449:5: warning: ignoring return value of
=E2=80=98ftruncate=E2=80=99, declared with attribute warn_unused_result [=
-Wunused-result]
=C2=A0=C2=A0=C2=A0=C2=A0 ftruncate(shm_fd, V4LCONTROL_SHM_SIZE);
=C2=A0=C2=A0=C2=A0=C2=A0 ^
cc
-Wp,-MMD,"processing/libv4lprocessing.d",-MQ,"processing/libv4lprocessing=
=2Eo",-MP
-c -I../include -I../../../include -fvisibility=3Dhidden
-DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
processing/libv4lprocessing.o processing/libv4lprocessing.c
cc
-Wp,-MMD,"processing/whitebalance.d",-MQ,"processing/whitebalance.o",-MP
-c -I../include -I../../../include -fvisibility=3Dhidden
-DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
processing/whitebalance.o processing/whitebalance.c
cc -Wp,-MMD,"processing/autogain.d",-MQ,"processing/autogain.o",-MP -c
-I../include -I../../../include -fvisibility=3Dhidden
-DLIBDIR=3D\"/usr/local/lib\" -DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall
-Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
processing/autogain.o processing/autogain.c
cc -Wp,-MMD,"helper.d",-MQ,"helper.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -DLIBDIR=3D\"/usr/local/lib\"
-DLIBSUBDIR=3D\"libv4l\" -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o helper.o helper.c
ar cqs libv4lconvert.a libv4lconvert.o tinyjpeg.o sn9c10x.o sn9c20x.o
pac207.o mr97310a.o flip.o crop.o jidctflt.o spca561-decompress.o
rgbyuv.o sn9c2028-decomp.o spca501.o sq905c.o bayer.o hm12.o
control/libv4lcontrol.o processing/libv4lprocessing.o
processing/whitebalance.o processing/autogain.o processing/gamma.o helper=
=2Eo
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4lconvert=C2=
=A0=C2=BB
make -C libv4l2 V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l2=C2=A0=C2=
=BB
cc -Wp,-MMD,"libv4l2.d",-MQ,"libv4l2.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused
-Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o libv4l2.o
libv4l2.c
cc -Wp,-MMD,"log.d",-MQ,"log.o",-MP -c -I../include -I../../../include
-fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o log.o log.c
cc -shared=C2=A0 -Wl,-soname,../libv4lconvert/libv4lconvert.so.0 -o
=2E./libv4lconvert/libv4lconvert.so.0=C2=A0
ln -f -s ../libv4lconvert/libv4lconvert.so.0
=2E./libv4lconvert/libv4lconvert.so
cc -shared=C2=A0 -Wl,-soname,libv4l2.so.0 -o libv4l2.so.0 libv4l2.o log.o=

=2E./libv4lconvert/libv4lconvert.so -lpthread
ln -f -s libv4l2.so.0 libv4l2.so
cc -Wp,-MMD,"v4l2convert.d",-MQ,"v4l2convert.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused
-Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o
v4l2convert.o v4l2convert.c
cc -shared=C2=A0 -Wl,-soname,v4l2convert.so.0 -o v4l2convert.so.0
v4l2convert.o libv4l2.so
ln -f -s v4l2convert.so.0 v4l2convert.so
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l2=C2=A0=C2=
=BB
make -C libv4l1 V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l1=C2=A0=C2=
=BB
cc -Wp,-MMD,"libv4l1.d",-MQ,"libv4l1.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused
-Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o libv4l1.o
libv4l1.c
libv4l1.c:53:28: fatal error: linux/videodev.h: Aucun fichier ou dossier
de ce type
compilation terminated.
Makefile:81=C2=A0: la recette pour la cible =C2=AB=C2=A0libv4l1.o=C2=A0=C2=
=BB a =C3=A9chou=C3=A9e
make[1]: *** [libv4l1.o] Erreur 1
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l1=C2=A0=C2=
=BB
Makefile:5=C2=A0: la recette pour la cible =C2=AB=C2=A0all=C2=A0=C2=BB a =
=C3=A9chou=C3=A9e
make: *** [all] Erreur 2
bobby@bobby-E202SA:~/Bureau/libv4lconvert/libv4lconvert$ make
make -C libv4lconvert V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4lconvert=C2=
=A0=C2=BB
make[1]: rien =C3=A0 faire pour =C2=AB=C2=A0all=C2=A0=C2=BB.
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4lconvert=C2=
=A0=C2=BB
make -C libv4l2 V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l2=C2=A0=C2=
=BB
make[1]: rien =C3=A0 faire pour =C2=AB=C2=A0all=C2=A0=C2=BB.
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l2=C2=A0=C2=
=BB
make -C libv4l1 V4L2_LIB_VERSION=3D0.6.2-test all
make[1]=C2=A0: on entre dans le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l1=C2=A0=C2=
=BB
cc -Wp,-MMD,"libv4l1.d",-MQ,"libv4l1.o",-MP -c -I../include
-I../../../include -fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused
-Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes -o libv4l1.o
libv4l1.c
cc -Wp,-MMD,"log.d",-MQ,"log.o",-MP -c -I../include -I../../../include
-fvisibility=3Dhidden -fPIC -g -O1 -Wall -Wno-unused -Wpointer-arith
-Wstrict-prototypes -Wmissing-prototypes -o log.o log.c
In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1:0,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from /usr/include/linux/ioctl.h:4,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from ../libv4lconvert/libv4lsyscall-priv.h:41,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 from log.c:21:
log.c:42:11: error: =E2=80=98VIDIOCKEY=E2=80=99 undeclared here (not in a=
 function)
=C2=A0 [_IOC_NR(VIDIOCKEY)]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=
 "VIDIOCKEY",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:42:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCKEY)]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=
 "VIDIOCKEY",
=C2=A0=C2=A0 ^
log.c:42:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:50:11: error: =E2=80=98VIDIOCGUNIT=E2=80=99 undeclared here (not in=
 a function)
=C2=A0 [_IOC_NR(VIDIOCGUNIT)]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VIDIOCGU=
NIT",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:50:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCGUNIT)]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VIDIOCGU=
NIT",
=C2=A0=C2=A0 ^
log.c:50:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:51:11: error: =E2=80=98VIDIOCGCAPTURE=E2=80=99 undeclared here (not=
 in a function)
=C2=A0 [_IOC_NR(VIDIOCGCAPTURE)]=C2=A0=C2=A0 =3D "VIDIOCGCAPTURE",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:51:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCGCAPTURE)]=C2=A0=C2=A0 =3D "VIDIOCGCAPTURE",
=C2=A0=C2=A0 ^
log.c:51:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:52:11: error: =E2=80=98VIDIOCSCAPTURE=E2=80=99 undeclared here (not=
 in a function)
=C2=A0 [_IOC_NR(VIDIOCSCAPTURE)]=C2=A0=C2=A0 =3D "VIDIOCSCAPTURE",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:52:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCSCAPTURE)]=C2=A0=C2=A0 =3D "VIDIOCSCAPTURE",
=C2=A0=C2=A0 ^
log.c:52:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:53:11: error: =E2=80=98VIDIOCSPLAYMODE=E2=80=99 undeclared here (no=
t in a function)
=C2=A0 [_IOC_NR(VIDIOCSPLAYMODE)]=C2=A0 =3D "VIDIOCSPLAYMODE",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:53:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCSPLAYMODE)]=C2=A0 =3D "VIDIOCSPLAYMODE",
=C2=A0=C2=A0 ^
log.c:53:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:54:11: error: =E2=80=98VIDIOCSWRITEMODE=E2=80=99 undeclared here (n=
ot in a function)
=C2=A0 [_IOC_NR(VIDIOCSWRITEMODE)] =3D "VIDIOCSWRITEMODE",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:54:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCSWRITEMODE)] =3D "VIDIOCSWRITEMODE",
=C2=A0=C2=A0 ^
log.c:54:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:55:11: error: =E2=80=98VIDIOCGPLAYINFO=E2=80=99 undeclared here (no=
t in a function)
=C2=A0 [_IOC_NR(VIDIOCGPLAYINFO)]=C2=A0 =3D "VIDIOCGPLAYINFO",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:55:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCGPLAYINFO)]=C2=A0 =3D "VIDIOCGPLAYINFO",
=C2=A0=C2=A0 ^
log.c:55:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

log.c:56:11: error: =E2=80=98VIDIOCSMICROCODE=E2=80=99 undeclared here (n=
ot in a function)
=C2=A0 [_IOC_NR(VIDIOCSMICROCODE)] =3D "VIDIOCSMICROCODE",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
log.c:56:3: error: array index in initializer not of integer type
=C2=A0 [_IOC_NR(VIDIOCSMICROCODE)] =3D "VIDIOCSMICROCODE",
=C2=A0=C2=A0 ^
log.c:56:3: note: (near initialization for =E2=80=98v4l1_ioctls=E2=80=99)=

Makefile:81=C2=A0: la recette pour la cible =C2=AB=C2=A0log.o=C2=A0=C2=BB=
 a =C3=A9chou=C3=A9e
make[1]: *** [log.o] Erreur 1
make[1]=C2=A0: on quitte le r=C3=A9pertoire
=C2=AB=C2=A0/home/bobby/Bureau/libv4lconvert/libv4lconvert/libv4l1=C2=A0=C2=
=BB
Makefile:5=C2=A0: la recette pour la cible =C2=AB=C2=A0all=C2=A0=C2=BB a =
=C3=A9chou=C3=A9e
make: *** [all] Erreur 2
bobby@bobby-E202SA:~/Bureau/libv4lconvert/libv4lconvert$



Best regards,

Thomas
