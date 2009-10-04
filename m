Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:49157 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZJDIpm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 04:45:42 -0400
Date: Sun, 4 Oct 2009 10:44:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@wilsonet.com>,
	linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
Message-ID: <20091004104452.7a6d0f9b@hyperion.delvare>
In-Reply-To: <20091004083139.GA20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	<20091004083139.GA20457@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 4 Oct 2009 11:31:39 +0300, Aleksandr V. Piskunov wrote:
> Tested on 2.6.30.8, one of Ubuntu mainline kernel builds.
> 
> ivtv-i2c part works, ivtv_i2c_new_ir() gets called, according to /sys/bus/i2c
> device @ 0x40 gets a name ir_rx_em78p153s_ave.
> 
> Now according to my (very) limited understanding of new binding model, ir-kbd-i2c
> should attach to this device by its name. Somehow it doesn't, ir-kbd-i2c gets loaded
> silently without doing anything.

Change the device name to a shorter string (e.g. "ir_rx_em78p153s").
You're hitting the i2c client name length limit. More details about
this in the details reply I'm writing right now.

-- 
Jean Delvare
