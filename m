Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6362 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbbHYVnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 17:43:06 -0400
Message-ID: <55DCE13C.3070904@nvidia.com>
Date: Tue, 25 Aug 2015 14:42:20 -0700
From: Bryan Wu <pengw@nvidia.com>
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<wenjiaz@nvidia.com>, <davidw@nvidia.com>, <gfitzer@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com> <20150821130339.GB22118@ulmo.nvidia.com> <55DBB62C.4020606@nvidia.com> <20150825134444.GH14034@ulmo.nvidia.com>
In-Reply-To: <20150825134444.GH14034@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2015 06:44 AM, Thierry Reding wrote:
> On Mon, Aug 24, 2015 at 05:26:20PM -0700, Bryan Wu wrote:
>> On 08/21/2015 06:03 AM, Thierry Reding wrote:
>>> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
> [...]
>>>> +{
>>>> +	if (chan->bypass)
>>>> +		return;
>>> I don't see this being set anywhere. Is it dead code? Also the only
>>> description I see is that it's used to bypass register writes, but I
>>> don't see an explanation why that's necessary.
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
> I don't think it's fair to burden upstream with code that will only ever
> be used downstream. Let's split these changes into a separate patch that
> can be carried downstream.

OK, I will split out a patch for downstream.


>>>> +/* Syncpoint bits of TEGRA_VI_CFG_VI_INCR_SYNCPT */
>>>> +static u32 sp_bit(struct tegra_channel *chan, u32 sp)
>>>> +{
>>>> +	return (sp + chan->port * 4) << 8;
>>>> +}
>>> Technically this returns a mask, not a bit, so sp_mask() would be more
>>> appropriate.
>> Actually it returns the syncpoint value for each port not a mask. Probably
>> sp_bits() is better.
> Looking at the TRM, the field that this generates a value for is called
> VI_COND (in the VI_CFG_VI_INCR_SYNCPT register), so perhaps this should
> really be a macro and named something like:
>
> 	#define VI_CFG_VI_INCR_SYNCPT_COND(x) (((x) & 0xff) << 8)
>
> As for the arithmetic, that doesn't seem to match up. Quoting from your
> original patch:
>
>>>> +/* VI registers */
>>>> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT                     0x000
>>>> +#define		SP_PP_LINE_START			4
>>>> +#define		SP_PP_FRAME_START			5
>>>> +#define		SP_MW_REQ_DONE				6
>>>> +#define		SP_MW_ACK_DONE				7
> This doesn't seem to match the TRM, which has the following values:
>
> 	 0 = IMMEDIATE
> 	 1 = OP_DONE
> 	 2 = RD_DONE
> 	 3 = REG_WR_SAFE
> 	 4 = VI_MWA_REQ_DONE
> 	 5 = VI_MWB_REQ_DONE
> 	 6 = VI_MWA_ACK_DONE
> 	 7 = VI_MWB_ACK_DONE
> 	 8 = VI_ISPA_DONE
> 	 9 = VI_CSI_PPA_FRAME_START
> 	10 = VI_CSI_PPB_FRAME_START
> 	11 = VI_CSI_PPA_LINE_START
> 	12 = VI_CSI_PPB_LINE_START
> 	13 = VI_VGP0_RCVD
> 	14 = VI_VGP1_RCVD
> 	15 = VI_ISPB_DONE
>
> Comparing with the internal register manuals it looks like the TRM is
> actually wrong. Can you file an internal bug to rectify this and Cc me
> on it, please?

Oh, oops. I will file a bug for that. This list is actually old one in 
Tegra K1 not for Tegra X1.

> Irrespective, since this is generating content for a register field it
> would seem more consistent to define it as a parameterized macro, like
> so:
>
> 	#define VI_CSI_PP_LINE_START(port)	(4 + (port) * 4)
> 	#define VI_CSI_PP_FRAME_START(port)	(5 + (port) * 4)
> 	#define VI_CSI_MWA_REQ_DONE(port)	(6 + (port) * 4)
> 	#define VI_CSI_MWA_ACK_DONE(port)	(7 + (port) * 4)
>
> and then use them together with the above macro:
>
> 	value = VI_CFG_VI_INCR_SYNCPT_COND(VI_CSI_PP_FRAME_START(port)) |
> 		host1x_syncpt_id(syncpt);
> 	writel(value, ...);

Looks good to me. I will fix this.


>>>> +static int tegra_channel_capture_setup(struct tegra_channel *chan)
>>>> +{
>>>> +	int lanes = 2;
>>> unsigned int? And why is it hardcoded to 2? There are checks below for
>>> lanes == 4, which will effectively never happen. So at the very least I
>>> think this should have a TODO comment of some sort. Preferably can it
>>> not be determined at runtime what number of lanes we need?
>> Sure, I forget to fix this. lanes should get from DT and for TPG mode I will
>> choose lanes as 4 by default.
> Can the number of lanes required not be determined at runtime? I suspect
> it would be a property of whatever camera is attached. Then again, this
> is perhaps clarified by the DT binding, so I'll wait and see how that
> looks.

Sure, normally lanes number is defined as "bus-width" in the DT node 
when a real sensor connects.
But since TPG is a virtual sensor which doesn't have any lanes 
requirement. Let's choose 4 for TPG.

>>>> +	u32 height = chan->format.height;
>>>> +	u32 width = chan->format.width;
>>>> +	u32 format = chan->fmtinfo->img_fmt;
>>>> +	u32 data_type = chan->fmtinfo->img_dt;
>>>> +	u32 word_count = tegra_core_get_word_count(width, chan->fmtinfo);
>>>> +	struct chan_regs_config *regs = &chan->regs;
>>>> +
>>>> +	/* CIL PHY register setup */
>>>> +	if (port & 0x1) {
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 - 0x34, 0x0);
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
>>>> +	} else {
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x10000);
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 + 0x34, 0x0);
>>>> +	}
>>> This seems to address registers not actually part of this channel. Why?
>> It's little bit hackish, but it's really have no choice. CIL PHY is shared
>> by 2 channels. like CSIA and CSIB, CSIC and CSID, CSIE and CSIF. So we have
>> 3 groups.
> I'm wondering if we can't add some object as abstraction to make this
> more straightforward to follow. I find this driver generally hard to
> understand because of all the (seemingly) random register accesses.

