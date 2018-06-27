Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44046 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbeF0Ik4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 04:40:56 -0400
Date: Wed, 27 Jun 2018 11:40:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daniel Graefe <daniel.graefe@fau.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Roman Sommer <roman.sommer@fau.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2] staging: media: omap4iss: Added SPDX license
 identifiers
Message-ID: <20180627084013.ybnbxbgha77cdujn@mwanda>
References: <1529932892-9036-1-git-send-email-daniel.graefe@fau.de>
 <1530048656-4074-1-git-send-email-daniel.graefe@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530048656-4074-1-git-send-email-daniel.graefe@fau.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2018 at 11:30:56PM +0200, Daniel Graefe wrote:
> Changes in v2:
> - replaced "GPL-2.0-or-later" with "GPL-2.0+"

We should make checkpatch.pl complain when people use wrong tags like
GPL-2.0-or-later.

regards,
dan carpenter
