Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2973 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0BLLdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 06:33:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 2/2] radio: Add radio-timb to the Kconfig and Makefile
Date: Fri, 12 Feb 2010 12:35:28 +0100
Cc: Richard =?iso-8859-1?q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <4B606832.7080006@pelagicore.com> <201001271742.34027.hverkuil@xs4all.nl> <4B6948B6.3000005@infradead.org>
In-Reply-To: <4B6948B6.3000005@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002121235.28815.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 03 February 2010 10:58:14 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> > On Wednesday 27 January 2010 17:22:10 Richard Röjfors wrote:
> >> This patch adds radio-timb to the Makefile and Kconfig.
> 
> >> +config RADIO_TIMBERDALE
> >> +	tristate "Enable the Timberdale radio driver"
> >> +	depends on MFD_TIMBERDALE && VIDEO_V4L2 && HAS_IOMEM
> > 
> > I think you need a dependency on I2C as well.
> 
> 
> It is not needed. VIDEO_V4L2 already takes care of properly handling it.

Where does that happen? I don't see how VIDEO_V4L2 can know when a driver
requires I2C. It's not a universal requirement, after all.

Regards,

	Hans

> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
