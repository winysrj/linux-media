Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab0BCJ6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 04:58:21 -0500
Message-ID: <4B6948B6.3000005@infradead.org>
Date: Wed, 03 Feb 2010 07:58:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/2] radio: Add radio-timb to the Kconfig and Makefile
References: <4B606832.7080006@pelagicore.com> <201001271742.34027.hverkuil@xs4all.nl>
In-Reply-To: <201001271742.34027.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Wednesday 27 January 2010 17:22:10 Richard Röjfors wrote:
>> This patch adds radio-timb to the Makefile and Kconfig.

>> +config RADIO_TIMBERDALE
>> +	tristate "Enable the Timberdale radio driver"
>> +	depends on MFD_TIMBERDALE && VIDEO_V4L2 && HAS_IOMEM
> 
> I think you need a dependency on I2C as well.


It is not needed. VIDEO_V4L2 already takes care of properly handling it.

-- 

Cheers,
Mauro
