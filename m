Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38780 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754997AbbGYWNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2015 18:13:16 -0400
Date: Sun, 26 Jul 2015 01:13:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/7] v4l2-fh: change int to bool for
 v4l2_fh_is_singular(_file)
Message-ID: <20150725221311.GF12092@valkosipuli.retiisi.org.uk>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
 <1437733296-38198-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437733296-38198-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 24, 2015 at 12:21:30PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This function really returns a bool, so use that as the return type
> instead of int.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
