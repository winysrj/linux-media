Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41849 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZESF2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 01:28:55 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Tue, 19 May 2009 10:58:37 +0530
Subject: RE: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03056A15B4@dbde02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89443E17ECF5@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nate,


> -----Original Message-----
> From: Aguirre Rodriguez, Sergio Alberto
> Sent: Tuesday, May 19, 2009 10:52 AM
> To: Dongsoo, Nathaniel Kim; Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: RE: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
> 
> Hi Nate,
> 
> I have 1 input regarding your question:
> 
> >From: linux-media-owner@vger.kernel.org [linux-media-owner@vger.kernel.org]
> On Behalf Of Dongsoo, Nathaniel Kim [dongsoo.kim@gmail.com]
> >Sent: Tuesday, May 19, 2009 7:53 AM
> >To: Shah, Hardik
> >Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh
> R; Hiremath, Vaibhav
> >Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
> >
> >Hello Hardik,
> >
> >Reviewing your driver, I found something made me curious.
> >
> >
> >On Wed, Apr 22, 2009 at 3:25 PM, Hardik Shah <hardik.shah@ti.com> wrote:
> 
> <snip>
> 
> >> +/* Buffer setup function is called by videobuf layer when REQBUF ioctl is
> >> + * called. This is used to setup buffers and return size and count of
> >> + * buffers allocated. After the call to this buffer, videobuf layer will
> >> + * setup buffer queue depending on the size and count of buffers
> >> + */
> >> +static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int
> *count,
> >> +                         unsigned int *size)
> >> +{
> >> +       struct omap_vout_device *vout = q->priv_data;
> >> +       int startindex = 0, i, j;
> >> +       u32 phy_addr = 0, virt_addr = 0;
> >> +
> >> +       if (!vout)
> >> +               return -EINVAL;
> >> +
> >> +       if (V4L2_BUF_TYPE_VIDEO_OUTPUT != q->type)
> >> +               return -EINVAL;
> >> +
> >> +       startindex = (vout->vid == OMAP_VIDEO1) ?
> >> +               video1_numbuffers : video2_numbuffers;
> >> +       if (V4L2_MEMORY_MMAP == vout->memory && *count < startindex)
> >> +               *count = startindex;
> >> +
> >> +       if ((rotation_enabled(vout->rotation)) && *count > 4)
> >> +               *count = 4;
> >> +
> >
> >
> >
> >This seems to be weird to me. If user requests multiple buffers more
> >than 4, user cannot recognize that the number of buffers requested is
> >forced to change into 4. I'm not sure whether this could be serious or
> >not, but it is obvious that user can have doubt about why if user have
> >no information about the OMAP H/W.
> >Is it really necessary to be configured to 4?
[Shah, Hardik] Rotation requires the VRFB contexts and limited number of contexts are available. So maximum number of buffers is fixed to 4 when rotation is enabled.

Thanks,
Hardik 
> >
> >
> >Cheers,
> >
> >Nate
> >
> 
> We did a very similar thing on omap3 camera driver, not exactly by the number
> of buffers requested, but more about checking if the bytesize of the total
> requested buffers was superior to the MMU fixed sized page table size
> capabilities to map that size, then we were limiting the number of buffers
> accordingly (for keeping the page table size fixed).
> 
> According to the v4l2 spec, changing the count value should be valid, and it
> is the userspace app responsability to check the value again, to confirm how
> many of the requested buffers are actually available.
> 
> Regards,
> Sergio
