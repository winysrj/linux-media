Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35026 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755349AbdCKLuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:50:55 -0500
Date: Sat, 11 Mar 2017 13:50:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/2] libv4lconvert: make it clear about the criteria
 for needs_conversion
Message-ID: <20170311115048.GL3220@valkosipuli.retiisi.org.uk>
References: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f389eeb8826caf429b0948469bb7ce48f5276851.1489224702.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 11, 2017 at 06:31:47AM -0300, Mauro Carvalho Chehab wrote:
> While there is already a comment about the always_needs_conversion
> logic at libv4lconvert, the comment is not clear enough. Also,
> the decision of needing a conversion or not is actually at the
> supported_src_pixfmts[] table.
> 
> Improve the comments to make it clearer about what criteria should be
> used with regards to exposing formats to userspace.
> 
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
