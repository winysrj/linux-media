Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56797 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbbHUN0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 09:26:09 -0400
Message-ID: <55D726C6.9080608@xs4all.nl>
Date: Fri, 21 Aug 2015 15:25:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>, Bryan Wu <pengw@nvidia.com>
CC: hansverk@cisco.com, linux-media@vger.kernel.org,
	ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	wenjiaz@nvidia.com, davidw@nvidia.com, gfitzer@nvidia.com
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com> <20150821130339.GB22118@ulmo.nvidia.com>
In-Reply-To: <20150821130339.GB22118@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 03:03 PM, Thierry Reding wrote:
> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
>> NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
>> controller which can support up to 6 MIPI CSI camera sensors.
>>
>> This patch adds a V4L2 media controller and capture driver to support
>> Tegra VI hardware. It's verified with Tegra built-in test pattern
>> generator.
> 
> Hi Bryan,
> 
> I've been looking forward to seeing this posted. I don't know the VI
> hardware in very much detail, nor am I an expert on the media framework,
> so I will primarily comment on architectural or SoC-specific things.
> 
> By the way, please always Cc linux-tegra@vger.kernel.org on all patches
> relating to Tegra. That way people not explicitly Cc'ed but still
> interested in Tegra will see this code, even if they aren't subscribed
> to the linux-media mailing list.
> 
>> Signed-off-by: Bryan Wu <pengw@nvidia.com>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/Kconfig               |    1 +
>>  drivers/media/platform/Makefile              |    2 +
>>  drivers/media/platform/tegra/Kconfig         |    9 +
>>  drivers/media/platform/tegra/Makefile        |    3 +
>>  drivers/media/platform/tegra/tegra-channel.c | 1074 ++++++++++++++++++++++++++
>>  drivers/media/platform/tegra/tegra-core.c    |  295 +++++++
>>  drivers/media/platform/tegra/tegra-core.h    |  134 ++++
>>  drivers/media/platform/tegra/tegra-vi.c      |  585 ++++++++++++++
>>  drivers/media/platform/tegra/tegra-vi.h      |  224 ++++++
>>  include/dt-bindings/media/tegra-vi.h         |   35 +
>>  10 files changed, 2362 insertions(+)
>>  create mode 100644 drivers/media/platform/tegra/Kconfig
>>  create mode 100644 drivers/media/platform/tegra/Makefile
>>  create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>>  create mode 100644 drivers/media/platform/tegra/tegra-core.c
>>  create mode 100644 drivers/media/platform/tegra/tegra-core.h
>>  create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>>  create mode 100644 drivers/media/platform/tegra/tegra-vi.h
>>  create mode 100644 include/dt-bindings/media/tegra-vi.h
> 
> I can't spot a device tree binding document for this, but we'll need one
> to properly review this driver.
> 
>> diff --git a/drivers/media/platform/tegra/Kconfig b/drivers/media/platform/tegra/Kconfig
>> new file mode 100644
>> index 0000000..a69d1b2
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/Kconfig
>> @@ -0,0 +1,9 @@
>> +config VIDEO_TEGRA
>> +	tristate "NVIDIA Tegra Video Input Driver (EXPERIMENTAL)"
> 
> I don't think the (EXPERIMENTAL) is warranted. Either the driver works
> or it doesn't. And I assume you already tested that it works, even if
> only using the TPG.
> 
>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> 
> This seems to be missing a couple of dependencies. For example I would
> expect at least TEGRA_HOST1X to be listed here to make sure people can't
> select this when the host1x API isn't available. I would also expect
> some sort of architecture dependency because it really makes no sense to
> build this if Tegra isn't supported.
> 
> If you are concerned about compile coverage you can make that explicit
> using a COMPILE_TEST alternative such as:
> 
> 	depends on ARCH_TEGRA || (ARM && COMPILE_TEST)
> 
> Note that the ARM dependency in there makes sure that HAVE_IOMEM is
> selected, so this could also be:
> 
> 	depends on ARCH_TEGRA || (HAVE_IOMEM && COMPILE_TEST)
> 
> though that'd still leave open the possibility of build breakage because
> of some missing support.
> 
> If you add the dependency on TEGRA_HOST1X that I mentioned above you
> shouldn't need any architecture dependency because TEGRA_HOST1X implies
> those already.
> 
>> +	select VIDEOBUF2_DMA_CONTIG
>> +	---help---
>> +	  Driver for Video Input (VI) device controller in NVIDIA Tegra SoC.
> 
> I'd reword this slightly as:
> 
> 	  Driver for the Video Input (VI) controller found on NVIDIA Tegra
> 	  SoCs.
> 
>> +
>> +	  TO compile this driver as a module, choose M here: the module will be
> 
> s/TO/To/.
> 
>> +	  called tegra-video.
> 
>> diff --git a/drivers/media/platform/tegra/Makefile b/drivers/media/platform/tegra/Makefile
>> new file mode 100644
>> index 0000000..c8eff0b
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/Makefile
>> @@ -0,0 +1,3 @@
>> +tegra-video-objs += tegra-core.o tegra-vi.o tegra-channel.o
> 
> I'd personally leave out the redundant tegra- prefix here, because the
> files are in a tegra/ subdirectory already.

This is actually consistent with the other media drivers, so please keep the
prefix. One can debate whether the prefix makes sense or not, but changing
that would be a subsystem-wide change.

<snip>

>> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
>> +{
>> +	struct tegra_channel_buffer *buf = chan->active;
>> +	struct vb2_buffer *vb = &buf->buf;
>> +	int err = 0;
>> +	u32 thresh, value, frame_start;
>> +	int bytes_per_line = chan->format.bytesperline;
>> +
>> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
>> +		return -EINVAL;
>> +
>> +	if (chan->bypass)
>> +		goto bypass_done;
>> +
>> +	/* Program buffer address */
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_MSB + chan->surface * 8,
>> +		  0x0);
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_LSB + chan->surface * 8,
>> +		  buf->addr);
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_STRIDE + chan->surface * 4,
>> +		  bytes_per_line);
>> +
>> +	/* Program syncpoint */
>> +	frame_start = sp_bit(chan, SP_PP_FRAME_START);
>> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT,
>> +			    frame_start | host1x_syncpt_id(chan->sp));
>> +
>> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, 0x1);
>> +
>> +	/* Use syncpoint to wake up */
>> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
>> +
>> +	mutex_unlock(&chan->lock);
>> +	err = host1x_syncpt_wait(chan->sp, thresh,
>> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
>> +	mutex_lock(&chan->lock);
> 
> What's the point of taking the lock in the first place if you drop it
> here, even if temporarily? This is a per-channel lock, and it protects
> the channel against concurrent captures. So if you drop the lock here,
> don't you run risk of having two captures run concurrently? And by the
> time you get to the error handling or buffer completion below you can't
> be sure you're actually dealing with the same buffer that you started
> with.

My understanding from Bryan is that syncpt_wait is a blocking wait that
can take a long time (it's waiting for a new frame). Keeping the lock
across such a wait will prevent others ioctls that need that same lock
from being called during that time, which is perfectly legal and desirable.

BTW, you can't start two captures simultaneously for the same channel,
the vb2 framework protects against that.

But as you mentioned elsewhere as well, I think this part using workqueues
should be redesigned. It's not a good fit. Either fully interrupt driven (if
possible) or using a per-channel kernel thread.

Regards,

	Hans
