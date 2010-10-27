Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0J0Qik (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 12:38:40 -0400
Message-ID: <4CC8558C.3000209@gmail.com>
Date: Wed, 27 Oct 2010 18:38:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com> <4CC84846.6020304@redhat.com> <4CC84B14.1030303@gmail.com> <4CC8550B.4060403@redhat.com>
In-Reply-To: <4CC8550B.4060403@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/27/2010 06:36 PM, Mauro Carvalho Chehab wrote:
> Basically, af9015 broke due to (3), as .small_i2c = 1 means nothing. It should be using
> .small_i2c = TDA18271_16_BYTE_CHUNK_INIT, instead.
> 
> What I don't understand is why a patch doing this change didn't fix the issue. Please
> test the patch I posted on the original -next thread. Let's try to identify why
> tda18271_write_regs() is not breaking the data into smaller writes.

It helps, but one needs to unplug and replug the device. So care to
respin the pull request with the patch included?

thanks,
-- 
js
