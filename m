Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935179Ab0KQUWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 15:22:25 -0500
Date: Wed, 17 Nov 2010 15:22:00 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/3] [media] lirc_dev: add some __user annotations
Message-ID: <20101117202200.GC24814@redhat.com>
References: <20101117051339.GE31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117051339.GE31724@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 17, 2010 at 08:13:39AM +0300, Dan Carpenter wrote:
> Sparse complains because there are no __user annotations.
> 
> drivers/media/IR/lirc_dev.c:156:27: warning:
> 	incorrect type in initializer (incompatible argument 2 (different address spaces))
> drivers/media/IR/lirc_dev.c:156:27:    expected int ( *read )( ... )
> drivers/media/IR/lirc_dev.c:156:27:    got int ( extern [toplevel] *<noident> )( ... )
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

