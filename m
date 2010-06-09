Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46764 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0FIKYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 06:24:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Nagarajan, Rajkumar" <x0133774@ti.com>
Subject: Re: [PATCH] OMAP: V4L2: Enable V4L2 on ZOOM2/3 & 3630SDP
Date: Wed, 9 Jun 2010 12:27:28 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <FF55437E1F14DA4BAEB721A458B6701706BD8CCD05@dbde02.ent.ti.com>
In-Reply-To: <FF55437E1F14DA4BAEB721A458B6701706BD8CCD05@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091227.29175.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rajkumar,

On Wednesday 09 June 2010 11:51:45 Nagarajan, Rajkumar wrote:
> Defconfig changes to enable V4L2 on zoom2, zoom3 and 3630sdp boards.

Defconfigs on ARM are going away. See the http://lkml.org/lkml/2010/6/2/472 
thread on LKML. There's also a lengthy discussion about that on LAKML. Linus 
will not accept any change to the defconfig files anymore and currently plans 
to remove them completely for 2.6.36.

-- 
Regards,

Laurent Pinchart
