Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab2DSUlY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 16:41:24 -0400
Date: Thu, 19 Apr 2012 16:41:16 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [media] fintek-cir: add support for newer chip version
Message-ID: <20120419204116.GA5165@redhat.com>
References: <20120419172510.GA14649@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419172510.GA14649@elgon.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2012 at 08:25:10PM +0300, Dan Carpenter wrote:
> Hi Mauro,
> 
> The patch 83ec8225b6ae: "[media] fintek-cir: add support for newer 
> chip version" from Feb 14, 2012, leads to the following warning:
> drivers/media/rc/fintek-cir.c:200 fintek_hw_detect()
> 	 warn: known condition '1032 != 2052'
> 
> drivers/media/rc/fintek-cir.c
>    197          /*
>    198           * Newer reviews of this chipset uses port 8 instead of 5
>    199           */
>    200          if ((chip != 0x0408) || (chip != 0x0804))
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> One of these conditions is always true.
> 
> Probably it should it be:
> 		if ((chip == 0x0408) || (chip == 0x0804))
> or:
> 		if ((chip != 0x0408) && (chip != 0x0804))

Reasonably sure the latter case would be the proper one there.


> depending one if those are the newer or the older chipsets.  I googled
> for it a bit and then decided to just email you.  :P
> 
>    201                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV2;
>    202          else
>    203                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV1;
>    204  
> 
> regards,
> dan carpenter
> 

-- 
Jarod Wilson
jarod@redhat.com

