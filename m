Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38416 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529AbaE3NFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 09:05:20 -0400
Date: Fri, 30 May 2014 16:04:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Krzysztof Czarnowski <khczarnowski@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: v4l2_device_register_subdev_nodes() clean_up code
Message-ID: <20140530130446.GG2073@valkosipuli.retiisi.org.uk>
References: <CAHqFTYrnru=b9MhuzRHbY8hk8Y149N2nb3Oj2e8p3cc9NP9bJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHqFTYrnru=b9MhuzRHbY8hk8Y149N2nb3Oj2e8p3cc9NP9bJw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

On Fri, May 30, 2014 at 02:44:26PM +0200, Krzysztof Czarnowski wrote:
> Hi,
> 
> In "clean_up:" section of v4l2_device_register_subdev_nodes() we have:
> 
>     if (!sd->devnode)
>         break;
> 
> Maybe I miss something, but shouldn't it be rather "continue" instead
> of "break"?

I believer you're right. Currently nodes that have been registered after the
first sub-device that had no node will not be unregistered.

Actually the entire check is useless. video_unregister_device() can take
NULL as argument, in which case it does nothing.

Would you like to send a patch? :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
