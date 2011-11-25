Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:51906 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab1KYOlq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 09:41:46 -0500
Message-ID: <4ECFA927.10108@linuxtv.org>
Date: Fri, 25 Nov 2011 15:41:43 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 12/12] Remove audio.h, video.h and osd.h.
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl> <dd96a72481deae71a90ae0ebf49cd48545ab894a.1322141686.git.hans.verkuil@cisco.com> <4ECE79F5.9000402@linuxtv.org> <201111241844.23292.hverkuil@xs4all.nl> <CAHFNz9J+3DYW-Gf0FPYhcZqHf7XPtM+dmK0Y15HhkWQZOzNzuQ@mail.gmail.com> <4ECE8839.8040606@redhat.com> <CAHFNz9LOYHTXjhk2yTqhoC90HQQ0AGiOp4A6Gki-vsEtJr_UOw@mail.gmail.com> <4ECE913A.9090001@redhat.com> <4ECF8359.5080705@linuxtv.org> <4ECF9C92.2040607@redhat.com>
In-Reply-To: <4ECF9C92.2040607@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.11.2011 14:48, Mauro Carvalho Chehab wrote:
> If your complain is about the removal of audio.h, video.h

We're back on topic, thank you!

> and osd.h, then my proposal is
> to keep it there, writing a text that they are part of a deprecated API,

That's exactly what I proposed. Well, you shouldn't write "deprecated",
because it's not. Just explain - inside this text - when V4L2 should be
preferred over DVB.

> but keeping
> the rest of the patches

Which ones?

> and not accepting anymore any submission using them

Why? First you complain about missing users and then don't want to allow
any new ones.

>, removing
> the ioctl's that aren't used by av7110 from them.

That's just stupid. I can easily provide a list of used and valuable
ioctls, which need to remain present in order to not break userspace
applications.

Btw.: It's not easy to submit a driver for a SoC. Even if you are
legally allowed to do it, you have to first merge and maintain the board
support code before even thinking about multimedia.

Regards,
Andreas
