Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58132 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbcHCHjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2016 03:39:21 -0400
Subject: Re: [PATCH] media: platform: pxa_camera: convert to vb2
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1457543851-17823-1-git-send-email-robert.jarzmik@free.fr>
 <56E2BD79.9080405@xs4all.nl> <87k2fzxd42.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bafc1ef7-8343-c208-3621-02cc95316dbc@xs4all.nl>
Date: Wed, 3 Aug 2016 09:39:12 +0200
MIME-Version: 1.0
In-Reply-To: <87k2fzxd42.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2016 08:03 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
> Hi Hans,
> 
> Working further on the pxa_camera conversion out of soc_camera, I hit a problem
> of dma being very long, in running v4l2-compliance -f.
> 
> After digging a bit, I realized that the video buffer queued was a 640x480
> format, while the s_fmt_vid_cap() lastly called was a 48x32 one.
> 
> Digging a bit further, I remembered this conversation we had :
>>> +/*
>>> + * Please check the DMA prepared buffer structure in :
>>> + *   Documentation/video4linux/pxa_camera.txt
>>> + * Please check also in pxa_camera_check_link_miss() to understand why DMA chain
>>> + * modification while DMA chain is running will work anyway.
>>> + */
>>> +static int pxa_vb2_prepare(struct vb2_buffer *vb)
> ...zip...
>>> +	for (i = 0; i < pcdev->channels && vb2_plane_vaddr(vb, i); i++)
>>> +		if (vb2_get_plane_payload(vb, i) > vb2_plane_size(vb, i))
>>> +			return -EINVAL;
>>
>> No need for this check, this can't happen. This is checked when the buffers are
>> allocated, and once allocated icd->sizeimage can no longer change.
>>
>>> +
>>> +	if ((pcdev->channels != buf->nb_planes) ||
>>> +	    (vb2_get_plane_payload(vb, 0) != buf->plane_sizes[0])) {
>>> +		pxa_buffer_cleanup(buf);
>>> +		ret = pxa_buffer_init(pcdev, buf);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>
>> Ditto, this can't happen on the fly.
> 
> This last assumption is incorrect I think, at least that's what my tests show
> me.  As a proof, as attached in [1] the logs of pxa_camera. You will see that a
> 640x480 is initialized, but when the buffer is prepared and queued, the capture
> format had been changed to 48x32.
> 
> The consequence in my case is that the scatter-gather prepared for the DMA is
> still 640x480x2 bytes long and not 48x32x2 !!! That means I will capture many
> many frames before declaring the video-buffer done.
> The previous test was recalculating the scatter-gather, which would have taken
> care of this case.
> 
> Unless I'm wrong, I will re-add the above test.
> 
> Cheers.
> 
> --
> Robert
> 
> [1] Logs of pxa_camera under v4l2-compliance -f
>     I put "RJK" annotation for speed reading
> 
> [ 1509.751011] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue_setup(vq=c312f290 nbufs=2 num_planes=0 size=614400)
> [ 1509.754861] pxa27x-camera pxa27x-camera.0: pxac_vb2_init(nb_channels=1)
> [ 1509.754989] dma dma0chan2: pxad_get_config(): dev_addr=0x50000028 maxburst=8 width=0  dir=2
> [ 1509.755024] dma dma0chan2: pxad_prep_slave_sg(): dir=2 flags=41
> [ 1509.755206] dma dma0chan2: pxad_tx_prep(): vc=c39b0c30 txd=c30e6400[0] flags=0x41
> [ 1509.758558] pxa27x-camera pxa27x-camera.0: pxac_vb2_init(nb_channels=1)
> [ 1509.758603] dma dma0chan2: pxad_get_config(): dev_addr=0x50000028 maxburst=8 width=0  dir=2
> [ 1509.758634] dma dma0chan2: pxad_prep_slave_sg(): dir=2 flags=41
> [ 1509.758797] dma dma0chan2: pxad_tx_prep(): vc=c39b0c30 txd=c30e6000[0] flags=0x41
> [ 1509.759296] pxa27x-camera pxa27x-camera.0: pxac_vb2_cleanup(vb=c30e6600)
> [ 1509.759392] pxa-dma pxa-dma.0: vchan c39b0c30: txd c30e6400[0]: freeing
> [ 1509.759530] pxa27x-camera pxa27x-camera.0: pxac_vb2_cleanup(vb=c30e6a00)
> [ 1509.759560] pxa-dma pxa-dma.0: vchan c39b0c30: txd c30e6000[0]: freeing
> [ 1509.760730] pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=640x480:50424752)
> [ 1509.764971] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x50424752
> [ 1509.765077] pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=640x480:50424752)
> [ 1509.768771] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x50424752
> [ 1509.768945] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x50424752
> [ 1509.769009] pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=48x32:56595559)
> [ 1509.772931] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x56595559
> [ 1509.773051] pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=48x32:56595559)
> [ 1509.777213] pxa27x-camera pxa27x-camera.0: current_fmt->fourcc: 0x56595559
> 	RJK: Here we switch to 48x32 format
> 
> [ 1509.777386] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue_setup(vq=c312f290 nbufs=3 num_planes=0 size=614400)

