Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZCTCZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 22:25:03 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>,
	"Menon, Nishanth" <nm@ti.com>, "Lakhani, Amish" <amish@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 19 Mar 2009 21:24:49 -0500
Subject: Some possible missing v4l2_subdev IOCTLs.
Message-ID: <A24693684029E5489D1D202277BE89442E6B1E33@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I did a quick analysis of the subdev, and noticed that some video ioctls for the subdevices aren't there...

[gs]_crop
[gs]_parm
enum_frameintervals
enum_framesizes
enum_fmt_cap

I noticed this because we currently use them for a "best sensor output" selection before sending the image to the OMAP3 ISP.

Any particular reason why these aren't there?

Regards,
Sergio