Actually my original design has a separated subdev driver named 
tegra-csi, which handles CSI specific operations and 
tegra-vi/tegra-channel will handle VI operations.

The real problem is we actually just have 1 VI/CSI hardware controller, 
so the register space is kind of mixed up. Some of them are for CSI, 
some of them are for VI.

Although it's still doable, I just feels like little bit hackish.

>>> Also you use magic numbers here and in the remainder of the driver. We
>>> should be able to do better. I presume all of this is documented in the
>>> TRM, so we should be able to easily substitute symbolic names.
>> I also got those magic numbers from internal source. Some of them are not in
>> the TRM. And people just use that settings. I will try to convert them to
>> some meaningful bit names. Please let me do it after I finished the whole
>> work as an incremental patch.
> Sorry, that's not going to work. One of our prerequisite for merging
> code into the upstream kernel has always been to have the registers
> documented in the TRM. Magic numbers are not an option.

OK, I will rework on these register bits.

>>>> +	cil_write(chan, TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
>>>> +	cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
>>>> +	if (lanes == 4) {
>>>> +		regs->cil = regs_base(TEGRA_CSI_CIL_0_BASE, port + 1);
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
>>>> +		cil_write(chan,	TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
>>>> +		cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
>>>> +		regs->cil = regs_base(TEGRA_CSI_CIL_0_BASE, port);
>>>> +	}
>>> And this seems to access registers from another port by temporarily
>>> rewriting the CIL base offset. That seems a little hackish to me. I
>>> don't know the hardware intimately enough to know exactly what this
>>> is supposed to accomplish, perhaps you can clarify? Also perhaps we
>>> can come up with some architectural overview of the VI hardware, or
>>> does such an overview exist in the TRM?
>> CSI have 6 channels but just 3 PHYs. If a channel want to use 4 data lanes,
>> then it has to be CSIA, CSIC and CSIE. And CSIB, CSID and CSIF channels can
>> not be used in this case.
>>
>> That's why we need to access the CSIB/D/F registers in 4 data lanes use
>> case.
> I find the nomenclature very difficult. So each channel has two ports,
> and each port uses up two lanes of a 4-lane PHY. Can't we structure
> things in a way so that we expose ports as a low-level object and then
> each channel can use either one or two ports? That way we can create at
> runtime a dynamic number of channels (parsed from DT?) and assign ports
> to them.
>
> Perhaps most of that information will already be available in DT. For
> example if we have a 4-lane camera connected to CSI1, then ports C and D
> could be connected (I suppose that's possible with an OF graph?) and the
> driver would simply have to allocate both C and D ports to some channel
> object representing that camera. Similarly we could have one 2-lane
> camera connected to CSI and another 2-lane camera connected to CSI2 and
> assign ports A or B and E or F, respectively, to channels representing
> these camera links.
>

Yes. this can be handled in DT and use CSI subdev architecture.

Let me go to that direction and post a new patch for review.


>>> I see there is, perhaps add a comment somewhere, in the commit
>>> description or the file header giving a reference to where the
>>> architectural overview can be found?
>> It can be found in Tegra X1 TRM like this:
>> "The CSI unit provides for connection of up to six cameras in the system and
>> is organized as three identical instances of two
>> MIPI support blocks, each with a separate 4-lane interface that can be
>> configured as a single camera with 4 lanes or as a dual
>> camera with 2 lanes available for each camera."
>>
>> What about I put this information in the code as a comment?
> Having this as comments is obviously going to help understand the code,
> but the code will still be difficult to follow. I think it would be far
> easier to understand if this was structured in a top-down approach
> rather than bottom-up.
>
>>>> +	/* CSI pixel parser registers setup */
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK, 0x0);
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL0,
>>>> +		 0x280301f0 | (port & 0x1));
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL1, 0x11);
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_GAP, 0x140000);
>>>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME, 0x0);
>>>> +	pp_write(chan, TEGRA_CSI_INPUT_STREAM_CONTROL,
>>>> +		 0x3f0000 | (lanes - 1));
>>>> +
>>>> +	/* CIL PHY register setup */
>>>> +	if (lanes == 4)
>>>> +		phy_write(chan, 0x0101);
>>>> +	else {
>>>> +		u32 val = phy_read(chan);
>>>> +		if (port & 0x1)
>>>> +			val = (val & ~0x100) | 0x100;
>>>> +		else
>>>> +			val = (val & ~0x1) | 0x1;
>>>> +		phy_write(chan, val);
>>>> +	}
>>> The & ~ isn't quite doing what I suspect it should be doing. My
>>> assumption is that you want to set this register to 0x01 if the first
>>> port is to be used and 0x100 if the second port is to be used (or 0x101
>>> if both ports are to be used). In that case I think you'll want
>>> something like this:
>>>
>>> 	value = phy_read(chan);
>>>
>>> 	if (port & 1)
>>> 		value = (value & ~0x0001) | 0x0100;
>>> 	else
>>> 		value = (value & ~0x0100) | 0x0001;
>>>
>>> 	phy_write(chan, value);
>> I don't think your code is correct. The algorithm is to read out the share
>> PHY register value and clear the port related bit and set that bit. Then it
>> won't touch the setting of the other port. It means when we setup a channel
>> it should not change the other channel which sharing PHY register with the
>> current one.
>>
>> In your case, you cleared the other port's bit and set the current port bit.
>> When we write the value back to the PHY register, current port will be
>> enabled but the other port will be disabled.
>>
>> For example, like CSIA is running, the value of PHY register is 0x0001.
>> Then when we try to enable CSIB, we should write 0x0101 to the PHY register
>> but not 0x0100.
> I see. In that case I propose you simply do:
>
> 	if (port & 1)
> 		value |= 0x0100;
> 	else
> 		value |= 0x0001;
>
> Clearing the bit only to set it immediately again is just a waste of CPU
> resources. Likely the compiler will optimize this away, but might as
> well make it easy on the compiler.
Right, clearing is not necessary here.

     val |= (port & 1) ? 0x0100 : 0x0001;

