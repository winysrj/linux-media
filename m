Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35167 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbeKZS1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 13:27:04 -0500
Date: Mon, 26 Nov 2018 08:33:48 +0100
From: Greg KH <greg@kroah.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        #@punajuuri.localdomain, for@punajuuri.localdomain,
        4.14@punajuuri.localdomain, and@punajuuri.localdomain,
        up@punajuuri.localdomain
Subject: Re: [PATCH v3.16 1/2] v4l: event: Prevent freeing event
 subscriptions while accessed
Message-ID: <20181126073348.GE18375@kroah.com>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
 <20181108120350.17266-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108120350.17266-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2018 at 02:03:49PM +0200, Sakari Ailus wrote:
> [ upstream commit ad608fbcf166fec809e402d548761768f602702c ]

This is already in 3.18.124.

thanks,

greg k-h
