Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030309Ab2AFOi1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 09:38:27 -0500
Message-ID: <4F07075E.8050301@redhat.com>
Date: Fri, 06 Jan 2012 12:38:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH FOR 3.3] VIDIOC_LOG_STATUS support for sub-devices
References: <4EFEEEB7.2020109@gmail.com>
In-Reply-To: <4EFEEEB7.2020109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31-12-2011 09:15, Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> The following changes since commit 3220eb73c5647af4c1f18e32c12dccb8adbac59d:
> 
>   s5p-fimc: Add support for alpha component configuration (2011-12-20 19:46:55
> +0100)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-samsung v4l_mbus
> 
> This one patch enables VIDIOC_LOG_STATUS on subdev nodes.
> 
> Sylwester Nawrocki (1):
>       v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes


Weird... when trying to pull from your tree, several other patches appeared.
After removing the ones that seemed to be already applied, there are still
those that seemed to still apply:

Nov,17 2011: s5p-fimc: Prevent lock up caused by incomplete H/W initialization
Oct, 1 2011: v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes
Dec, 9 2011: v4l: Add new framesamples field to struct v4l2_mbus_framefmt
Dec,15 2011: v4l: Update subdev drivers to handle framesamples parameter
Dec,12 2011: m5mols: Add buffer size configuration support for compressed streams
Nov,21 2011: s5p-fimc: Add media bus framesamples support

Could you please double-check and, if possible, rebase your tree, to avoid
the risk of applying something that is not ok yet, nor to miss something?

Thanks!
Mauro
