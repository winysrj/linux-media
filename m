Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34793 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0IGR5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 13:57:15 -0400
Date: Tue, 7 Sep 2010 19:57:18 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
Message-ID: <20100907195718.066b2986@tele>
In-Reply-To: <201009071730.33642.hverkuil@xs4all.nl>
References: <20100906201105.4029d7e7@tele>
	<201009071650.21029.hverkuil@xs4all.nl>
	<4C863877.3000005@redhat.com>
	<201009071730.33642.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, 7 Sep 2010 17:30:33 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> enum v4l2_illuminator {
>         V4L2_ILLUMINATOR_OFF = 0,
>         V4L2_ILLUMINATOR_ON = 1,
> };
> #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
> 
> enum v4l2_led {
>         V4L2_LED_AUTO = 0,
>         V4L2_LED_OFF = 1,
>         V4L2_LED_ON = 2,
> };
> #define V4L2_CID_LED_0              (V4L2_CID_BASE+39)
> 
> Simple and straightforward.

Hi,

Hans (de Goede), is this OK for you? I think that if we find more
illuminators or LEDs on some devices, we may add more V4L2_CID_xxx_n
controls.

Hans (Verkuil), may we have the same enum's for both light types?
Something like:

enum v4l2_light {
	V4L2_LIGHT_OFF = 0,
	V4L2_LIGHT_ON = 1,
	V4L2_LIGHT_AUTO = 2,
	V4L2_LIGHT_BLINK = 3,
};

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
