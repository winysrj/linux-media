Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34780 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0FQHp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 03:45:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: dot file
Date: Thu, 17 Jun 2010 09:49:10 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4C19AA5B.3080206@redhat.com>
In-Reply-To: <4C19AA5B.3080206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006170949.11459.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(CC'ing linux-media as other people might be interested in this).

On Thursday 17 June 2010 06:53:47 Mauro Carvalho Chehab wrote:
> 
> This is just a reminder: please send me one .dot file that you used to
> create the subdev mapping for one of the devices. The more complex, the
> better.
> 
> As I said, my idea is to write a small rfc file using it as an example,
> in order to give a clear separation when someone should use udev/sysfs
> (or some equivalent script on embedded systems) to discover the device
> topology, and when media controller should be used. We need to have some
> sort of guidelines for userspace developers, as we will have two ways
> to get topology, and the reported topology may be different between
> those two, depending on how userspace is creating the device files at
> /dev.

The OMAP3 ISP entities graph (in both dot and postscript forms) can be found 
at http://www.ideasonboard.org/media/

-- 
Regards,

Laurent Pinchart
