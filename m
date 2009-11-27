Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZK0MUj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 07:20:39 -0500
Message-ID: <4B0FC412.70902@redhat.com>
Date: Fri, 27 Nov 2009 10:20:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
CC: linux-media@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] New driver for the radio FM module on Miro PCM20 sound
 card
References: <20091127112413.77e5d1ff.krzysztof.h1@poczta.fm>
In-Reply-To: <20091127112413.77e5d1ff.krzysztof.h1@poczta.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> This is recreated driver for the FM module found on Miro
> PCM20 sound cards. This driver was removed around the 2.6.2x
> kernels because it relied on the removed OSS module. Now, it
> uses a current ALSA module (snd-miro) and is adapted to v4l2
> layer.
> 
> It provides only basic functionality: frequency changing and
> FM module muting.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro.
