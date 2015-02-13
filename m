Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56233 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655AbbBMIK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 03:10:28 -0500
Date: Fri, 13 Feb 2015 10:09:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: Re: [REVIEW PATCH FOR v3.19 1/1] vb2: Fix dma_dir setting for
 dma-contig mem type
Message-ID: <20150213080950.GI32575@valkosipuli.retiisi.org.uk>
References: <1423813357-31446-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1423813357-31446-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 13, 2015 at 09:42:37AM +0200, Sakari Ailus wrote:
> The last argument of vb2_dc_get_user_pages() is of type enum
> dma_data_direction, but the caller, vb2_dc_get_userptr() passes a value
> which is the result of comparison dma_dir == DMA_FROM_DEVICE. This results
> in the write parameter to get_user_pages() being zero in all cases, i.e.
> that the caller has no intent to write there.
> 
> This was broken by patch "vb2: replace 'write' by 'dma_dir'".
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Well, v3.19 is out so this is material for the stable branch. I'll submit a
pull request once I get some acks.

This is quite bad indeed, as writing somewhere you're not expected to write
may well lead to memory corruption, which is exactly the case here.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
