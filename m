Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0KQUVg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 15:21:36 -0500
Date: Wed, 17 Nov 2010 15:21:30 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/3] [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
Message-ID: <20101117202130.GB24814@redhat.com>
References: <20101117051223.GD31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117051223.GD31724@bicker>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 17, 2010 at 08:12:23AM +0300, Dan Carpenter wrote:
> We shouldn't unlock here.  I think this was a cut and paste error.

Yeah, looks like it.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

