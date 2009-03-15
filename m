Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:48958 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbZCOJz5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 05:55:57 -0400
Date: Sun, 15 Mar 2009 10:50:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
Message-ID: <20090315105037.6266687a@free.fr>
In-Reply-To: <Pine.LNX.4.58.0903141315300.28292@shell2.speakeasy.net>
References: <20090314125923.4229cd93@free.fr>
	<20090314091747.21153855@pedra.chehab.org>
	<Pine.LNX.4.58.0903141315300.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Mar 2009 13:16:11 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> There is already a sysfs led interface, you could just have the driver
> export the leds to the led subsystem and use that.

Yes, but:
- this asks to have a kernel generated with CONFIG_NEW_LEDS,
- the user must use some new program to access /sys/class/leds/<device>,
- he must know how the LEDs of his webcam are named in the /sys tree.

While, when the LEDs are handled by a simple control, the user may
quickly change all webcam parameters from a single program as v4l2-ctl.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
