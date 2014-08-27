Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52052 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642AbaH0JvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 05:51:12 -0400
Date: Wed, 27 Aug 2014 10:51:06 +0100
From: Sean Young <sean@mess.org>
To: zhangfei <zhangfei.gao@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Guoxiong Yan <yanguoxiong@huawei.com>
Subject: Re: [PATCH v2 2/3] rc: Introduce hix5hd2 IR transmitter driver
Message-ID: <20140827095106.GA2712@gofer.mess.org>
References: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
 <1408613086-12538-3-git-send-email-zhangfei.gao@linaro.org>
 <20140821100739.GA3252@gofer.mess.org>
 <53FD9BB7.6080207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FD9BB7.6080207@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 27, 2014 at 04:49:59PM +0800, zhangfei wrote:
> On 08/21/2014 06:07 PM, Sean Young wrote:
> >On Thu, Aug 21, 2014 at 05:24:44PM +0800, Zhangfei Gao wrote:
> >It would be useful is rdev->input_phys, rdev->input_id,
> >rdev->timeout, rdev->rx_resolution are set correctly.
> 
> OK, will set rdev->timeout, rdev->rx_resolution
> Not sure the usage of rdev->input_id, why is it required?

This is for the EVIOCGID ioctl on the input device which will be created 
for the rc device. This is used for delivering input events from decoded
IR. There is be no reason to run lircd if you use this method.


Sean
