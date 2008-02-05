Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m15L9gkW019098
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 16:09:42 -0500
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.178])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m15L9LW1011914
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 16:09:22 -0500
Received: by ik-out-1112.google.com with SMTP id c21so336508ika.3
	for <video4linux-list@redhat.com>; Tue, 05 Feb 2008 13:09:21 -0800 (PST)
Message-ID: <9e52368f0802051309r79cc480fva893019cb3be4519@mail.gmail.com>
Date: Tue, 5 Feb 2008 16:09:19 -0500
From: "De Ash" <deeash099@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <9e52368f0802051130v68e63072m892cb084f081f61e@mail.gmail.com>
MIME-Version: 1.0
References: <9e52368f0802051130v68e63072m892cb084f081f61e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: build fail
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Got around building by taking out the conditional ifdefine..

changed

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
#include <sound/driver.h>
#endif

to
#include <sound/driver.h>


but now it gives error on mxb ..
make -C /usr/src/v4l-dvb/v4l
make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.24/build
make -C /lib/modules/2.6.24/build SUBDIRS=/usr/src/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/kernel-2.6.24/linux-2.6.24'
  CC [M]  /usr/src/v4l-dvb/v4l/mxb.o
/usr/src/v4l-dvb/v4l/mxb.c: In function 'mxb_check_clients':
/usr/src/v4l-dvb/v4l/mxb.c:156: error: implicit declaration of function
'i2c_verify_client'
/usr/src/v4l-dvb/v4l/mxb.c:156: warning: initialization makes pointer from
integer without a cast
make[3]: *** [/usr/src/v4l-dvb/v4l/mxb.o] Error 1
make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernel-2.6.24/linux-2.6.24'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Error 2



On Feb 5, 2008 2:30 PM, De Ash <deeash099@gmail.com> wrote:

> Folks,
>
> I am using kernel  2.6.24  from kernel.org.
> Checked out v4l-dvb and the make fails with the following ..
> Would appereciate help with this.
>
>  CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5110c1b.o
>   CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5110d.o
>   CC [M]  /usr/src/v4l-dvb/v4l/sn9c102_tas5130d1b.o
>   CC [M]  /usr/src/v4l-dvb/v4l/bt87x.o
> In file included from /usr/src/v4l-dvb/v4l/bt87x.c:34:
> include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in a
> function)
> make[3]: *** [/usr/src/v4l-dvb/v4l/bt87x.o] Error 1
> make[2]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/kernel-2.6.24/linux-2.6.24'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
> make: *** [all] Error 2
>
>
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
