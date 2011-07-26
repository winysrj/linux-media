Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:57915 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1GZTnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 15:43:41 -0400
Date: Tue, 26 Jul 2011 22:43:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Camera Support
Message-ID: <20110726194338.GG32629@valkosipuli.localdomain>
References: <CAH9_wRMO_xhmgbBDT1c6Cft8-R=+PSHnYjxjdUpe50_=-1M22g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9_wRMO_xhmgbBDT1c6Cft8-R=+PSHnYjxjdUpe50_=-1M22g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 27, 2011 at 12:53:44AM +0530, Sriram V wrote:
> Hi,
>   OMAP3 ISP Supports 2 camera ports (csi and parallel) Does the
> existing ISP drivers
>   support both of them at the same time.

As far as I can see, the answer is yes. However, the CCDC block implements
the parallel receiver, so the image processing functions of the ISP wouldn't
be available for the data received from the CSI(2) receiver when the
parallel interface is in use.

-- 
Sakari Ailus
sakari.ailus@iki.fi
