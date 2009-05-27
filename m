Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbZE0Sew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 14:34:52 -0400
Date: Wed, 27 May 2009 15:34:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Antonio Beamud Montero <antonio.beamud@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-dvb and old kernels
Message-ID: <20090527153449.553a107f@pedra.chehab.org>
In-Reply-To: <4A1BE8BC.3010901@gmail.com>
References: <4A1BE8BC.3010901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 May 2009 15:03:56 +0200
Antonio Beamud Montero <antonio.beamud@gmail.com> escreveu:

> It would compile today's snapshot of v4l-dvb with an old kernel version 
> (for example 2.6.16)? (or is better to upgrade the kernel?)
> 
> Trying to compile today's mercurial snapshot in a SuSE 10.1 (2.6.16-21), 
> give the next errors:
> 
> /root/v4l-dvb/v4l/bttv-i2c.c: In function 'init_bttv_i2c':
> /root/v4l-dvb/v4l/bttv-i2c.c:411: error: storage size of 'info' isn't known
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
> to incomplete type 'struct i2c_board_info'
> /root/v4l-dvb/v4l/bttv-i2c.c:427: error: implicit declaration of 
> function 'i2c_new_probed_device'
> /root/v4l-dvb/v4l/bttv-i2c.c:411: warning: unused variable 'info'
> make[5]: *** [/root/v4l-dvb/v4l/bttv-i2c.o] Error 1

The issue should be fixed with the current tip. I just added a backport patch
that will restore backward compilation starting from 2.6.16



Cheers,
Mauro
