Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56634 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbcFPG4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 02:56:23 -0400
Date: Thu, 16 Jun 2016 09:56:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2] v4l2-ctrl.h: fix comments
Message-ID: <20160616065618.GH26360@valkosipuli.retiisi.org.uk>
References: <576150CC.9010201@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576150CC.9010201@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 15, 2016 at 02:57:48PM +0200, Hans Verkuil wrote:
> The comments for the unlocked v4l2_ctrl_s_ctrl* functions were wrong (copy
> and pasted from the locked variants). Fix this, since it is confusing.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
