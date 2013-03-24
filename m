Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3CXO1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 10:27:32 -0400
Date: Sun, 24 Mar 2013 11:27:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 01/19] solo6x10: sync to latest code from
 Bluecherry's git repo.
Message-ID: <20130324112723.445693ea@redhat.com>
In-Reply-To: <1363609938-21735-2-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
	<1363609938-21735-2-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Mar 2013 13:32:00 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Synced to commit e9815ac5503ae60cfbf6ff8037035de8f62e2846 from
> branch next in git repository https://github.com/bluecherrydvr/solo6x10.git
> 
> Only removed some code under #if LINUX_VERSION_CODE < some-kernel-version,
> renamed the driver back to solo6x10 from solo6x10-edge and removed the
> unnecessary compat.h header.
> 
> Otherwise the code is identical.
> 

...

> @@ -21,29 +26,78 @@
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
> -#include <linux/slab.h>

You can't remove slab.h if any k*alloc function is used, or it will
break compilation, depending on the Kconfig options selected.

The same type of removal are on other files inside this patch.

Please fix.

Regards,
Mauro
