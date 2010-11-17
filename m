Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935355Ab0KQUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 15:24:03 -0500
Date: Wed, 17 Nov 2010 15:23:58 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 3/3] [media] lirc_dev: fixes in lirc_dev_fop_read()
Message-ID: <20101117202358.GD24814@redhat.com>
References: <20101117052015.GF31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117052015.GF31724@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 17, 2010 at 08:20:15AM +0300, Dan Carpenter wrote:
> This makes several changes but they're in one function and sort of
> related:
> 
> "buf" was leaked on error.  The leak if we try to read an invalid
> length is the main concern because it could be triggered over and
> over.
> 
> If the copy_to_user() failed, then the original code returned the 
> number of bytes remaining.  read() is supposed to be the opposite way,
> where we return the number of bytes copied.  I changed it to just return
> -EFAULT on errors.
> 
> Also I changed the debug output from "-EFAULT" to just "<fail>" because
> it isn't -EFAULT necessarily.  And since we go though that path if the
> length is invalid now, there was another debug print that I removed.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Looks good, thanks much.

Reviewed-by: Jarod Wilson <jarod@redhat.com>
Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

