Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967872Ab0B0HqZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 02:46:25 -0500
Message-ID: <4B88CF6C.2070703@redhat.com>
Date: Sat, 27 Feb 2010 08:53:16 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
References: <4B84CC9E.4030600@freemail.hu> <20100224082238.53c8f6f8@tele> <4B886566.8000600@freemail.hu>
In-Reply-To: <4B886566.8000600@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/27/2010 01:20 AM, Németh Márton wrote:
> From: Márton Németh<nm127@freemail.hu>
>
> On Labtec Webcam 2200 there is a feedback LED which can be controlled
> independent from the streaming.

This is true for a lot of cameras, so if we are going to add a way to
support control of the LED separate of the streaming state, we
should do that at the gspca_main level, and let sub drivers which
support this export a set_led callback function.

I must say I personally don't see much of a use case for this feature,
but I believe JF Moine does, so I'll leave further comments and
review of this to JF. I do believe it is important that if we go this
way we do so add the gspca_main level.

Regards,

Hans
