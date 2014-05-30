Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38576 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529AbaE3NsE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 09:48:04 -0400
Date: Fri, 30 May 2014 16:47:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Krzysztof Czarnowski <khczarnowski@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2_device_register_subdev_nodes() clean_up code
Message-ID: <20140530134730.GH2073@valkosipuli.retiisi.org.uk>
References: <CAHqFTYrnru=b9MhuzRHbY8hk8Y149N2nb3Oj2e8p3cc9NP9bJw@mail.gmail.com>
 <20140530130446.GG2073@valkosipuli.retiisi.org.uk>
 <CAHqFTYoQ3NuC6T52nGrNqtVsUiSqmM1KCeGAuu4_WhMGCV1joA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHqFTYoQ3NuC6T52nGrNqtVsUiSqmM1KCeGAuu4_WhMGCV1joA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 30, 2014 at 03:27:27PM +0200, Krzysztof Czarnowski wrote:
> Sure, a moment :-)

One additional thing: I think sd->devnode should also be set as NULL since
sub-devices are no longer created by the driver owning the media device.

This isn't done in the error path or in v4l2_device_unregister_subdev()
currently.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
