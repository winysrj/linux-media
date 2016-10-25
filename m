Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51938 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756289AbcJYJGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 05:06:52 -0400
Date: Tue, 25 Oct 2016 12:06:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rafael =?iso-8859-1?Q?Louren=E7o?= de Lima Chehab
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] au0828-video: Move two assignments in
 au0828_init_isoc()
Message-ID: <20161025090621.GG4469@mwanda>
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
 <1ab6b168-3c69-97c2-d02e-cd64b7fa222f@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab6b168-3c69-97c2-d02e-cd64b7fa222f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces bugs.  It's my policy to not explain the Markus's
bugs because otherwise he will just resend the patchset and I have asked
him many times to stop.

I will happily review bug fix patches but I really think he should stop
sending these cleanup patches.

regards,
dan carpenter

