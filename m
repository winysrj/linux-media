Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34944 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751292AbdBCStr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 13:49:47 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <20170202172245.GT27312@n2100.armlinux.org.uk>
 <20170202175600.GU27312@n2100.armlinux.org.uk>
 <4815b9c8-782a-ac67-d296-c4acb296d849@gmail.com>
 <20170202185826.GV27312@n2100.armlinux.org.uk>
 <2e1cf096-ecb8-ba3d-a554-f4cc6999ed4e@gmail.com>
 <20170202222925.GW27312@n2100.armlinux.org.uk>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, mchehab@kernel.org,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        tiffany.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <02a3a834-efce-e87d-6e1d-ffe21015509e@gmail.com>
Date: Fri, 3 Feb 2017 10:49:41 -0800
MIME-Version: 1.0
In-Reply-To: <20170202222925.GW27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/02/2017 02:29 PM, Russell King - ARM Linux wrote:
> On Thu, Feb 02, 2017 at 11:12:41AM -0800, Steve Longerbeam wrote:
>> Here is the current .queue_setup() op in imx-media-capture.c:
>>
>> static int capture_queue_setup(struct vb2_queue *vq,
>>                                 unsigned int *nbuffers,
>>                                 unsigned int *nplanes,
>>                                 unsigned int sizes[],
>>                                 struct device *alloc_devs[])
>> {
>>          struct capture_priv *priv = vb2_get_drv_priv(vq);
>>          struct v4l2_pix_format *pix = &priv->vdev.fmt.fmt.pix;
>>          unsigned int count = *nbuffers;
>>
>>          if (vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>                  return -EINVAL;
>>
>>          if (*nplanes) {
>>                  if (*nplanes != 1 || sizes[0] < pix->sizeimage)
>>                          return -EINVAL;
>>                  count += vq->num_buffers;
>>          }
>>
>>          while (pix->sizeimage * count > VID_MEM_LIMIT)
>>                  count--;
> That's a weird way of writing:
>
> 	unsigned int max_num = VID_MEM_LIMIT / pix->sizeimage;
> 	count = max(count, max_num);

I think you mean min() there, but yes thanks, fixed.

Steve

