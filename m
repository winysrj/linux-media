Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45052 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbbHYOSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 10:18:47 -0400
Message-ID: <55DC789E.8060300@xs4all.nl>
Date: Tue, 25 Aug 2015 16:15:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>, Bryan Wu <pengw@nvidia.com>
CC: hansverk@cisco.com, linux-media@vger.kernel.org,
	ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	wenjiaz@nvidia.com, davidw@nvidia.com, gfitzer@nvidia.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com> <20150821130339.GB22118@ulmo.nvidia.com> <55DBB62C.4020606@nvidia.com> <20150825134444.GH14034@ulmo.nvidia.com>
In-Reply-To: <20150825134444.GH14034@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 15:44, Thierry Reding wrote:
> On Mon, Aug 24, 2015 at 05:26:20PM -0700, Bryan Wu wrote:
>> On 08/21/2015 06:03 AM, Thierry Reding wrote:
>>> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
>>>> +{
>>>> +	if (chan->bypass)
>>>> +		return;
>>> I don't see this being set anywhere. Is it dead code? Also the only
>>> description I see is that it's used to bypass register writes, but I
>>> don't see an explanation why that's necessary.
>>
>> We are unifying our downstream VI driver with V4L2 VI driver. And this
>> upstream work is the first step to help that.
>>
>> We are also backporting this driver back to our internal 3.10 kernel which
>> is using nvhost channel to submit register operations from userspace to
>> host1x and VI hardware. Then in this case, our driver needs to bypass all
>> the register operations otherwise we got conflicts between these 2 paths.
>>
>> That's why I put bypass mode here. And bypass mode can be set in device tree
>> or from v4l2-ctrls.
> 
> I don't think it's fair to burden upstream with code that will only ever
> be used downstream. Let's split these changes into a separate patch that
> can be carried downstream.

I think that's a good idea.

For the record: I haven't really reviewed the bypass mode. I had the impression
that it needed more work anyway (or am I wrong?).

>>>> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
>>>> +{
>>>> +	struct tegra_channel_buffer *buf = chan->active;
>>>> +	struct vb2_buffer *vb = &buf->buf;
>>>> +	int err = 0;
>>>> +	u32 thresh, value, frame_start;
>>>> +	int bytes_per_line = chan->format.bytesperline;
>>>> +
>>>> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (chan->bypass)
>>>> +		goto bypass_done;
>>>> +
>>>> +	/* Program buffer address */
>>>> +	csi_write(chan,
>>>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_MSB + chan->surface * 8,
>>>> +		  0x0);
>>>> +	csi_write(chan,
>>>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_LSB + chan->surface * 8,
>>>> +		  buf->addr);
>>>> +	csi_write(chan,
>>>> +		  TEGRA_VI_CSI_SURFACE0_STRIDE + chan->surface * 4,
>>>> +		  bytes_per_line);
>>>> +
>>>> +	/* Program syncpoint */
>>>> +	frame_start = sp_bit(chan, SP_PP_FRAME_START);
>>>> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT,
>>>> +			    frame_start | host1x_syncpt_id(chan->sp));
>>>> +
>>>> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, 0x1);
>>>> +
>>>> +	/* Use syncpoint to wake up */
>>>> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
>>>> +
>>>> +	mutex_unlock(&chan->lock);
>>>> +	err = host1x_syncpt_wait(chan->sp, thresh,
>>>> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
>>>> +	mutex_lock(&chan->lock);
>>> What's the point of taking the lock in the first place if you drop it
>>> here, even if temporarily? This is a per-channel lock, and it protects
>>> the channel against concurrent captures. So if you drop the lock here,
>>> don't you run risk of having two captures run concurrently? And by the
>>> time you get to the error handling or buffer completion below you can't
>>> be sure you're actually dealing with the same buffer that you started
>>> with.
>>
>> After some discussion with Hans, I changed to this. Since there won't be a
>> second capture start which is prevented by v4l2-core, it won't cause the
>> buffer issue.
>>
>> Waiting for host1x syncpoint take time, so dropping lock can let other
>> non-capture ioctls and operations happen.
> 
> If the core already prevents multiple captures for a single channel, do
> we even need the lock in the first place?

While this is running another process might call the driver which then
changes some of these registers. So typically locking is needed. Since this
is going to be rewritten to a kthread I'm postponing reviewing the locking
until I see the new version. I expect this to make much more sense then.

>>>> +static int tegra_channel_buffer_prepare(struct vb2_buffer *vb)
>>>> +{
>>>> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
>>>> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
>>>> +
>>>> +	buf->chan = chan;
>>>> +	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>>>> +
>>>> +	return 0;
>>>> +}
>>> This seems to use contiguous DMA, which I guess presumes CMA support?
>>> We're dealing with very large buffers here. Your default frame size
>>> would yield buffers of roughly 32 MiB each, and you probably need a
>>> couple of those to ensure smooth playback. That's quite a bit of
>>> memory to reserve for CMA.
>> In vb2 core driver, it's using dma-mapping API which might be CMA or SMMU.
> 
> There is no way to use the DMA API with SMMU upstream. You need to set
> up your IOMMU domain yourself and attach the VI device to it manually.
> That means you'll also need to manage your IOVA space manually to make
> use of this. I know it's an unfortunate situation and there's work
> underway to improve it, but we're not quite there yet.
> 
>> For CMA we need increase the default memory size.
> 
> I'd rather not rely on CMA at all, especially since we do have a way
> around it.

For the record, I have no problem with it if we start out with contiguous
DMA now and enhance it later. I get the impression that getting the IOMMU
to work is non-trivial, and I don't think it should block merging of this
driver.

This is all internal to the driver, so changing it later will not affect
userspace.

>>> Have you ever tried to make this work with the IOMMU API so that we can
>>> allocate arbitrary buffers and linearize them for the hardware through
>>> the SMMU?
>> I tested this code in downstream kernel with SMMU. Do we fully support SMMU
>> in upstream version? I didn't check that.
> 
> *sigh* We can't merge code upstream which hasn't been tested upstream.
> Let's make sure we get into place whatever we need to actually run this
> on an upstream kernel. That typically means you need to apply your work
> on top of some recent linux-next and run it on an upstream-supported
> board.
> 
> I realize that this is rather difficult to do for Tegra X1 because the
> support for it hasn't been completely merged yet. One possibility is to
> apply this on top of my staging/work branch[0] and run it on the P2371
> or P2571 boards that are supported there. Alternatively since this is
> hardware which is available (in similar form) on Tegra K1 you could try
> to make it work on something like the Jetson TK1. Getting it to support
> Tegra X1 will then be (hopefully) a simple matter of adding parameters
> for the new generation.
> 
> Not testing this on an upstream kernel means that it is likely not going
> to work because we're missing some bits, such as in the clock driver or
> other, that are essential to make this work and as a result we'd be
> carrying broken code in the upstream kernel. That's not acceptable.
> 
> [0]: https://github.com/thierryreding/linux/commits/staging/work
> 

Regards,

	Hans
