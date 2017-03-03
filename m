Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48792 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752297AbdCCRqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 12:46:12 -0500
Date: Fri, 3 Mar 2017 19:45:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [PATCH 1/7] staging: media: Remove unnecessary typecast of c90
 int constant
Message-ID: <20170303174552.GP3220@valkosipuli.retiisi.org.uk>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simran,

On Fri, Mar 03, 2017 at 01:21:56AM +0530, simran singhal wrote:
> This patch removes unnecessary typecast of c90 int constant.
> 
> WARNING: Unnecessary typecast of c90 int constant
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>

Which tree are these patches based on?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
