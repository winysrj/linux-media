Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:41026 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0IMGqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 02:46:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Mon, 13 Sep 2010 08:47:24 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <4C860972.6020602@redhat.com> <201009071147.22643.hverkuil@xs4all.nl>
In-Reply-To: <201009071147.22643.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130847.24841.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi Hans,

On Tuesday 07 September 2010 11:47:22 Hans Verkuil wrote:

[snip]

> But I can guarantee that we will get video devices with multiple leds in
> the future.

What about devices with illumination LEDs that can be dimmed ?

> So we need to think *now* about how to do this. One simple
> option is of course to name the controls CID_ILLUMINATOR0 and CID_LED0.
> That way we can easily add LED1, LED2, etc. later without running into
> weird inconsistent control names.

-- 
Regards,

Laurent Pinchart
