Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55164 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3JIOJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 10:09:19 -0400
Message-id: <52556370.1050102@samsung.com>
Date: Wed, 09 Oct 2013 16:08:48 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Zhang <markz@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Marcus Lorentzon <marcus.lorentzon@huawei.com>
Subject: Re: [PATCH/RFC v3 00/19] Common Display Framework
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <52498146.4050600@ti.com> <524C1058.2050500@samsung.com>
 <524C1E78.6030508@ti.com>
In-reply-to: <524C1E78.6030508@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2013 03:24 PM, Tomi Valkeinen wrote:
> Hi Andrzej,
>
> On 02/10/13 15:23, Andrzej Hajda wrote:
>
>>> Using Linux buses for DBI/DSI
>>> =============================
>>>
>>> I still don't see how it would work. I've covered this multiple times in
>>> previous posts so I'm not going into more details now.
>>>
>>> I implemented DSI (just command mode for now) as a video bus but with bunch of
>>> extra ops for sending the control messages.
>> Could you post the list of ops you have to create.
> I'd rather not post the ops I have in my prototype, as it's still a
> total hack. However, they are very much based on the current OMAP DSS's
> ops, so I'll describe them below. I hope I find time to polish my CDF
> hacks more, so that I can publish them.
>
>> I have posted some time ago my implementation of DSI bus:
>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/69358/focus=69362
> A note about the DT data on your series, as I've been stuggling to
> figure out the DT data for OMAP: some of the DT properties look like
> configuration, not hardware description. For example,
> "samsung,bta-timeout" doesn't describe hardware.
As I have adopted existing internal driver for MIPI-DSI bus, I did not
take too much
care for DT. You are right, 'bta-timeout' is a configuration parameter
(however its
minimal value is determined by characteristic of the DSI-slave). On the
other
side currently there is no good place for such configuration parameters
AFAIK.
>> I needed three quite generic ops to make it working:
>> - set_power(on/off),
>> - set_stream(on/off),
>> - transfer(dsi_transaction_type, tx_buf, tx_len, rx_buf, rx_len)
>> I have recently replaced set_power by PM_RUNTIME callbacks,
>> but I had to add .initialize ops.
> We have a bit more on omap:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/video/omapdss.h#n648
>
> Some of those should be removed and some should be omap DSI's internal
> matters, not part of the API. But it gives an idea of the ops we use.
> Shortly about the ops:
>
> - (dis)connect, which might be similar to your initialize. connect is
> meant to "connect" the pipeline, reserving the video ports used, etc.
>
> - enable/disable, enable the DSI bus. If the DSI peripheral requires a
> continous DSI clock, it's also started at this point.
>
> - set_config configures the DSI bus (like, command/video mode, etc.).
>
> - configure_pins can be ignored, I think that function is not needed.
>
> - enable_hs and enable_te, used to enable/disable HS mode and
> tearing-elimination

It seems there should be a way to synchronize TE signal with panel,
in case signal is provided only to dsi-master. Some callback I suppose?
Or transfer synchronization should be done by dsi-master.
>
> - update, which does a single frame transfer
>
> - bus_lock/unlock can be ignored
>
> - enable_video_output starts the video stream, when using DSI video mode
>
> - the request_vc, set_vc_id, release_vc can be ignored
>
> - Bunch of transfer funcs. Perhaps a single func could be used, as you
> do. We have sync write funcs, which do a BTA at the end of the write and
> wait for reply, and nosync version, which just pushes the packet to the
> TX buffers.
>
> - bta_sync, which sends a BTA and waits for the peripheral to reply
>
> - set_max_rx_packet_size, used to configure the max rx packet size.
Similar callbacks should be added to mipi-dsi-bus ops as well, to
make it complete/generic.

>
>> Regarding the discussion how and where to implement control bus I have
>> though about different alternatives:
>> 1. Implement DSI-master as a parent dev which will create DSI-slave
>> platform dev in a similar way as for MFD devices (ssbi.c seems to me a
>> good example).
>> 2. Create universal mipi-display-bus which will cover DSI, DBI and
>> possibly other buses - they have have few common things - for example
>> MIPI-DCS commands.
>>
>> I am not really convinced to either solution all have some advantages
>> and disadvantages.
> I think a dedicated DSI bus and your alternatives all have the same
> issues with splitting the DSI control into two. I've shared some of my
> thoughts here:
>
> http://article.gmane.org/gmane.comp.video.dri.devel/90651
> http://article.gmane.org/gmane.comp.video.dri.devel/91269
> http://article.gmane.org/gmane.comp.video.dri.devel/91272
>
> I still think that it's best to consider DSI and DBI as a video bus (not
> as a separate video bus and a control bus), and provide the packet
> transfer methods as part of the video ops.
I have read all posts regarding this issue and currently I tend
to solution where CDF is used to model only video streams,
with control bus implemented in different framework.
The only concerns I have if we should use Linux bus for that.

Andrzej

>  Tomi
>
>

