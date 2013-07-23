Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m10.mx.aol.com ([64.12.143.86]:33993 "EHLO
	omr-m10.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab3GWU7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 16:59:38 -0400
Message-ID: <51EEEE6C.7000309@netscape.net>
Date: Tue, 23 Jul 2013 17:58:20 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org> <51EBE721.2010204@netscape.net>
In-Reply-To: <51EBE721.2010204@netscape.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

As was a compilation error, I used git bisect skip. From what I've come up with something that I think is not what I'm looking for.

Is it advisable to do it again? and where you get an error trying to git bisect bad and see where it arrived and then git bisec good again.

what I got was:

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): a08d2c7 [media] pwc: Remove driver specific ioctls
HEAD is now at a08d2c7 [media] pwc: Remove driver specific ioctls
alfredo@linux-puon:/usr/src/git/linux> git bisect bad
Bisecting: 92 revisions left to test after this (roughly 7 steps)
[38e3d7ce41cff58bacebb2bcecf7d386c60b954b] [media] cx23885: Ensure the MPEG encoder height is configured from the norm
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): 38e3d7c [media] cx23885: Ensure the MPEG encoder height is configured from the norm
HEAD is now at 38e3d7c [media] cx23885: Ensure the MPEG encoder height is configured from the norm
alfredo@linux-puon:/usr/src/git/linux> git bisect bad
Bisecting: 45 revisions left to test after this (roughly 6 steps)
[f9e54512fd16379812bcff86d95d0a7d78028b20] [media] af9005-fe: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): f9e5451 [media] af9005-fe: convert set_fontend to use DVBv5 parameters
HEAD is now at f9e5451 [media] af9005-fe: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect good
Bisecting: 22 revisions left to test after this (roughly 5 steps)
[8de8594a79ae43b08d115c94f09373f6c673f202] [media] dvb-core: be sure that drivers won't use DVBv3 internally
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CC      fs/compat_ioctl.o
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_event’
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2
alfredo@linux-puon:/usr/src/git/linux>
alfredo@linux-puon:/usr/src/git/linux> git bisect skip
Bisecting: 22 revisions left to test after this (roughly 5 steps)
[a7d44baaed0a8c7d4c4fb47938455cb3fc2bb1eb] [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): a7d44ba [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
HEAD is now at a7d44ba [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
alfredo@linux-puon:/usr/src/git/linux> git bisect bad
Bisecting: 10 revisions left to test after this (roughly 4 steps)
[2827e1ff8692289a9767ab15be9671bb8df77f79] [media] tlg2300: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): 2827e1f [media] tlg2300: convert set_fontend to use DVBv5 parameters
HEAD is now at 2827e1f [media] tlg2300: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect bad
Bisecting: 4 revisions left to test after this (roughly 3 steps)
[4fa102d5cc5b412fa3bc7cc8c24e4d9052e4f693] [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): 4fa102d [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
HEAD is now at 4fa102d [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect good
Bisecting: 1 revision left to test after this (roughly 1 step)
[15115c17cb1a264a265d6d4769ae0397ed61e630] [media] siano: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): 15115c1 [media] siano: convert set_fontend to use DVBv5 parameters
HEAD is now at 15115c1 [media] siano: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect good
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[f159451c12f47acec84d13028781e9a296dbdd7b] [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux>

...
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): f159451 [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
HEAD is now at f159451 [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect good
2827e1ff8692289a9767ab15be9671bb8df77f79 is the first bad commit
commit 2827e1ff8692289a9767ab15be9671bb8df77f79
Author: Mauro Carvalho Chehab <mchehab          .com>
Date:   Mon Dec 26 16:40:17 2011 -0300

    [media] tlg2300: convert set_fontend to use DVBv5 parameters

    Instead of using dvb_frontend_parameters struct, that were
    designed for a subset of the supported standards, use the DVBv5
    cache information.

    Also, fill the supported delivery systems at dvb_frontend_ops
    struct.

    Signed-off-by: Mauro Carvalho Chehab <mchehab          .com>

:040000 040000 c381a643177407f5231c472f7716e9b4acc858c6 0666c6a6ce8e18c474b8f33fa1d096929106617b M      drivers
alfredo@linux-puon:/usr/src/git/linux>


Thanks in advance,

Alfredo
