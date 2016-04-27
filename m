Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbcD0Kgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 06:36:31 -0400
Date: Wed, 27 Apr 2016 13:36:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] tw686x: off by one bugs in tw686x_fields_map()
Message-ID: <20160427103607.GJ17913@mwanda>
References: <20160427080928.GC22469@mwanda>
 <20160427073159.041490f8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160427073159.041490f8@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 27, 2016 at 07:31:59AM -0300, Mauro Carvalho Chehab wrote:
> I don't like magic numbers, but, in this very specific case, setting
> frames per second (fps) var to 25 or 30 makes much more sense.

Fine fine.  I buy that rationale.

regards,
dan carpenter

