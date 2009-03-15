Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:63264 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757217AbZCOKPq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 06:15:46 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] LED control
Date: Sun, 15 Mar 2009 11:16:14 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <20090314125923.4229cd93@free.fr> <Pine.LNX.4.58.0903141315300.28292@shell2.speakeasy.net> <20090315105037.6266687a@free.fr>
In-Reply-To: <20090315105037.6266687a@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151116.14964.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 10:50:37 Jean-Francois Moine wrote:
> On Sat, 14 Mar 2009 13:16:11 -0700 (PDT)
>
> Trent Piepho <xyzzy@speakeasy.org> wrote:
> > There is already a sysfs led interface, you could just have the driver
> > export the leds to the led subsystem and use that.
>
> Yes, but:
> - this asks to have a kernel generated with CONFIG_NEW_LEDS,
> - the user must use some new program to access /sys/class/leds/<device>,
> - he must know how the LEDs of his webcam are named in the /sys tree.
>
> While, when the LEDs are handled by a simple control, the user may
> quickly change all webcam parameters from a single program as v4l2-ctl.

This would work if devices only exported a few simple LED controls. If we 
throw multi-color blinking LEDs in the mix we will need a complete LED API 
anyway.

Laurent Pinchart

