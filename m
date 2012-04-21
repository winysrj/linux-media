Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47495 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2DUNr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 09:47:26 -0400
Date: Sat, 21 Apr 2012 16:49:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: my84@bk.ru
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, mchehab@infradead.org,
	dhowells@redhat.com, justinmattock@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [Trivial] staging: go7007: Framesizes features
Message-ID: <20120421134938.GT6498@mwanda>
References: <4f92b043.xYYL+7fcNMQk08OJ%my84@bk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f92b043.xYYL+7fcNMQk08OJ%my84@bk.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 21, 2012 at 05:04:03PM +0400, my84@bk.ru wrote:
> 
> Correct framesizes
> 
> Signed-off-by Volokh Konstantin <my84@bk.ru>
>

Looks good.  But could you write a proper changelog?  What is the
effect for the user?  How did you find these numbers?  Have you
tested the changes?  It should mention something about that this
affects boards with GO7007_SENSOR_TV.

Btw, how many boards are their that have a GO7007_SENSOR_TV but
don't have a GO7007_BOARD_HAS_TUNER?  Should the comment be updated?

The changelog says it "Correct framesizes" but it doesn't actually
correct anything, it just adds new features that weren't supported
before.

Don't put [Trivial] in the subject line.  Trivial patches are things
like spelling mistakes in comments.

regards,
dan carpenter

