Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64994 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZJDJ1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 05:27:05 -0400
Received: by fxm27 with SMTP id 27so2221291fxm.17
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 02:26:27 -0700 (PDT)
Date: Sun, 4 Oct 2009 12:26:21 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
	M116 for newer kernels
Message-ID: <20091004092621.GB20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org> <20091004083139.GA20457@moon> <20091004104452.7a6d0f9b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004104452.7a6d0f9b@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 04, 2009 at 10:44:52AM +0200, Jean Delvare wrote:
> On Sun, 4 Oct 2009 11:31:39 +0300, Aleksandr V. Piskunov wrote:
> > Tested on 2.6.30.8, one of Ubuntu mainline kernel builds.
> > 
> > ivtv-i2c part works, ivtv_i2c_new_ir() gets called, according to /sys/bus/i2c
> > device @ 0x40 gets a name ir_rx_em78p153s_ave.
> > 
> > Now according to my (very) limited understanding of new binding model, ir-kbd-i2c
> > should attach to this device by its name. Somehow it doesn't, ir-kbd-i2c gets loaded
> > silently without doing anything.
> 
> Change the device name to a shorter string (e.g. "ir_rx_em78p153s").
> You're hitting the i2c client name length limit. More details about
> this in the details reply I'm writing right now.

Thanks, it works now. ir-kbd-i2c picks up the short name, input device is created, remote
works.

Another place where truncation occurs is name field in em78p153s_aver_ir_init_data 
("ivtv-CX23416 EM78P153S AVerMedia"). Actual input device ends up with a name
"i2c IR (ivtv-CX23416 EM78P153S ", limited by char name[32] in IR_i2c struct.

IMHO actual name of resulting input device should be readable by end-user. Perhaps it should
include the short name of the card itself, or model/color of remote control itself if several
revisions exist, etc.
