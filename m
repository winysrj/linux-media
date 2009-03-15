Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:57291 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZCOPO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 11:14:58 -0400
Date: Sun, 15 Mar 2009 08:14:56 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean-Francois Moine <moinejf@free.fr>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] LED control
In-Reply-To: <20090315105037.6266687a@free.fr>
Message-ID: <Pine.LNX.4.58.0903150805140.28292@shell2.speakeasy.net>
References: <20090314125923.4229cd93@free.fr> <20090314091747.21153855@pedra.chehab.org>
 <Pine.LNX.4.58.0903141315300.28292@shell2.speakeasy.net> <20090315105037.6266687a@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Jean-Francois Moine wrote:
> On Sat, 14 Mar 2009 13:16:11 -0700 (PDT)
> Trent Piepho <xyzzy@speakeasy.org> wrote:
>
> > There is already a sysfs led interface, you could just have the driver
> > export the leds to the led subsystem and use that.
>
> Yes, but:
> - this asks to have a kernel generated with CONFIG_NEW_LEDS,

So?

> - the user must use some new program to access /sys/class/leds/<device>,

echo, cat?

> - he must know how the LEDs of his webcam are named in the /sys tree.

Just give them a name like video0:power and it will be easy enough to
associate them with the device.  I think links in sysfs would do it to,
/sys/class/video4linux/video0/device/<ledname> or something like that.

The advantage of using the led class is that you get support for triggers
and automatic blink functions, etc.
