Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55576 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751303Ab2HBIE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 04:04:59 -0400
Message-ID: <501A34A6.9090305@iki.fi>
Date: Thu, 02 Aug 2012 11:04:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.lad@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v8 2/2] v4l2: add new pixel formats supported on dm365
References: <1343894410-16829-1-git-send-email-prabhakar.lad@ti.com> <1343894410-16829-3-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1343894410-16829-3-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
>
> add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> to represent Bayer format frames compressed by A-LAW algorithm,
> add V4L2_PIX_FMT_UV8 to represent storage of CbCr data (UV interleaved)
> only.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
