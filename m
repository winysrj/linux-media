Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43264 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991Ab2INVEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 17:04:25 -0400
Message-ID: <50539C29.2070209@iki.fi>
Date: Sat, 15 Sep 2012 00:05:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS
 capability.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <573d42b4b775afd8beeadc7a903cc2190a6f430a.1347619766.git.hans.verkuil@cisco.com> <5053929D.4050902@iki.fi> <201209142327.47675@leon.remlab.net>
In-Reply-To: <201209142327.47675@leon.remlab.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rémi,

Rémi Denis-Courmont wrote:
> Le vendredi 14 septembre 2012 23:25:01, Sakari Ailus a écrit :
>> I had a quick discussion with Laurent, and what he suggested was to use
>> the kernel version to figure out the type of the timestamp. The drivers
>> that use the monotonic time right now wouldn't be affected by the new
>> flag on older kernels. If we've decided we're going to switch to
>> monotonic time anyway, why not just change all the drivers now and
>> forget the capability flag.
>
> That does not work In Real Life.
>
> People do port old drivers forward to new kernels.
> People do port new drivers back to old kernels

Why would you port a driver from an old kernel to a new kernel? Or are 
you talking about out-of-tree drivers?

If you do port drivers across different kernel versions I guess you're 
supposed to use the appropriate interfaces for those kernels, too. Using 
a helper function helps here, so compiling a backported driver would 
fail w/o the helper function that produces the timestamp, forcing the 
backporter to notice the situation.

Anyway, I don't have a very strict opinion on this, so I'm okay with the 
flag, too, but I personally simply don't think it's the best choice we 
can make now. Also, without converting the drivers now the user space 
must live with different kinds of timestamps much longer.

Cc Laurent and Hans.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
