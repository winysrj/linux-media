Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:36471 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab1HZMNZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:13:25 -0400
Message-ID: <4E578DE1.80706@linuxtv.org>
Date: Fri, 26 Aug 2011 14:13:21 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Is DVB ioctl FE_SET_FRONTEND broken?
References: <1314358307.50448.YahooMailClassic@web121706.mail.ne1.yahoo.com>
In-Reply-To: <1314358307.50448.YahooMailClassic@web121706.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.08.2011 13:31, Chris Rankin wrote:
> --- On Fri, 26/8/11, Andreas Oberritter <obi@linuxtv.org> wrote:
>> I first thought that you were talking about a
>> regression in Linux 3.0.x.
> 
> Heh, yes and no. I am talking about a regression that I am definitely seeing in 3.0.x. However, I cannot say which kernel the problem first appeared in.

[...]

> Debugging the problem has shown that the first event received after a FE_SET_FRONTEND ioctl() has frequency == 0, which is considered an error.

OK, this is actually the problem, which the proposed patch tries to
address: https://patchwork.kernel.org/patch/1036132/

What you're observing is the stale data mentioned in the patch
description. You should definitely try the patch.

>> Yes. The patch is restoring a different old behaviour. The
>> behaviour you're referring to has never been in the kernel. ;-)
> 
> Yikes! Documentation bug, anyone?

Large parts of the documentation haven't been updated since about 10
years, besides some renamed enums and functions here and there, when it
was merged into Linux 2.5. Contributions are welcome, of course.

Regards,
Andreas
