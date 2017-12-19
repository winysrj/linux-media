Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37474 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762571AbdLSMIZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 07:08:25 -0500
Date: Tue, 19 Dec 2017 14:08:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v4 3/3] media: atomisp: delete empty default struct
 values.
Message-ID: <20171219120823.xyjmkumu2h7uldm7@valkosipuli.retiisi.org.uk>
References: <20171202213443.GC32301@azazel.net>
 <20171202221201.6063-1-jeremy@azazel.net>
 <20171202221201.6063-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171202221201.6063-4-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 02, 2017 at 10:12:01PM +0000, Jeremy Sowden wrote:
> Removing zero-valued struct-members left a number of the default
> struct-values empty.  These values have now been removed.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

This one should be squashed as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
