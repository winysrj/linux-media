Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m139ZwFR031923
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 04:35:58 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m139ZRkm010273
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 04:35:27 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: video4linux-list@redhat.com
Date: Sun, 3 Feb 2008 10:35:20 +0100
References: <200802021620.15038.tobias.lorenz@gmx.net>
	<200802021657.35685.tobias.lorenz@gmx.net>
	<4F7055831C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4F7055831C%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031035.20278.tobias.lorenz@gmx.net>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] Trivial printf warning fix (radio-si470)
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

Hi Darren,

> If that's right, can you explain why the warning which I saw mentioned "long
> unsigned int"...?

sure, you wrote:
> "format '%d' expects type 'int', but argument 3 has type 'long unsigned int'"
> (as seen on amd64)

Is guess your amd64 is a ia64 architecture.
Therefore ssize_t should be a long int on your machine.

It's always signed and must therefore be %...d instead of %...i.
The length modifier must be architecture/ssize_t dependent and therefore it comes to %zd.

I found this here on my linux-2.6.23.1:
<<< snip
cd /usr/src/linux/include
grep -r __kernel_ssize_t
asm/posix_types.h:typedef int           __kernel_ssize_t;
asm-alpha/posix_types.h:typedef long            __kernel_ssize_t;
asm-arm/posix_types.h:typedef int                       __kernel_ssize_t;
asm-avr32/posix_types.h:typedef long            __kernel_ssize_t;
asm-blackfin/posix_types.h:typedef long __kernel_ssize_t;
asm-cris/posix_types.h:typedef long             __kernel_ssize_t;
asm-frv/posix_types.h:typedef int               __kernel_ssize_t;
asm-h8300/posix_types.h:typedef int             __kernel_ssize_t;
asm-i386/posix_types.h:typedef int              __kernel_ssize_t;
asm-ia64/posix_types.h:typedef long             __kernel_ssize_t;
asm-m32r/posix_types.h:typedef int              __kernel_ssize_t;
asm-m68k/posix_types.h:typedef int              __kernel_ssize_t;
asm-mips/posix_types.h:typedef int              __kernel_ssize_t;
asm-mips/posix_types.h:typedef long             __kernel_ssize_t;
asm-parisc/posix_types.h:typedef long                   __kernel_ssize_t;
asm-parisc/posix_types.h:typedef int                    __kernel_ssize_t;
asm-powerpc/posix_types.h:typedef long          __kernel_ssize_t;
asm-powerpc/posix_types.h:typedef int           __kernel_ssize_t;
asm-s390/posix_types.h:typedef int             __kernel_ssize_t;
asm-s390/posix_types.h:typedef long            __kernel_ssize_t;
asm-sh/posix_types.h:typedef int                __kernel_ssize_t;
asm-sh64/posix_types.h:typedef int              __kernel_ssize_t;
asm-sparc/posix_types.h:typedef int                    __kernel_ssize_t;
asm-sparc64/posix_types.h:typedef long                   __kernel_ssize_t;
asm-v850/posix_types.h:typedef int              __kernel_ssize_t;
asm-x86_64/posix_types.h:typedef long           __kernel_ssize_t;
asm-xtensa/posix_types.h:typedef int            __kernel_ssize_t;
linux/types.h:typedef __kernel_ssize_t  ssize_t;
<<< snap

Bye,
  Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
