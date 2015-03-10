Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51209 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751585AbbCJBjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 21:39:06 -0400
Date: Tue, 10 Mar 2015 03:38:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] media: i2c: add support for omnivision's ov2659 sensor
Message-ID: <20150310013831.GG11954@valkosipuli.retiisi.org.uk>
References: <1425814407-22766-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1425814407-22766-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Sun, Mar 08, 2015 at 11:33:27AM +0000, Lad Prabhakar wrote:
> From: Benoit Parrot <bparrot@ti.com>
> 
> this patch adds support for omnivision's ov2659
> sensor, the driver supports following features:
> 1: Asynchronous probing
> 2: DT support
> 3: Media controller support
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Now that DT support is included, could you document it as well? There's a
single proprerty to document.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
