Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45046 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754423AbaHGATH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Aug 2014 20:19:07 -0400
Date: Thu, 7 Aug 2014 03:18:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: alaganraj sandhanam <alaganraj.sandhanam@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, sre@debian.org
Subject: Re: omap3isp device tree support
Message-ID: <20140807001859.GD16460@valkosipuli.retiisi.org.uk>
References: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com>
 <7469714.hULjr0WVDI@avalon>
 <CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alaganraj,

On Wed, Aug 06, 2014 at 04:07:58AM +0530, alaganraj sandhanam wrote:
> Hi Laurent,
> 
> Thanks for the info. what about git://linuxtv.org/pinchartl/media.git
> omap3isp/dt branch?
> I took 3 patches from this branch, fixed
> error: implicit declaration of function ‘v4l2_of_get_next_endpoint’
> by changing to "of_graph_get_next_endpoint".
> 
> while booting i'm getting below msg
> [    1.558471] of_graph_get_next_endpoint(): no port node found in
> /ocp/omap3_isp@480bc000
> [    1.567169] omap3isp 480bc000.omap3_isp: no port node at
> /ocp/omap3_isp@480bc000
> 
> omap3isp/dt is not working branch?

My patches, while experimental, may be helpful for you. Perhaps. At the
moment the issue is IOMMU; Hiroshi Doyu had some patches to get that
attached to the ISP but for various reasons they didn't make it to the
mainline kernel.

You can find my patches here:

<URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=shortlog;h=refs/heads/rm696-041-dt>

PLEASE do no clone the entire tree, but add that as a remote to an existing
tree. The patches are on top of the linux-omap master branch.

I think I've gotten through to sensor sub-device registration with these and
the smiapp driver. I'll try to send some of the omap3isp and possibly also
smiapp patches for review soon. It's unlikely to be a complete set, though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
