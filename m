Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4540 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZKRGmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 01:42:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 2/3] radio-si470x: move some file operations to common file
Date: Wed, 18 Nov 2009 07:42:41 +0100
Cc: linux-media@vger.kernel.org, tobias.lorenz@gmx.net,
	mchehab@infradead.org, kyungmin.park@samsung.com
References: <4B03926A.6030401@samsung.com>
In-Reply-To: <4B03926A.6030401@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911180742.41935.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 07:21:30 Joonyoung Shim wrote:
> The read and poll file operations of the si470x usb driver can be used
> also equally on the si470x i2c driver, so they go to the common file.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Why on earth is the i2c driver registering a radio device? If I understand
it correctly the usb and i2c driver are both registering a radio device
where there should be only one!

i2c drivers should in general never register video devices. That's the task
of the bridge driver.

Does anyone know why the current driver behaves like this? I think that should
be fixed first.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
