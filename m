Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34733 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHEWl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 18:41:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: alaganraj sandhanam <alaganraj.sandhanam@gmail.com>
Cc: linux-media@vger.kernel.org, sre@debian.org, sakari.ailus@iki.fi
Subject: Re: omap3isp device tree support
Date: Wed, 06 Aug 2014 00:41:59 +0200
Message-ID: <9468625.rMRWF7vSjZ@avalon>
In-Reply-To: <CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
References: <CALFbYK1kEnB2_3VqpLFNtaJ7hj9UHuhrL0iO_rFHD2VFt8THFw@mail.gmail.com> <7469714.hULjr0WVDI@avalon> <CALFbYK3YtrDPGxc3UpASk7MgPTBGcd899Crvm1csY8g+j-fehg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alagan,

On Wednesday 06 August 2014 04:07:58 alaganraj sandhanam wrote:
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

The branch contains work in progress patches. If I'm not mistaken the code 
isn't complete and doesn't work yet.

-- 
Regards,

Laurent Pinchart