Looks more simple.
> One problem with the above code, though, is that I don't see these bits
> ever being cleared in the PHY. Shouldn't there be code to disable a
> given port when it isn't used? Presumably that would reduce power
> consumption?
We normally stop clock and all the power when stop_streaming. It is not 
necessary to clear that in the PHY.


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
>> After some discussion with Hans, I changed to this. Since there won't be a
>> second capture start which is prevented by v4l2-core, it won't cause the
>> buffer issue.
>>
>> Waiting for host1x syncpoint take time, so dropping lock can let other
>> non-capture ioctls and operations happen.
> If the core already prevents multiple captures for a single channel, do
> we even need the lock in the first place?

Let me go for kthread.

>>>> +	if (err) {
>>>> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
>>>> +		tegra_channel_capture_error(chan, err);
>>>> +	}
>>> Is timeout really the only kind of error that can happen here?
>>>
>> I actually don't know other errors. Any other errors I need take of here?
> Then I suggest you play it safe and simply report what exact error was
> returned:
>
> 		dev_err(&chan->video.dev, "failed to wait for syncpoint: %d\n",
> 			err);

OK, fixed.

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
> There is no way to use the DMA API with SMMU upstream. You need to set
> up your IOMMU domain yourself and attach the VI device to it manually.
> That means you'll also need to manage your IOVA space manually to make
> use of this. I know it's an unfortunate situation and there's work
> underway to improve it, but we're not quite there yet.
>
>> For CMA we need increase the default memory size.
> I'd rather not rely on CMA at all, especially since we do have a way
> around it.
>
>>> Have you ever tried to make this work with the IOMMU API so that we can
>>> allocate arbitrary buffers and linearize them for the hardware through
>>> the SMMU?
>> I tested this code in downstream kernel with SMMU. Do we fully support SMMU
>> in upstream version? I didn't check that.
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
Oh, maybe my description is not very clear here. I did test this patch 
in upstream kernel which is exactly based on your Tegra kernel branch 
staging/work.

