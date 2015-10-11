Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37705 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbbJKOmK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Oct 2015 10:42:10 -0400
Subject: Re: [PATCHv5 10/13] hackrf: add support for transmitter
To: kbuild test robot <lkp@intel.com>
References: <201510110807.WZHKJhfM%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <561A753D.8010600@iki.fi>
Date: Sun, 11 Oct 2015 17:42:05 +0300
MIME-Version: 1.0
In-Reply-To: <201510110807.WZHKJhfM%fengguang.wu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!
IMHO it is false positive. Variable which is defined on line 777 is used 
just few lines later on line 782 as can be seen easily. I think it is 
because option CONFIG_DYNAMIC_DEBUG is not set => dev_dbg_ratelimited() 
macro is likely just NOP and gives that warning. Maybe some more logic 
to is needed in order to avoid that kind of warnings.

regards
Antti

On 10/11/2015 03:55 AM, kbuild test robot wrote:
> Hi Antti,
>
> [auto build test WARNING on linuxtv-media/master -- if it's inappropriate base, please ignore]
>
> config: i386-randconfig-i1-201541 (attached as .config)
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All warnings (new ones prefixed by >>):
>
>     drivers/media/usb/hackrf/hackrf.c: In function 'hackrf_buf_queue':
>>> drivers/media/usb/hackrf/hackrf.c:777:24: warning: unused variable 'intf' [-Wunused-variable]
>       struct usb_interface *intf = dev->intf;
>                             ^
>
> vim +/intf +777 drivers/media/usb/hackrf/hackrf.c
>
>     761	
>     762		/* Need at least 8 buffers */
>     763		if (vq->num_buffers + *nbuffers < 8)
>     764			*nbuffers = 8 - vq->num_buffers;
>     765		*nplanes = 1;
>     766		sizes[0] = PAGE_ALIGN(dev->buffersize);
>     767	
>     768		dev_dbg(dev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
>     769		return 0;
>     770	}
>     771	
>     772	static void hackrf_buf_queue(struct vb2_buffer *vb)
>     773	{
>     774		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>     775		struct vb2_queue *vq = vb->vb2_queue;
>     776		struct hackrf_dev *dev = vb2_get_drv_priv(vq);
>   > 777		struct usb_interface *intf = dev->intf;
>     778		struct hackrf_buffer *buffer = container_of(vbuf, struct hackrf_buffer, vb);
>     779		struct list_head *buffer_list;
>     780		unsigned long flags;
>     781	
>     782		dev_dbg_ratelimited(&intf->dev, "\n");
>     783	
>     784		if (vq->type == V4L2_BUF_TYPE_SDR_CAPTURE)
>     785			buffer_list = &dev->rx_buffer_list;
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>

-- 
http://palosaari.fi/
