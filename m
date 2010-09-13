Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1423 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab0IMG74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 02:59:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Mon, 13 Sep 2010 08:59:40 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <201009071147.22643.hverkuil@xs4all.nl> <201009130847.24841.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009130847.24841.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130859.40177.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Monday, September 13, 2010 08:47:24 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 07 September 2010 11:47:22 Hans Verkuil wrote:
> 
> [snip]
> 
> > But I can guarantee that we will get video devices with multiple leds in
> > the future.
> 
> What about devices with illumination LEDs that can be dimmed ?

That will be a separate control (e.g. ILLUMINATOR_BRIGHTNESS or something
like that). This is just basic on/off.

Regards,

	Hans

> 
> > So we need to think *now* about how to do this. One simple
> > option is of course to name the controls CID_ILLUMINATOR0 and CID_LED0.
> > That way we can easily add LED1, LED2, etc. later without running into
> > weird inconsistent control names.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
