Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43924 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0FQG75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 02:59:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: sub device device node and ioctl support?
Date: Thu, 17 Jun 2010 09:03:12 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE4016B3A7671@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016B3A7671@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006170903.12665.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

On Thursday 17 June 2010 00:15:23 Karicheri, Muralidharan wrote:
> Hello,
> 
> I need to support ioctls on sub devices as part of my work on vpbe display
> driver. For example, currently we have use proprietary ioctls on a fb
> device to configure osd hardware on DMXXX VPBE and would like to migrate
> them to the osd sub device node. But currently sub devices are not
> exporting device nodes. I know there is work done by Laurent to add this
> support as part of media controller activity, but then I have to wait for
> this for ever. Is there a way we can get this support merged to the kernel
> tree for 2.6.36?

The media controller upstreaming process will start in one or two weeks. This 
will require a lot of time, so everything won't be ready for 2.6.36.

This being said, the subdevice userspace API is the first part of the media 
controller that will be pushed upstream. Getting it ready for 2.6.36 might be 
a bit difficult, it will depend on how many rc cycles we still get for 2.6.35. 
It will also depend on how fast the patches get reviewed, so you can help 
there :-)

-- 
Regards,

Laurent Pinchart
