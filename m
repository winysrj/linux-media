Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d10.mx.aol.com ([205.188.108.134]:39454 "EHLO
	omr-d10.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab3GUN6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 09:58:45 -0400
Message-ID: <51EBE721.2010204@netscape.net>
Date: Sun, 21 Jul 2013 10:50:25 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org>
In-Reply-To: <20130718042314.2773b7c0.mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

It has given me the following error:

------------------------------------------------
alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): f9e5451 
[media] af9005-fe: convert set_fontend to use DVBv5 parameters
HEAD is now at f9e5451 [media] af9005-fe: convert set_fontend to use 
DVBv5 parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect good
Bisecting: 22 revisions left to test after this (roughly 5 steps)
[8de8594a79ae43b08d115c94f09373f6c673f202] [media] dvb-core: be sure 
that drivers won't use DVBv3 internally
alfredo@linux-puon:/usr/src/git/linux> make
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CHK     kernel/config_data.h
   CC      fs/compat_ioctl.o
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: array type has incomplete element type
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1346:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_parameters’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: array type has incomplete element type
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
fs/compat_ioctl.c:1347:1: error: invalid application of ‘sizeof’ to 
incomplete type ‘struct dvb_frontend_event’
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2
alfredo@linux-puon:/usr/src/git/linux>

-----------------------------------------------

What should I do now?
I do not want experiment, since "bisect" is a very long process.

Thank you,

Alfredo
