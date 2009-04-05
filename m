Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:48743 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZDEOiP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 10:38:15 -0400
Date: Sun, 5 Apr 2009 16:37:49 +0200
From: Janne Grunau <j@jannau.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
Message-ID: <20090405143748.GC10556@aniel>
References: <20090404142427.6e81f316@hyperion.delvare> <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net> <20090405010539.187e6268@hyperion.delvare> <200904050746.47451.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904050746.47451.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 05, 2009 at 07:46:47AM +0200, Hans Verkuil wrote:
>
> Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> drivers that did not autoload this module. The driver author can refine 
> things later (I'll definitely will do that for ivtv).
> 
> It will be interesting if someone can find out whether lirc will work at all 
> once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> wake them up to the realization that they really need to move to the 
> kernel.

I would guess that it won't work. There is an effort to merge lirc. It's
currently stalled though. A git tree is available at

git://git.wilsonet.com/linux-2.6-lirc.git

Jared Wilson and I were working on it (mainly last september). Since the
IR on the HD PVR is also driven by the same zilog chip as on other
hauppauge devices I'll take of lirc_zilog. Help converting the i2c
drivers to the new i2c model is welcome. General cleanup of lirc to make
it ready for mainline is of course wellcome too.

Janne