But this debug line indicates that pcdev->current_pix.sizeimage is still the old value: this
should have been updated by the S_FMT call. You'd have to debug that a bit more, it looks like
there is a bug somewhere in the driver.

I suspect this line in pxac_vidioc_try_fmt_vid_cap:

pix->sizeimage = max_t(u32, pix->sizeimage, ret);

This should just be pix->sizeimage = ret.

Regards,

	Hans

> [ 1509.780789] pxa27x-camera pxa27x-camera.0: pxac_vb2_init(nb_channels=1)
> [ 1509.780869] dma dma0chan2: pxad_get_config(): dev_addr=0x50000028 maxburst=8 width=0  dir=2
> [ 1509.780902] dma dma0chan2: pxad_prep_slave_sg(): dir=2 flags=41
> [ 1509.781088] dma dma0chan2: pxad_tx_prep(): vc=c39b0c30 txd=c30e6600[0] flags=0x41
> [ 1509.784948] pxa27x-camera pxa27x-camera.0: pxac_vb2_init(nb_channels=1)
> [ 1509.785065] dma dma0chan2: pxad_get_config(): dev_addr=0x50000028 maxburst=8 width=0  dir=2
> [ 1509.785100] dma dma0chan2: pxad_prep_slave_sg(): dir=2 flags=41
> [ 1509.785281] dma dma0chan2: pxad_tx_prep(): vc=c39b0c30 txd=c30e6400[0] flags=0x41
> [ 1509.788611] pxa27x-camera pxa27x-camera.0: pxac_vb2_init(nb_channels=1)
> [ 1509.788658] dma dma0chan2: pxad_get_config(): dev_addr=0x50000028 maxburst=8 width=0  dir=2
> [ 1509.788689] dma dma0chan2: pxad_prep_slave_sg(): dir=2 flags=41
> [ 1509.788853] dma dma0chan2: pxad_tx_prep(): vc=c39b0c30 txd=c30e6200[0] flags=0x41
> [ 1509.802079] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6a00) nb_channels=1 size=614400
> 	RJK: Here we prepare a 614400 bytes buffer for 48x32 format
>              The scatter-gather chain is way too big for a 48x32x2 bytes capture
> 
> [ 1509.802207] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6000) nb_channels=1 size=614400
> [ 1509.802248] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6c00) nb_channels=1 size=614400
> [ 1509.802512] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6a00) nb_channels=1 size=614400 active=  (null)
> [ 1509.802564] dma dma0chan2: pxad_tx_submit(): txd c30e6600[7]: submitted (not linked)
> [ 1509.802600] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6a00 cookie=7
> [ 1509.802823] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6000) nb_channels=1 size=614400 active=  (null)
> [ 1509.802857] dma dma0chan2: pxad_tx_submit(): txd c30e6400[8]: submitted (cold linked)
> [ 1509.802889] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6000 cookie=8
> [ 1509.803110] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6c00) nb_channels=1 size=614400 active=  (null)
> [ 1509.803142] dma dma0chan2: pxad_tx_submit(): txd c30e6200[9]: submitted (cold linked)
> [ 1509.803172] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6c00 cookie=9
> [ 1509.803205] pxa27x-camera pxa27x-camera.0: pxac_vb2_start_streaming(count=3) active=  (null)
> [ 1509.803236] pxa27x-camera pxa27x-camera.0: pxa_camera_start_capture
> [ 1509.976619] pxa27x-camera pxa27x-camera.0: Camera interrupt status 0x9119
> [ 1509.976723] pxa27x-camera pxa27x-camera.0: Camera interrupt status 0x0
> [ 1509.976760] pxa27x-camera pxa27x-camera.0: pxa_dma_start_channels (channel=0)
> [ 1509.976793] dma dma0chan2: pxad_issue_pending(): txd c30e6600[7]
> [ 1509.976823] dma dma0chan2: pxad_launch_chan(): desc=c30e6600
> [ 1509.976856] dma dma0chan2: lookup_phy(): phy=c3a7f810(0)
> [ 1509.976885] dma dma0chan2: phy_enable(); phy=c3a7f810(0) misaligned=0
> [ 1592.777757] dma dma0chan2: pxad_chan_handler(): checking txd c30e6600[7]: completed=1
> [ 1592.777834] dma dma0chan2: pxad_chan_handler(): checking txd c30e6400[8]: completed=0
> [ 1592.777913] pxa27x-camera pxa27x-camera.0: camera dma irq, cisr=0x8318 dma=1
> [ 1592.778057] dma dma0chan2: pxad_residue(): txd c30e6200[9] sw_desc=c30e6200: 614400
> [ 1592.778216] pxa27x-camera pxa27x-camera.0: pxa_camera_wakeup dequeud buffer (buf=0xc30e6a00)
> [ 1592.778253] pxa27x-camera pxa27x-camera.0: pxa_camera_check_link_miss : top queued buffer=c30e6000, is_dma_stopped=0
> [ 1592.779099] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6a00) nb_channels=1 size=614400
> [ 1592.779403] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6a00) nb_channels=1 size=614400 active=c30e6000
> [ 1592.779455] dma dma0chan2: pxad_tx_submit(): txd c30e6600[a]: submitted (hot linked)
> [ 1592.779490] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6a00 cookie=10
> [ 1675.855782] dma dma0chan2: pxad_chan_handler(): checking txd c30e6400[8]: completed=1
> [ 1675.855861] dma dma0chan2: pxad_chan_handler(): checking txd c30e6200[9]: completed=0
> [ 1675.855953] pxa27x-camera pxa27x-camera.0: camera dma irq, cisr=0x8318 dma=1
> [ 1675.856097] dma dma0chan2: pxad_residue(): txd c30e6600[a] sw_desc=c30e6600: 614400
> [ 1675.856251] pxa27x-camera pxa27x-camera.0: pxa_camera_wakeup dequeud buffer (buf=0xc30e6000)
> [ 1675.856286] pxa27x-camera pxa27x-camera.0: pxa_camera_check_link_miss : top queued buffer=c30e6c00, is_dma_stopped=0
> [ 1675.857074] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6000) nb_channels=1 size=614400
> [ 1675.857376] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6000) nb_channels=1 size=614400 active=c30e6c00
> [ 1675.857428] dma dma0chan2: pxad_tx_submit(): txd c30e6400[b]: submitted (hot linked)
> [ 1675.857464] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6000 cookie=11
> [ 1758.933819] dma dma0chan2: pxad_chan_handler(): checking txd c30e6200[9]: completed=1
> [ 1758.933896] dma dma0chan2: pxad_chan_handler(): checking txd c30e6600[a]: completed=0
> [ 1758.933971] pxa27x-camera pxa27x-camera.0: camera dma irq, cisr=0x8318 dma=1
> [ 1758.934114] dma dma0chan2: pxad_residue(): txd c30e6400[b] sw_desc=c30e6400: 614400
> [ 1758.934271] pxa27x-camera pxa27x-camera.0: pxa_camera_wakeup dequeud buffer (buf=0xc30e6c00)
> [ 1758.934307] pxa27x-camera pxa27x-camera.0: pxa_camera_check_link_miss : top queued buffer=c30e6a00, is_dma_stopped=0
> [ 1758.935111] pxa27x-camera pxa27x-camera.0: pxac_vb2_prepare (vb=c30e6c00) nb_channels=1 size=614400
> [ 1758.935414] pxa27x-camera pxa27x-camera.0: pxac_vb2_queue(vb=c30e6c00) nb_channels=1 size=614400 active=c30e6a00
> [ 1758.935467] dma dma0chan2: pxad_tx_submit(): txd c30e6200[c]: submitted (hot linked)
> [ 1758.935503] pxa27x-camera pxa27x-camera.0: pxa_dma_add_tail_buf (channel=0) : submit vb=c30e6c00 cookie=12
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
