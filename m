Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58573 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030211AbbFEOnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:43:24 -0400
Date: Fri, 5 Jun 2015 11:43:19 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/9] Some smatch fixups
Message-ID: <20150605114319.57cc5035@recife.lan>
In-Reply-To: <cover.1433511345.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
	<cover.1433511345.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 05 Jun 2015 11:27:33 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Fix several smatch warnings.
> 
> There are still 27 smatch warnings at drivers/media:

Please discard this e-mail. Git sent it by accident. This is a version
of patch 0/11, saved with another name (and another extension).

The same applies to the other e-mail with the very same subject.

The real one is "[PATCH 00/11] Some smatch fixups".

> 
> 
> This one:
> 	drivers/media/pci/cx23885/cx23885-dvb.c:2046 dvb_register() Function too hairy.  Giving up.
> 
> It is just to a random memory limit at smatch that allows it to
> allocate only 50Mb of memory for name allocation. I fixed it
> locally and submitted a fix to Dan.
> 
> Those seem to be false-positives:
> 	drivers/media/dvb-frontends/stv0900_core.c:1183 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
> 	drivers/media/dvb-frontends/stv0900_core.c:1185 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
> 	drivers/media/dvb-frontends/stv0900_core.c:1187 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
> 	drivers/media/dvb-frontends/stv0900_core.c:1189 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
> 	drivers/media/dvb-frontends/stv0900_core.c:1191 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
> 	drivers/media/media-entity.c:238:17: warning: Variable length array is used.
> 	drivers/media/media-entity.c:239:17: warning: Variable length array is used.
> 	drivers/media/pci/ttpci/av7110.c:2210 frontend_init() warn: missing break? reassigning 'av7110->fe'
> 	drivers/media/pci/ttpci/budget.c:631 frontend_init() warn: missing break? reassigning 'budget->dvb_frontend'
> 	drivers/media/platform/vivid/vivid-rds-gen.c:82 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 43
> 	drivers/media/platform/vivid/vivid-rds-gen.c:83 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 42
> 	drivers/media/platform/vivid/vivid-rds-gen.c:89 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 84
> 	drivers/media/platform/vivid/vivid-rds-gen.c:90 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 85
> 	drivers/media/platform/vivid/vivid-rds-gen.c:92 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 86
> 	drivers/media/platform/vivid/vivid-rds-gen.c:93 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 87
> 	drivers/media/radio/radio-aimslab.c:73 rtrack_alloc() warn: possible memory leak of 'rt'
> 	drivers/media/radio/radio-aztech.c:87 aztech_alloc() warn: possible memory leak of 'az'
> 	drivers/media/radio/radio-gemtek.c:189 gemtek_alloc() warn: possible memory leak of 'gt'
> 	drivers/media/radio/radio-trust.c:60 trust_alloc() warn: possible memory leak of 'tr'
> 	drivers/media/radio/radio-typhoon.c:79 typhoon_alloc() warn: possible memory leak of 'ty'
> 	drivers/media/radio/radio-zoltrix.c:83 zoltrix_alloc() warn: possible memory leak of 'zol'
> 	drivers/media/usb/pvrusb2/pvrusb2-encoder.c:227 pvr2_encoder_cmd() error: buffer overflow 'wrData' 16 <= 16
> 	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3676 pvr2_send_request_ex() error: we previously assumed 'write_data' could be null (see line 3648)
> 	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3829 pvr2_send_request_ex() error: we previously assumed 'read_data' could be null (see line 3649)
> 
> I didn't find an easy/worth way to remove the above.
> 
> This one is due to a code that got commented:
> 	drivers/media/usb/usbvision/usbvision-video.c:1072 usbvision_read() warn: inconsistent indenting
> 
> Probably the best here is to remove the commented code and fix 
> identation.
> 
> This one seems a real bug, but fixing it would require some tests with 
> the hardware, and a better understanding on what the function should be 
> expecting to do when steal is NULL:
> 	drivers/media/pci/ivtv/ivtv-queue.c:145 ivtv_queue_move() error: we previously assumed 'steal' could be null (see line 138)
> 
> Mauro Carvalho Chehab (9):
>   [media] drxk: better handle errors
>   [media] em28xx: remove dead code
>   [media] sh_vou: avoid going past arrays
>   dib0090: Remove a dead code
>   [media] bt8xx: remove needless check
>   [media] ivtv: fix two smatch warnings
>   tm6000: remove needless check
>   [media] ir: Fix IR_MAX_DURATION enforcement
>   rc: set IR_MAX_DURATION to 500 ms
> 
>  drivers/media/dvb-frontends/dib0090.c   |   4 +-
>  drivers/media/dvb-frontends/drxk_hard.c |   7 +-
>  drivers/media/pci/bt8xx/dst_ca.c        | 132 ++++++++++++++++----------------
>  drivers/media/pci/ivtv/ivtv-driver.h    |   3 +-
>  drivers/media/platform/sh_vou.c         |  14 ++--
>  drivers/media/rc/redrat3.c              |   5 +-
>  drivers/media/rc/streamzap.c            |   6 +-
>  drivers/media/usb/em28xx/em28xx-video.c |   1 -
>  drivers/media/usb/tm6000/tm6000-video.c |   2 +-
>  include/media/rc-core.h                 |   2 +-
>  10 files changed, 87 insertions(+), 89 deletions(-)
> 
