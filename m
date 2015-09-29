Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38837 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbbI2S7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 14:59:52 -0400
Received: by igxx6 with SMTP id x6so14210662igx.1
        for <linux-media@vger.kernel.org>; Tue, 29 Sep 2015 11:59:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Sep 2015 21:59:51 +0300
Message-ID: <CAM_ZknUEP73dQ2eEtVM_A_psAwcovKeiCDhpNgW+Fo96RRKM2w@mail.gmail.com>
Subject: H264 headers generation for driver
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: "kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
	khalasa <khalasa@piap.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a new chapter of tw5864 video grabber & encoder driver
development drama.
Last state of code is here (tw5864 branch, drivers/staging/media/tw5864):
https://github.com/bluecherrydvr/linux/tree/tw5864/drivers/staging/media/tw5864

Currently I use a third-side LGPL library for H.264 headers generation
- SPS, PPS and slice headers (because device doesn't generate them).
It is included as a git submodule "h264bitstream". It is used from
tw5864-h264.c .
Of course we want our driver to get to upstream repository when it
matures enough, that's why we want to ask for advice regarding this.
I see that there is no similar case in upstream kernel repo - no
submodules and no libraries for H264 bitstreams.
Device datasheet
(http://lizard.bluecherry.net/~autkin/tw5864/tw5864b1-ds.pdf , page
47) shows that there's almost no variety of modes, so minimally an
implementation of bitstream writing functions ue() and se() will
suffice.
I guess that one acceptable way is to pre-generate all headers for all
needed cases and ship them inlined; for correctness checking purpose,
it is possible to ship also a script or additional source code file
which is able to generate same headers.
Please advise.

Thanks in advance for any kind reply.

-- 
Bluecherry developer.
