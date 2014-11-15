Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45233 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaKOSzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 13:55:05 -0500
Date: Sat, 15 Nov 2014 16:54:58 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Stephan Raue <mailinglists@openelec.tv>
Cc: linux-input@vger.kernel.org, david@hardeman.nu,
	linux-media@vger.kernel.org
Subject: Re: bisected: IR press/release behavior changed in 3.17, repeat
 events
Message-ID: <20141115165458.5e788b44@recife.lan>
In-Reply-To: <54679469.1010500@openelec.tv>
References: <54679469.1010500@openelec.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stephan,

C/C linux-media, as this is the right ML for IR discussions.

Em Sat, 15 Nov 2014 18:59:05 +0100
Stephan Raue <mailinglists@openelec.tv> escreveu:

> Hi
> 
> with kernel 3.17 using a RC6 remote with a buildin nuvoton IR receiver 
> (not tested others, but i think its a common problem) when 
> pressing/releasing the same button often within 1 second there will no 
> release event sent. Instead we get repeat events. To get the release 
> event i must press the same button with a delay of ~ 1sec.
> 
> the evtest output for kernel with the difference 3.16 and 3.17 looks like
> 
> kernel 3.16
> 
> Event: time 1415452412.497503, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> Event: time 1415452412.497503, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452412.497503, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415452412.497503, -------------- SYN_REPORT ------------
> Event: time 1415452412.672387, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452412.672387, -------------- SYN_REPORT ------------
> Event: time 1415452412.919799, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> Event: time 1415452412.919799, -------------- SYN_REPORT ------------
> Event: time 1415452414.363169, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452414.363169, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415452414.363169, -------------- SYN_REPORT ------------
> Event: time 1415452414.538010, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452414.538010, -------------- SYN_REPORT ------------
> Event: time 1415452414.621916, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> Event: time 1415452414.621916, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452414.621916, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415452414.621916, -------------- SYN_REPORT ------------
> Event: time 1415452414.818869, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> Event: time 1415452414.818869, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452414.818869, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415452414.818869, -------------- SYN_REPORT ------------
> Event: time 1415452414.994902, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> Event: time 1415452414.994902, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415452414.994902, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415452414.994902, -------------- SYN_REPORT ------------
> 
> 
> 
> kernel 3.17
> 
> Event: time 1415454057.620687, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454057.620687, type 1 (EV_KEY), code 108 (KEY_DOWN), value 1
> Event: time 1415454057.620687, -------------- SYN_REPORT ------------
> Event: time 1415454057.795567, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454057.795567, -------------- SYN_REPORT ------------
> Event: time 1415454057.896636, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454057.896636, -------------- SYN_REPORT ------------
> Event: time 1415454058.056369, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.056369, -------------- SYN_REPORT ------------
> Event: time 1415454058.210349, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.210349, -------------- SYN_REPORT ------------
> Event: time 1415454058.371157, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.371157, -------------- SYN_REPORT ------------
> Event: time 1415454058.540551, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.540551, -------------- SYN_REPORT ------------
> Event: time 1415454058.622935, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454058.622935, -------------- SYN_REPORT ------------
> Event: time 1415454058.696211, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.696211, -------------- SYN_REPORT ------------
> Event: time 1415454058.749595, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454058.749595, -------------- SYN_REPORT ------------
> Event: time 1415454058.849992, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454058.849992, -------------- SYN_REPORT ------------
> Event: time 1415454058.876332, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454058.876332, -------------- SYN_REPORT ------------
> Event: time 1415454059.002998, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454059.002998, -------------- SYN_REPORT ------------
> Event: time 1415454059.008823, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454059.008823, -------------- SYN_REPORT ------------
> Event: time 1415454059.129614, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454059.129614, -------------- SYN_REPORT ------------
> Event: time 1415454059.179093, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454059.179093, -------------- SYN_REPORT ------------
> Event: time 1415454059.256285, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454059.256285, -------------- SYN_REPORT ------------
> Event: time 1415454059.346881, type 4 (EV_MSC), code 4 (MSC_SCAN), value 
> 800f041f
> Event: time 1415454059.346881, -------------- SYN_REPORT ------------
> Event: time 1415454059.382993, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454059.382993, -------------- SYN_REPORT ------------
> Event: time 1415454059.509617, type 1 (EV_KEY), code 108 (KEY_DOWN), value 2
> Event: time 1415454059.509617, -------------- SYN_REPORT ------------
> Event: time 1415454059.596281, type 1 (EV_KEY), code 108 (KEY_DOWN), value 0
> 
> with irw it looks like:
> 
> kernel 3.16
> OpenELEC:~ # irw
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 
> kernel 3.17 (the first 2 presses was pressed with a delay of more then 1 
> sec:
> OpenELEC:~ # irw
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 6c 0 KEY_DOWN devinput
> 6c 1 KEY_DOWN devinput
> 6c 2 KEY_DOWN devinput
> 6c 3 KEY_DOWN devinput
> 6c 4 KEY_DOWN devinput
> 6c 5 KEY_DOWN devinput
> 6c 6 KEY_DOWN devinput
> 6c 7 KEY_DOWN devinput
> 6c 8 KEY_DOWN devinput
> 6c 9 KEY_DOWN devinput
> 6c a KEY_DOWN devinput
> 6c b KEY_DOWN devinput
> 6c c KEY_DOWN devinput
> 6c d KEY_DOWN devinput
> 6c e KEY_DOWN devinput
> 6c f KEY_DOWN devinput
> 6c 10 KEY_DOWN devinput
> 6c 11 KEY_DOWN devinput
> 6c 12 KEY_DOWN devinput
> 6c 13 KEY_DOWN devinput
> 6c 14 KEY_DOWN devinput
> 6c 15 KEY_DOWN devinput
> 6c 0 KEY_DOWN_UP devinput
> 
> 
> i have bisected the issue:
> 
> [stephan@buildserver linux-3.17-bisect]$ git bisect good
> 120703f9eb32033f0e39bdc552c0273c8ab45f33 is the first bad commit
> commit 120703f9eb32033f0e39bdc552c0273c8ab45f33
> Author: David Härdeman <david@hardeman.nu>
> Date:   Thu Apr 3 20:31:30 2014 -0300
> 
>      [media] rc-core: document the protocol type
> 
>      Right now the protocol information is not preserved, rc-core gets 
> handed a
>      scancode but has no idea which protocol it corresponds to.
> 
>      This patch (which required reading through the source/keymap for 
> all drivers,
>      not fun) makes the protocol information explicit which is important
>      documentation and makes it easier to e.g. support multiple 
> protocols with one
>      decoder (think rc5 and rc-streamzap). The information isn't used 
> yet so there
>      should be no functional changes.
> 
>      [m.chehab@samsung.com: rebased, added cxusb and removed bad 
> whitespacing]
>      Signed-off-by: David Härdeman <david@hardeman.nu>
>      Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> :040000 040000 3db25c8acb78f27a4c6613e9fddbf9af8d1ea65e 
> bc5866551b8c1a7dc8d4eaf35def332f20321122 M    drivers
> :040000 040000 e69773356627779a7cdf905e11619a310fbfaeee 
> aef9c358ea71385d2b83b498ce1e2c5568f257a7 M    include
> 
