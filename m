Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51831 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbcLLTda (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 14:33:30 -0500
Date: Tue, 13 Dec 2016 03:32:46 +0800
From: kbuild test robot <lkp@intel.com>
To: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 4/4] uvcvideo: add a metadata device node
Message-ID: <201612130344.2N6ehuhX%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481541412-1186-5-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.9 next-20161209]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Guennadi-Liakhovetski/uvcvideo-metadata-device-node/20161213-004101
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +/case +81 drivers/media/usb/uvc/uvc_queue.c

    65		}
    66	}
    67	
    68	/* -----------------------------------------------------------------------------
    69	 * videobuf2 queue operations
    70	 */
    71	
    72	int uvc_queue_setup(struct vb2_queue *vq,
    73			    unsigned int *nbuffers, unsigned int *nplanes,
    74			    unsigned int sizes[], struct device *alloc_devs[])
    75	{
    76		struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
    77		struct uvc_streaming *stream;
    78		unsigned int size;
    79	
    80		switch (vq->type) {
  > 81		case V4L2_BUF_TYPE_META_CAPTURE:
    82			size = UVC_PAYLOAD_HEADER_MAX_SIZE;
    83	
    84			if (*nplanes && *nplanes != 1)
    85				return -EINVAL;
    86	
    87			break;
    88		default:
    89			stream = uvc_queue_to_stream(queue);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
