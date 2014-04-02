Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbaDBJuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Apr 2014 05:50:21 -0400
Date: Wed, 2 Apr 2014 12:50:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: m.chehab@samsung.com, jarod@wilsonet.com,
	gregkh@linuxfoundation.org, paulmck@linux.vnet.ibm.com,
	mtrompou@gmail.com, bernat.ada@gmail.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lirc: remove redundant NULL check in
 unregister_from_lirc()
Message-ID: <20140402095002.GI18506@mwanda>
References: <4738406.3PgrFdIbI3@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4738406.3PgrFdIbI3@daeseok-laptop.cloud.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 02, 2014 at 02:49:03AM -0700, Daeseok Youn wrote:
> 
> "ir" is already checked before calling unregister_from_lirc().
>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

