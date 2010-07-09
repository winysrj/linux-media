Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab0GIWKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 18:10:21 -0400
Date: Fri, 9 Jul 2010 18:03:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] lirc: use unlocked_ioctl
Message-ID: <20100709220318.GM24110@redhat.com>
References: <201007092335.39250.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007092335.39250.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 09, 2010 at 11:35:39PM +0200, Arnd Bergmann wrote:
> New code should not rely on the big kernel lock,
> so use the unlocked_ioctl file operation in lirc.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The lirc code currently conflicts with my removal of the .ioctl
> operation, which I'd like to get into linux-next.
> 
>  drivers/media/IR/ir-lirc-codec.c |    7 +++----
>  drivers/media/IR/lirc_dev.c      |   12 ++++++------
>  drivers/media/IR/lirc_dev.h      |    3 +--
>  3 files changed, 10 insertions(+), 12 deletions(-)

Still works for both rx and tx here w/one of my mceusb transceivers here.

Tested-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