And it works fine with test pattern generator now. I just don't know 
whether the upstream kernel is using CMA or IOMMU. But from your answer, 
we don't have IOMMU in upstream but we do have in downstream kernel. I 
think my driver is using CMA, I will double check that.

The work I mentioned in downstream is quite similar with this patch, 
because both downstream and upstream V4L2 driver use the same videobuf2 
API. videobuf2 API use dma-mapping API then.
But in downstream dma-mapping by default support SMMU/IOMMU stuff. Then 
I assume it's available in upstream.




>>>> +	pix->pixelformat = info->fourcc;
>>>> +	pix->field = V4L2_FIELD_NONE;
>>>> +
>>>> +	/* The transfer alignment requirements are expressed in bytes. Compute
>>>> +	 * the minimum and maximum values, clamp the requested width and convert
>>>> +	 * it back to pixels.
>>>> +	 */
>>>> +	align = lcm(chan->align, info->bpp);
>>>> +	min_width = roundup(TEGRA_MIN_WIDTH, align);
>>>> +	max_width = rounddown(TEGRA_MAX_WIDTH, align);
>>>> +	width = rounddown(pix->width * info->bpp, align);
>>> Shouldn't these be roundup()?
>> Why? I don't understand but rounddown looks good to me
> For the maximum and minimum this is probably not an issue because they
> likely are multiples of the alignment (I hope they are, otherwise they
> would be broken; which would indicate that computing min_width and
> max_width here is actually redundant, or should be replaced by some
> sort of WARN() or even BUG().
>
> That said, for the width you'll want to round up, otherwise you will be
> potentially truncating the amount of data you receive. Consider for
> example the case where you wanted to capture a 2x2 image at 32-bit RGB.
> With your above calculation you'll end up with:
>
> 	align = lcm(64, 4) = 64;
> 	width = rounddown(2 * 4 = 8, 64) = 0;

Width should go for roundup(). I assume you asked for roundup() for all 
these calculation.

>
> That's really not what you want. I realize that this particular case
> will be cancelled out by the clamp() calculation below, but the same
> error would apply to larger resolution images. You'll always be missing
> up to 63 bytes if you round down that way.
>
>>>> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
>>>> +	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT,
>>>> +			    TEGRA_MAX_HEIGHT);
>>> The above fits nicely on one line and doesn't need to be wrapped.
>> Fixed
>>>> +
>>>> +	/* Clamp the requested bytes per line value. If the maximum bytes per
>>>> +	 * line value is zero, the module doesn't support user configurable line
>>>> +	 * sizes. Override the requested value with the minimum in that case.
>>>> +	 */
>>>> +	min_bpl = pix->width * info->bpp;
>>>> +	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
>>>> +	bpl = rounddown(pix->bytesperline, chan->align);
>>> Again, I think these should be roundup().
>> Why? I don't understand but rounddown looks good to me
> Same applies here. Alignment is a restriction regarding the *minimum*
> size, rounding up is therefore what you really need.
>
>>>> +	/* VI Channel is 64 bytes alignment */
>>>> +	chan->align = 64;
>>> Does this need parameterization for other SoC generations?
>> So far it's 64 bytes and I don't see any change about this in the future
>> generations.
> I don't see this documented in the TRM. Can you file a bug to get this
> added? We have tables for this kind of restrictions for other devices,
> such as display controller. We'll need that in the TRM for VI as well.

