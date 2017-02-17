Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33048 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934956AbdBQWMo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 17:12:44 -0500
Date: Sat, 18 Feb 2017 01:12:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Colin King <colin.king@canonical.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mihaela Muraru <mihaela.muraru21@gmail.com>,
        RitwikGopi <ritwikgopi@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] Staging: media/lirc: don't call put_ir_rx on rx
 twice
Message-ID: <20170217221219.GF4108@mwanda>
References: <20170217161730.31908-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217161730.31908-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This one is a false positive.  The original code is correct.

I was looking through my mail boxes to see the history of this and why
it hadn't been fixed earlier.  Someone tried to fix it in 2011:
https://www.spinics.net/lists/linux-driver-devel/msg17403.html
Then I complained about it again in 2014 when I was looking at a
different bug in that same function.  Now you're the third person to
think this code is suspicious.

I think part of the problem is that get_ir_rx(ir) is hidden as a
function parameter instead of on its own line.  But really even that
wouldn't totally fix the issue.

regards,
dan carpenter
