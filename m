Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:51142 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab1HZKRj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 06:17:39 -0400
Message-ID: <4E5772C0.6020004@linuxtv.org>
Date: Fri, 26 Aug 2011 12:17:36 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb_frontend.c warning: can 'timeout' be removed?
References: <201108251529.18402.hverkuil@xs4all.nl>
In-Reply-To: <201108251529.18402.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 25.08.2011 15:29, Hans Verkuil wrote:
> This is the warning the daily build gives:
> 
> v4l-dvb-git/drivers/media/dvb/dvb-core/dvb_frontend.c: In function 'dvb_frontend_thread':
> v4l-dvb-git/drivers/media/dvb/dvb-core/dvb_frontend.c:540:16: warning: variable 'timeout' set but not used [-Wunused-but-set-variable]
> 
> The 'timeout' variable is indeed not used, but should it? I'm not familiar enough
> with this code to decide.

you can safely remove this variable. The code always behaves the same
way, be it woken up by a timeout or on demand (unless freezing or
stopping the thread).

Regards,
Andreas