OK, I will do it.

>>>> +	chan->surface = 0;
>>> I can't find this being set to anything other than 0. What is its use?
>> Each channel actually has 3 memory output surfaces. But I don't find any use
>> case to use the surface 1 and surface 2. So I just added this parameter for
>> future usage.
>>
>> chan->surface is used in tegra_channel_capture_frame()
> I don't understand why it needs to be stored in the channel. We could
> simply hard-code it to 0 in tegra_channel_capture_frame(). Perhaps along
> with a TODO comment or similar that this might need to be paramaterized?
OK, Let me remove the surface parameters here. If we find we need that I 
will add it back in the future.


> The TRM isn't any help in explaining why three surfaces are available.
> Would you happen to know what surfaces 1 and 2 can be used for?

That's true, I don't see any explanation in TRM but just some registers.

>>>> diff --git a/drivers/media/platform/tegra/tegra-core.h b/drivers/media/platform/tegra/tegra-core.h
>>>> new file mode 100644
>>>> index 0000000..7d1026b
>>>> --- /dev/null
>>>> +++ b/drivers/media/platform/tegra/tegra-core.h
>>>> @@ -0,0 +1,134 @@
>>>> +/*
>>>> + * NVIDIA Tegra Video Input Device Driver Core Helpers
>>>> + *
>>>> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
>>>> + *
>>>> + * Author: Bryan Wu <pengw@nvidia.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +#ifndef __TEGRA_CORE_H__
>>>> +#define __TEGRA_CORE_H__
>>>> +
>>>> +#include <dt-bindings/media/tegra-vi.h>
>>>> +
>>>> +#include <media/v4l2-subdev.h>
>>>> +
>>>> +/* Minimum and maximum width and height common to Tegra video input device. */
>>>> +#define TEGRA_MIN_WIDTH		32U
>>>> +#define TEGRA_MAX_WIDTH		7680U
>>>> +#define TEGRA_MIN_HEIGHT	32U
>>>> +#define TEGRA_MAX_HEIGHT	7680U
>>> Is this dependent on SoC generation? If we wanted to support Tegra K1,
>>> would the same values apply or do they need to be parameterized?
>> I actually don't get any information about this max/min resolution. Here I
>> just put some values for the format calculation.
> Can you request that this be added to the TRM (via that internal bug
> report I mentioned), please? According to the register definitions the
> width and height fields to be programmed are 16-bit, but I doubt that we
> can realistically capture frames of 65535x65535 pixels.
OK, I will do it.


>>> On that note, could you outline what would be necessary to make this
>>> work on Tegra K1? What are the differences between the VI hardware on
>>> Tegra X1 vs. Tegra K1?
>>>
>> Tegra X1 and Tegra K1 have similar channel architecture. Tegra X1 has 6
>> channels, Tegra K1 has 2 channels.
> Okay, so it should be relatively easy to make this work on Tegra K1 as
> well. I'll see if I can find some time to play with that. What would be
> the easiest way to check that this works? I suppose I could write a
> small program to capture images from the V4L2 node(s) that this exposes
> and displays them in a DRM/KMS overlay via DMA-BUF. But perhaps there
> are premade tools to achieve this? Preferably with not too many
> dependencies.
Yeah, it's not very difficult to add support for Tegra K1, basically 
just some registers are different.

For the test case, I'm using open source tool yavta to 
capture/v4l2-ctrls/enum-ctrls.

http://git.ideasonboard.org/yavta.git

For the media controller, I'm using media-ctl of v4l-utils

http://git.linuxtv.org/v4l-utils.git


>>>> +/* UHD 4K resolution as default resolution for all Tegra video input device. */
>>>> +#define TEGRA_DEF_WIDTH		3840
>>>> +#define TEGRA_DEF_HEIGHT	2160
>>> Is this a sensible default? It seems rather large to me.
>> Actually I use this for TPG which is the default setting of VI. And it can
>> be override from user space IOCTL.
> I understand, but UHD is rather big, so not sure if it makes a good
> default. Perhaps 1920x1080 would be a more realistic default. But I
> don't feel very strong about this.
1080p is good for me. I will change to that. It's just for test pattern 
generator.
For real sensor, I think we can easily support 23Mega pixel sensor.
>>>> +
>>>> +#define TEGRA_VF_DEF		TEGRA_VF_RGB888
>>>> +#define TEGRA_VF_DEF_FOURCC	V4L2_PIX_FMT_RGB32
>>> Should we not have only one of these and convert to the other via some
>>> table?
>> This is also TPG default mode
> I understand, but the fourcc version can be converted to the Tegra
> internal format with a function, right? So it seems weird that we'd have
> to hard-code both here, which also means that they need to be manually
> kept in sync.
Sure, I will remove FOURCC one and just use

