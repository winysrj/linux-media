Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0J0Pag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 11:30:36 -0400
Message-ID: <4CC84597.4000204@gmail.com>
Date: Wed, 27 Oct 2010 17:30:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com>
In-Reply-To: <4CC8380D.3040802@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
> Linus,
> 
> Please pull from
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
...
> Mauro Carvalho Chehab (72):
...
>       [media] tda18271: allow restricting max out to 4 bytes

Even though you know this one breaks at least one driver you want it merged?

regards,
-- 
js
