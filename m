Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2ILiNV4031175
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 17:44:23 -0400
Received: from web88204.mail.re2.yahoo.com (web88204.mail.re2.yahoo.com
	[206.190.37.219])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2ILi6Dr029183
	for <video4linux-list@redhat.com>; Wed, 18 Mar 2009 17:44:06 -0400
Message-ID: <325912.25752.qm@web88204.mail.re2.yahoo.com>
Date: Wed, 18 Mar 2009 14:44:05 -0700 (PDT)
From: Dwaine Garden <dwainegarden@rogers.com>
To: linux-dvb@linuxtv.org, Linux and Kernel Video <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: 
Subject: Patch: usbvision: Convert the usbvision->lock semaphore to the
	mutex API
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

Looking at this patch.=A0 I have a couple of stupid questions.=0A=0A- up(&u=
sbvision->lock);=0A=0A+ mutex_unlock(&usbvision->lock);=0A=0A=A0=0A=0A+#if =
LINUX_VERSION_CODE > KERNEL_VERSION(2,6,15)=0A=0A+#include <linux/mutex.h>=
=0A=0A+#endif=0A=0A#include <media/v4l2-common.h>=0A=0A#include <media/tune=
r.h>=0A=0A#include <linux/videodev2.h>=0A=0A@@ -397,7 +400,11 @@ struct usb=
_usbvision {=0A=0Aunsigned char iface; /* Video interface number */=0A=0Aun=
signed char ifaceAlt; /* Alt settings */=0A=0Aunsigned char Vin_Reg2_Preset=
;=0A=0A- struct semaphore lock;=0A=0A+#if LINUX_VERSION_CODE > KERNEL_VERSI=
ON(2,6,15)=0A=0A+ struct mutex=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lo=
ck;=0A=0A+#else=0A=0A+ struct semaphore=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 lock;=
=0A=0A+#endif=0A=0ADo we really need to check the kernel version?=A0=A0 We =
just removed all the old susbvision->lock semaphores to the mutex API=0A=A0=
=0ADwaine=0A
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
