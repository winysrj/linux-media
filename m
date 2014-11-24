Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42757 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752466AbaKXKhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 05:37:20 -0500
Date: Mon, 24 Nov 2014 12:37:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] v4l2-ctrl: move function prototypes from common.h to
 ctrls.h
Message-ID: <20141124103715.GH8907@valkosipuli.retiisi.org.uk>
References: <1416746395-48631-1-git-send-email-hverkuil@xs4all.nl>
 <1416746395-48631-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416746395-48631-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 23, 2014 at 01:39:54PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> For some unknown reason several control prototypes where in v4l2-common.c
> instead of in v4l2-ctrls.h. Move them and document them.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Nice one!

For the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
