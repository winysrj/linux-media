Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35156 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1KXIuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 03:50:23 -0500
Date: Thu, 24 Nov 2011 10:50:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Query] V4L2 Integer (?) menu control
Message-ID: <20111124085018.GF27136@valkosipuli.localdomain>
References: <4ECD730E.3080808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECD730E.3080808@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 23, 2011 at 11:26:22PM +0100, Sylwester Nawrocki wrote:
> Hi,
> 
> I was wondering how to implement in v4l2 a standard menu control having integer 
> values as the menu items. The menu item values would be irregular, e.g. ascending
> logarithmically and thus the step value would not be a constant.
> I'm not interested in private control and symbolic enumeration for each value at
> the series. It should be a standard control where drivers could define an array 
> of integers reflecting the control menu items. And then the applications could
> enumerate what integer values are valid and can be happily applied to a device.  
> 
> I don't seem to find a way to implement this in current v4l2 control framework. 
> Such functionality isn't there, or is it ?

Hi Sylwester,

There is not currently, but I have patches for it. The issue is that I need
them myself but the driver I need them for isn't ready to be released yet.
And as usual, I assume others than vivo is required to show they're really
useful so I haven't sent them.

Good that you asked so we won't end up writing essentially the same code
again. I'll try to send the patches today.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