#define TEGRA_VF_DEF V4L2_PIX_FMT_RGB32


>>>> +	struct tegra_channel *chan;
>>>> +
>>>> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
>>>> +		chan = &vi->chans[i];
>>>> +
>>>> +		ret = tegra_channel_init(vi, chan, i);
>>> Again, chan is only used once, so directly passing &vi->chans[i] to
>>> tegra_channel_init() would be more concise.
>> OK, I will remove 'chan' parameter from the list. And just pass i as the
>> port number.
> I didn't express myself very clearly. What I was suggesting was to
> remove the chan temporary variable and pass in &vi->chans[i] directly.
> Passing in both &vi->chans[i] and i looks okay to me, that way you don't
> have to look up i via other means. Provided that you still need it, of
> course.
I understood that, but just found remove 'chan' parameter here is simpler.

----
for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
     ret = tegra_channel_init(vi, i);
----


>>>> +	vi_tpg_fmts_bitmap_init(vi);
>>>> +
>>>> +	ret = tegra_vi_v4l2_init(vi);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	/* Check whether VI is in test pattern generator (TPG) mode */
>>>> +	of_property_read_u32(vi->dev->of_node, "nvidia,pg_mode",
>>>> +			     &vi->pg_mode);
>>> This doesn't sound right. Wouldn't this mean that you can either use the
>>> device in TPG mode or sensor mode only? With no means of switching at
>>> runtime? But then I see that there's an IOCTL to set this mode, so why
>>> even bother having this in DT in the first place?
>> DT can provide a default way to set the whole VI as TPG. And v4l2-ctrls
>> (IOCTL) is another way to do that.
>>
>> We can remove this DT stuff but just use runtime v4l2-ctrls.
> Yes, let's do that then. It's a policy decision and therefore doesn't
> belong in DT.

OK, removed.

>>>> diff --git a/include/dt-bindings/media/tegra-vi.h b/include/dt-bindings/media/tegra-vi.h
>>> [...]
>>>> +#ifndef __DT_BINDINGS_MEDIA_TEGRA_VI_H__
>>>> +#define __DT_BINDINGS_MEDIA_TEGRA_VI_H__
>>>> +
>>>> +/*
>>>> + * Supported CSI to VI Data Formats
>>>> + */
>>>> +#define TEGRA_VF_RAW6		0
>>>> +#define TEGRA_VF_RAW7		1
>>>> +#define TEGRA_VF_RAW8		2
>>>> +#define TEGRA_VF_RAW10		3
>>>> +#define TEGRA_VF_RAW12		4
>>>> +#define TEGRA_VF_RAW14		5
>>>> +#define TEGRA_VF_EMBEDDED8	6
>>>> +#define TEGRA_VF_RGB565		7
>>>> +#define TEGRA_VF_RGB555		8
>>>> +#define TEGRA_VF_RGB888		9
>>>> +#define TEGRA_VF_RGB444		10
>>>> +#define TEGRA_VF_RGB666		11
>>>> +#define TEGRA_VF_YUV422		12
>>>> +#define TEGRA_VF_YUV420		13
>>>> +#define TEGRA_VF_YUV420_CSPS	14
>>>> +
>>>> +#endif /* __DT_BINDINGS_MEDIA_TEGRA_VI_H__ */
>>> What do we need these for? These seem to me to be internal formats
>>> supported by the hardware, but the existence of this file implies that
>>> you plan on using them in the DT. What's the use-case?
>>>
>>>
>> The original plan is to put nvidia;video-format in device tree and this is
>> the data formats for that. Now we don't need nvidia;video-format in device
>> tree. Then I let me move it into our tegra-core.c, because our
>> tegra_video_formats table needs this.
> If we don't need it now, why will we ever need it? Shouldn't this be
> something that's configurable and depending on what camera is attached
> or what format the user has requested?
>
> Thierry
In my first version, I put nvidia;video-format into the VI device tree 
node, CSI device tree node and TPG DT node. Now this should be removed 
and this header file I will convert to a enum for internal 
tegra_video_formats.

Thanks,
-Bryan
