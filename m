Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59282 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753388AbdLGNfZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 08:35:25 -0500
Date: Thu, 7 Dec 2017 15:35:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/45] drivers: media: remove duplicate includes
Message-ID: <20171207133522.yqgb532ftcgvw62d@valkosipuli.retiisi.org.uk>
References: <1512579122-5215-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512579122-5215-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pravin,

On Wed, Dec 06, 2017 at 10:22:02PM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

While at it, how about ordering the headers alphabetically as well? Having
such a large number of headers there unordered may well be the reason why
they're included more than once...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
