Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2DWORf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:17:35 -0400
Date: Mon, 23 Apr 2012 10:17:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] fintek-cir: change || to &&
Message-ID: <20120423141725.GA31244@redhat.com>
References: <4F90798B.5000709@redhat.com>
 <20120422080617.GA1252@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120422080617.GA1252@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 22, 2012 at 11:06:17AM +0300, Dan Carpenter wrote:
> The current condition is always true, so everything uses
> LOGICAL_DEV_CIR_REV2 (8).  It should be that Fintek products
> 0x0408(F71809) and 0x0804(F71855) use logical device
> LOGICAL_DEV_CIR_REV1 (5) and other chip ids use logical device 8.
> 
> In other words, this fixes hardware detection for 0x0408 and 0x0804.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

