Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47611 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943021AbdAJTyE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 14:54:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Koike <helen.koike@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture and sensor
Date: Tue, 10 Jan 2017 21:54:12 +0200
Message-ID: <1974124.c4lYpJ902j@avalon>
In-Reply-To: <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl> <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

(CC'ing Sakari as there's a question specifically for him)

Thank you for the patch, and so sorry for the late review. 

On Sunday 04 Sep 2016 17:02:18 Helen Koike wrote:
> From: Helen Fornazier <helen.fornazier@gmail.com>
> 
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>

I've reviewed the whole patch but haven't had time to test it. I've also 
skipped the items marked as TODO or FIXME as they're obviously not ready yet 
:-) Overall this looks good to me, all the issues are minor.

> ---
> 
> Patch based in media/master tree, and available here:
> https://github.com/helen-fornazier/opw-staging/tree/vimc/devel/vpu
> 
> Changes since v5:
> - Fix message "Entity type for entity Sensor A was not initialized!"
>   by initializing the sensor entity.function after the calling
>   v4l2_subded_init
> - populate device_caps in vimc_cap_create instead of in
>   vimc_cap_querycap
> - Fix typo in vimc-core.c s/de/the
> 
> Changes since v4:
> - coding style fixes
> - remove BUG_ON
> - change copyright to 2016
> - depens on VIDEO_V4L2_SUBDEV_API instead of select
> - remove assignement of V4L2_CAP_DEVICE_CAPS
> - s/vimc_cap_g_fmt_vid_cap/vimc_cap_fmt_vid_cap
> - fix vimc_cap_queue_setup declaration type
> - remove wrong buffer size check and add it in vimc_cap_buffer_prepare
> - vimc_cap_create: remove unecessary check if v4l2_dev or v4l2_dev->dev is
> null - vimc_cap_create: only allow a single pad
> - vimc_sen_create: only allow source pads, remove unecessary source pads
> checks in vimc_thread_sen
> 
> Changes since v3: fix rmmod crash and built-in compile
> - Re-order unregister calls in vimc_device_unregister function (remove
> rmmod issue)
> - Call media_device_unregister_entity in vimc_raw_destroy
> - Add depends on VIDEO_DEV && VIDEO_V4L2 and select VIDEOBUF2_VMALLOC
> - Check *nplanes in queue_setup (this remove v4l2-compliance fail)
> - Include <linux/kthread.h> in vimc-sensor.c
> - Move include of <linux/slab.h> from vimc-core.c to vimc-core.h
> - Generate 60 frames per sec instead of 1 in the sensor
> 
> Changes since v2: update with current media master tree
> - Add struct media_pipeline in vimc_cap_device
> - Use vb2_v4l2_buffer instead of vb2_buffer
> - Typos
> - Remove usage of entity->type and use entity->function instead
> - Remove fmt argument from queue setup
> - Use ktime_get_ns instead of v4l2_get_timestamp
> - Iterate over link's list using list_for_each_entry
> - Use media_device_{init, cleanup}
> - Use entity->use_count to keep track of entities instead of the old
> entity->id
> - Replace media_entity_init by media_entity_pads_init
> ---
>  drivers/media/platform/Kconfig             |   2 +
>  drivers/media/platform/Makefile            |   1 +
>  drivers/media/platform/vimc/Kconfig        |   7 +
>  drivers/media/platform/vimc/Makefile       |   3 +
>  drivers/media/platform/vimc/vimc-capture.c | 553 ++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-capture.h |  28 ++
>  drivers/media/platform/vimc/vimc-core.c    | 600 ++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h    |  57 +++
>  drivers/media/platform/vimc/vimc-sensor.c  | 279 ++++++++++++++
>  drivers/media/platform/vimc/vimc-sensor.h  |  28 ++
>  10 files changed, 1558 insertions(+)
>  create mode 100644 drivers/media/platform/vimc/Kconfig
>  create mode 100644 drivers/media/platform/vimc/Makefile
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.c
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.h
>  create mode 100644 drivers/media/platform/vimc/vimc-core.c
>  create mode 100644 drivers/media/platform/vimc/vimc-core.h
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.h

[snip]

> diff --git a/drivers/media/platform/vimc/vimc-capture.c
> b/drivers/media/platform/vimc/vimc-capture.c new file mode 100644
> index 0000000..b7636cf
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-capture.c

[snip]

> +static void vimc_cap_return_all_buffers(struct vimc_cap_device *vcap,
> +					enum vb2_buffer_state state)
> +{
> +	struct vimc_cap_buffer *vbuf, *node;
> +
> +	spin_lock(&vcap->qlock);
> +
> +	list_for_each_entry_safe(vbuf, node, &vcap->buf_list, list) {
> +		vb2_buffer_done(&vbuf->vb2.vb2_buf, state);
> +		list_del(&vbuf->list);

It shouldn't matter given that you protect this with a spinlock, but moving 
the list_del() above makes the code flow follow a safer order.

> +	}
> +
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap, int
> enable)
> +{
> +	int ret;
> +	struct media_pad *pad;
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +
> +	/* Start the stream in the subdevice direct connected */
> +	entity = &vcap->vdev.entity;
> +	pad = media_entity_remote_pad(&entity->pads[0]);
> +
> +	/* If we are not connected to any subdev node, it means there is 
nothing
> +	 * to activate on the pipe (e.g. we can be connected with an input
> +	 * device or we are not connected at all)

Shouldn't this have resulted in a pipeline validation error ?

> +	 */
> +	if (pad == NULL || !is_media_entity_v4l2_subdev(pad->entity))
> +		return 0;
> +
> +	entity = pad->entity;
> +	sd = media_entity_to_v4l2_subdev(entity);
> +
> +	ret = v4l2_subdev_call(sd, video, s_stream, enable);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int
> count)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +	struct media_entity *entity;
> +	int ret;
> +
> +	vcap->sequence = 0;
> +
> +	/* Start the media pipeline */
> +	entity = &vcap->vdev.entity;
> +	ret = media_entity_pipeline_start(entity, &vcap->pipe);
> +	if (ret) {
> +		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	/* Enable streaming from the pipe */
> +	ret = vimc_cap_pipeline_s_stream(vcap, 1);
> +	if (ret) {

You should call media_entity_pipeline_stop() here.

> +		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Stop the stream engine. Any remaining buffers in the stream queue are
> + * dequeued and passed on to the vb2 framework marked as STATE_ERROR.
> + */
> +static void vimc_cap_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	/* Disable streaming from the pipe */
> +	vimc_cap_pipeline_s_stream(vcap, 0);
> +
> +	/* Stop the media pipeline */
> +	media_entity_pipeline_stop(&vcap->vdev.entity);
> +
> +	/* Release all active buffers */
> +	vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
> +}
> +
> +static void vimc_cap_buf_queue(struct vb2_buffer *vb2_buf)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb2_buf->vb2_queue);
> +	struct vimc_cap_buffer *buf = container_of(vb2_buf,
> +						   struct vimc_cap_buffer,
> +						   vb2.vb2_buf);
> +
> +	spin_lock(&vcap->qlock);
> +	list_add_tail(&buf->list, &vcap->buf_list);
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int
> *nbuffers,
> +				unsigned int *nplanes, unsigned int sizes[],
> +				struct device *alloc_devs[])
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	if (*nplanes)

You should also return an error if *nplanes != 1 in this case.

> +		return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;
> +	/* We don't support multiplanes for now */
> +	*nplanes = 1;
> +	sizes[0] = vcap->format.sizeimage;
> +
> +	return 0;
> +}
> +
> +/*
> + * Prepare the buffer for queueing to the DMA engine: check and set the

There's no DMA engine, this is a virtual device :-)

> + * payload size.
> + */
> +static int vimc_cap_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = vcap->format.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(vcap->dev, "buffer too small (%lu < %lu)\n",
> +			vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);

If you call this here you don't have to duplicate the call in 
vimc_cap_process_frame(). I would keep the one in vimc_cap_process_frame() and 
remove this one.

> +	return 0;
> +}
> +
> +static const struct vb2_ops vimc_cap_qops = {
> +	.start_streaming	= vimc_cap_start_streaming,
> +	.stop_streaming		= vimc_cap_stop_streaming,
> +	.buf_queue		= vimc_cap_buf_queue,
> +	.queue_setup		= vimc_cap_queue_setup,
> +	.buf_prepare		= vimc_cap_buffer_prepare,
> +	/*
> +	 * Since q->lock is set we can use the standard
> +	 * vb2_ops_wait_prepare/finish helper functions.
> +	 */
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +/* NOTE: this function is a copy of v4l2_subdev_link_validate_get_format
> + * maybe the v4l2 function should be public
> + */

Or we should add a standard subdev <-> video devnode link validation function 
in the core :-) So far all drivers validate that link manually, but I don't 
remember a good reason why that couldn't be performed by the link validation 
infrastructure. Sakari, what do you think ?

That's anyway not a blocker to get this patch merged.

> +static int vimc_cap_v4l2_subdev_link_validate_get_format(struct media_pad
> *pad,
> +						struct v4l2_subdev_format 
*fmt)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	fmt->pad = pad->index;
> +	return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
> +}
> +
> +static int vimc_cap_link_validate(struct media_link *link)
> +{
> +	struct v4l2_subdev_format source_fmt;
> +	struct v4l2_pix_format *sink_fmt;
> +	struct vimc_cap_device *vcap;
> +	const struct vimc_pix_map *vpix;
> +	int ret;
> +
> +	/* Retrieve the video capture device */
> +	vcap = container_of(link->sink->entity,
> +			    struct vimc_cap_device, vdev.entity);
> +
> +	/* If the connected node is not a subdevice type
> +	 * then it's a raw node from vimc-core, ignore the link for now
> +	 * TODO: remove this when there are no more raw nodes in the
> +	 * core and return error instead
> +	 */
> +	if (!is_media_entity_v4l2_subdev(link->source->entity))
> +		return 0;
> +
> +	/* Get the the format of the video device */
> +	sink_fmt = &vcap->format;
> +
> +	/* Get the the format of the subdev */
> +	ret = vimc_cap_v4l2_subdev_link_validate_get_format(link->source,
> +							    &source_fmt);
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(vcap->dev,
> +		"cap: %s: link validate formats src:%dx%d %d sink:%dx%d %d\n",
> +		vcap->vdev.name,
> +		source_fmt.format.width, source_fmt.format.height,
> +		source_fmt.format.code,
> +		sink_fmt->width, sink_fmt->height,
> +		sink_fmt->pixelformat);
> +
> +	/* Validate the format */
> +
> +	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
> +	if (!vpix)
> +		return -EINVAL;

This can't happen, it should be caught by the set format handler. The driver 
should not allowed the stored pixel format to ever be invalid.

> +	/* The width, height and code must match. */
> +	if (source_fmt.format.width != sink_fmt->width
> +	    || source_fmt.format.height != sink_fmt->height
> +	    || vpix->code != source_fmt.format.code)
> +		return -EINVAL;
> +
> +	/* The field order must match, or the sink field order must be NONE
> +	 * to support interlaced hardware connected to bridges that support
> +	 * progressive formats only.
> +	 */
> +	if (source_fmt.format.field != sink_fmt->field &&
> +	    sink_fmt->field != V4L2_FIELD_NONE)
> +		return -EINVAL;
> +
> +	return 0;
> +}

[snip]

> +struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vb2_queue *q;
> +	struct video_device *vdev;
> +	struct vimc_cap_device *vcap;
> +	const struct vimc_pix_map *vpix;
> +
> +	/* Check entity configuration params
> +	 * NOTE: we only support a single sink pad
> +	 */
> +	if (!name || num_pads != 1 || !pads_flag ||
> +	    !(pads_flag[0] & MEDIA_PAD_FL_SINK))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vimc_cap_device struct */
> +	vcap = kzalloc(sizeof(*vcap), GFP_KERNEL);
> +	if (!vcap)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vimc_cap_device struct with v4l2 and dev parent */
> +	vcap->v4l2_dev = v4l2_dev;
> +	vcap->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vcap->ved.pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vcap->ved.pads)) {
> +		ret = PTR_ERR(vcap->ved.pads);
> +		goto err_free_vcap;
> +	}
> +
> +	/* Initialize the media entity */
> +	vcap->vdev.entity.name = name;
> +	vcap->vdev.entity.function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(&vcap->vdev.entity,
> +				     num_pads, vcap->ved.pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Initialize the lock */
> +	mutex_init(&vcap->lock);
> +
> +	/* Initialize the vb2 queue */
> +	q = &vcap->queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_DMABUF;
> +	q->drv_priv = vcap;
> +	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
> +	q->ops = &vimc_cap_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
> +	q->lock = &vcap->lock;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		dev_err(vcap->dev,
> +			"vb2 queue init failed (err=%d)\n", ret);
> +		goto err_clean_m_ent;
> +	}
> +
> +	/* Initialize buffer list and its lock */
> +	INIT_LIST_HEAD(&vcap->buf_list);
> +	spin_lock_init(&vcap->qlock);
> +
> +	/* Set the frame format (this is hardcoded for now) */
> +	vcap->format.width = 640;
> +	vcap->format.height = 480;
> +	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
> +	vcap->format.field = V4L2_FIELD_NONE;
> +	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
> +
> +	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
> +	vcap->format.sizeimage = vcap->format.bytesperline *
> +				 vcap->format.height;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vcap->ved.destroy = vimc_cap_destroy;
> +	vcap->ved.ent = &vcap->vdev.entity;
> +	vcap->ved.process_frame = vimc_cap_process_frame;
> +
> +	/* Initialize the video_device struct */
> +	vdev = &vcap->vdev;
> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	vdev->entity.ops = &vimc_cap_mops;
> +	vdev->release = video_device_release_empty;

This will result in a crash if you keep the video device node open and unbind 
the vimc device from the driver. However, as the same issue in the media 
controller core hasn't been solved yet, I'm fine fixing all those problems in 
one go later.

> +	vdev->fops = &vimc_cap_fops;
> +	vdev->ioctl_ops = &vimc_cap_ioctl_ops;
> +	vdev->lock = &vcap->lock;
> +	vdev->queue = q;
> +	vdev->v4l2_dev = vcap->v4l2_dev;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +	video_set_drvdata(vdev, vcap);
> +
> +	/* Register the video_device with the v4l2 and the media framework */
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(vcap->dev,
> +			"video register failed (err=%d)\n", ret);
> +		goto err_release_queue;
> +	}
> +
> +	return &vcap->ved;
> +
> +err_release_queue:
> +	vb2_queue_release(q);
> +err_clean_m_ent:
> +	media_entity_cleanup(&vcap->vdev.entity);
> +err_clean_pads:
> +	vimc_pads_cleanup(vcap->ved.pads);
> +err_free_vcap:
> +	kfree(vcap);
> +
> +	return ERR_PTR(ret);
> +}

[snip]

> diff --git a/drivers/media/platform/vimc/vimc-core.c
> b/drivers/media/platform/vimc/vimc-core.c new file mode 100644
> index 0000000..0a2b91b
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-core.c

[snip]

> +#define VIMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) {	\
> +	.src_ent = src,						\
> +	.src_pad = srcpad,					\
> +	.sink_ent = sink,					\
> +	.sink_pad = sinkpad,					\
> +	.flags = link_flags,					\
> +}
> +
> +#define VIMC_PIX_MAP(_code, _bpp, _pixelformat) {	\
> +	.code = _code,					\
> +	.pixelformat = _pixelformat,			\
> +	.bpp = _bpp,					\
> +}
> +
> +struct vimc_device {
> +	/* The pipeline configuration
> +	 * (filled before calling vimc_device_register)
> +	 */
> +	const struct vimc_pipeline_config *pipe_cfg;
> +
> +	/* The Associated media_device parent */
> +	struct media_device mdev;
> +
> +	/* Internal v4l2 parent device*/
> +	struct v4l2_device v4l2_dev;
> +
> +	/* Internal topology */
> +	struct vimc_ent_device **ved;
> +};
> +
> +/**
> + * enum vimc_ent_node - Select the functionality of a node in the topology
> + * @VIMC_ENT_NODE_SENSOR:	A node of type SENSOR simulates a camera 
sensor
> + *				generating internal images in bayer format and
> + *				propagating those images through the pipeline
> + * @VIMC_ENT_NODE_CAPTURE:	A node of type CAPTURE is a v4l2 video_device
> + *				that exposes the received image from the
> + *				pipeline to the user space
> + * @VIMC_ENT_NODE_INPUT:	A node of type INPUT is a v4l2 video_device 
that
> + *				receives images from the user space and
> + *				propagates them through the pipeline
> + * @VIMC_ENT_NODE_DEBAYER:	A node type DEBAYER expects to receive a frame
> + *				in bayer format converts it to RGB
> + * @VIMC_ENT_NODE_SCALER:	A node of type SCALER scales the received 
image
> + *				by a given multiplier
> + *
> + * This enum is used in the entity configuration struct to allow the
> definition + * of a custom topology specifying the role of each node on it.
> + */
> +enum vimc_ent_node {
> +	VIMC_ENT_NODE_SENSOR,
> +	VIMC_ENT_NODE_CAPTURE,
> +	VIMC_ENT_NODE_INPUT,
> +	VIMC_ENT_NODE_DEBAYER,
> +	VIMC_ENT_NODE_SCALER,
> +};
> +
> +/* Structure which describes individual configuration for each entity */
> +struct vimc_ent_config {
> +	const char *name;
> +	size_t pads_qty;
> +	const unsigned long *pads_flag;
> +	enum vimc_ent_node node;
> +};
> +
> +/* Structure which describes links between entities */
> +struct vimc_ent_link {
> +	unsigned int src_ent;
> +	u16 src_pad;
> +	unsigned int sink_ent;
> +	u16 sink_pad;
> +	u32 flags;
> +};
> +
> +/* Structure which describes the whole topology */
> +struct vimc_pipeline_config {
> +	const struct vimc_ent_config *ents;
> +	size_t num_ents;
> +	const struct vimc_ent_link *links;
> +	size_t num_links;
> +};
> +
> +/*
> --------------------------------------------------------------------------
> + * Topology Configuration
> + */
> +
> +static const struct vimc_ent_config ent_config[] = {
> +	{
> +		.name = "Sensor A",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Sensor B",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Debayer A",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Debayer B",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Raw Capture 0",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "Raw Capture 1",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "RGB/YUV Input",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_INPUT,
> +	},
> +	{
> +		.name = "Scaler",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SCALER,
> +	},
> +	{
> +		.name = "RGB/YUV Capture",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +};
> +
> +static const struct vimc_ent_link ent_links[] = {
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Debayer A */
> +	VIMC_ENT_LINK(0, 0, 2, 0, MEDIA_LNK_FL_ENABLED | 
MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Raw Capture 0 */
> +	VIMC_ENT_LINK(0, 0, 4, 0, MEDIA_LNK_FL_ENABLED | 
MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Debayer B */
> +	VIMC_ENT_LINK(1, 0, 3, 0, MEDIA_LNK_FL_ENABLED | 
MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Raw Capture 1 */
> +	VIMC_ENT_LINK(1, 0, 5, 0, MEDIA_LNK_FL_ENABLED | 
MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Debayer A (Pad 1)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(2, 1, 7, 0, MEDIA_LNK_FL_ENABLED),
> +	/* Link: Debayer B (Pad 1)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(3, 1, 7, 0, 0),
> +	/* Link: RGB/YUV Input (Pad 0)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(6, 0, 7, 0, 0),
> +	/* Link: Scaler (Pad 1)->(Pad 0) RGB/YUV Capture */
> +	VIMC_ENT_LINK(7, 1, 8, 0, MEDIA_LNK_FL_ENABLED | 
MEDIA_LNK_FL_IMMUTABLE),
> +};
> +
> +static const struct vimc_pipeline_config pipe_cfg = {
> +	.ents		= ent_config,
> +	.num_ents	= ARRAY_SIZE(ent_config),
> +	.links		= ent_links,
> +	.num_links	= ARRAY_SIZE(ent_links)
> +};
> +
> +/* --------------------------------------------------------------------- */
> +
> +static void vimc_dev_release(struct device *dev)
> +{}

Missing line break between the braces.

> +
> +static struct platform_device vimc_pdev = {
> +	.name		= VIMC_PDEV_NAME,
> +	.dev.release	= vimc_dev_release,
> +};
> +
> +const struct vimc_pix_map vimc_pix_map_list[] = {

This array isn't used outside of the compilation unit, you can make it static.

> +	/* TODO: add all missing formats */
> +
> +	/* RGB formats */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_BGR888_1X24, 3, V4L2_PIX_FMT_BGR24),

Is there really an added value in using the macro compared to direct array 
initialization ?

> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_RGB888_1X24, 3, V4L2_PIX_FMT_RGB24),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_ARGB8888_1X32, 4, V4L2_PIX_FMT_ARGB32),
> +
> +	/* Bayer formats */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR8_1X8, 1, V4L2_PIX_FMT_SBGGR8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG8_1X8, 1, V4L2_PIX_FMT_SGBRG8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG8_1X8, 1, V4L2_PIX_FMT_SGRBG8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB8_1X8, 1, V4L2_PIX_FMT_SRGGB8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_1X10, 2, V4L2_PIX_FMT_SBGGR10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_1X10, 2, V4L2_PIX_FMT_SGBRG10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_1X10, 2, V4L2_PIX_FMT_SGRBG10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_1X10, 2, V4L2_PIX_FMT_SRGGB10),
> +	/* 10bit raw bayer a-law compressed to 8 bits */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8, 1,
> V4L2_PIX_FMT_SBGGR10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8, 1,
> V4L2_PIX_FMT_SGBRG10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8, 1,
> V4L2_PIX_FMT_SGRBG10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8, 1,
> V4L2_PIX_FMT_SRGGB10ALAW8),
> +	/* 10bit raw bayer DPCM compressed to 8 bits */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 1,
> V4L2_PIX_FMT_SBGGR10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 1,
> V4L2_PIX_FMT_SGBRG10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 1,
> V4L2_PIX_FMT_SGRBG10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 1, 
V4L2_PIX_FMT_SRGGB10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR12_1X12, 2, V4L2_PIX_FMT_SBGGR12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG12_1X12, 2, V4L2_PIX_FMT_SGBRG12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG12_1X12, 2, V4L2_PIX_FMT_SGRBG12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB12_1X12, 2, V4L2_PIX_FMT_SRGGB12),
> +
> +	/* End */
> +	{0, 0, 0}
> +};
> +
> +const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vimc_pix_map_list[i].bpp; i++) {

You can use i < ARRAY_SIZE(vimc_pix_map_list) as the condition here and in the 
function below, and get rid of the termination marker in the array.

> +		if (vimc_pix_map_list[i].code == code)
> +			return &vimc_pix_map_list[i];
> +	}
> +	return NULL;
> +}
> +
> +const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vimc_pix_map_list[i].bpp; i++) {
> +		if (vimc_pix_map_list[i].pixelformat == pixelformat)
> +			return &vimc_pix_map_list[i];
> +	}
> +	return NULL;
> +}

[snip]

> +/* TODO: remove this function when all the
> + * entities specific code are implemented
> + */
> +static struct vimc_ent_device *vimc_raw_create(struct v4l2_device
> *v4l2_dev,
> +					       const char *const name,
> +					       u16 num_pads,
> +					       const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vimc_ent_device *ved;
> +
> +	/* Allocate the main ved struct */
> +	ved = kzalloc(sizeof(*ved), GFP_KERNEL);
> +	if (!ved)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Allocate the media entity */
> +	ved->ent = kzalloc(sizeof(*ved->ent), GFP_KERNEL);
> +	if (!ved->ent) {
> +		ret = -ENOMEM;
> +		goto err_free_ved;
> +	}
> +
> +	/* Allocate the pads */
> +	ved->pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(ved->pads)) {
> +		ret = PTR_ERR(ved->pads);
> +		goto err_free_ent;
> +	}
> +
> +	/* Initialize the media entity */
> +	ved->ent->name = name;
> +	ved->ent->function = MEDIA_ENT_F_IO_V4L;

This isn't a video node. You can use MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN for now.

> +	ret = media_entity_pads_init(ved->ent, num_pads, ved->pads);
> +	if (ret)
> +		goto err_cleanup_pads;
> +
> +	/* Register the media entity */
> +	ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
> +	if (ret)
> +		goto err_cleanup_entity;
> +
> +	/* Fill out the destroy function and return */
> +	ved->destroy = vimc_raw_destroy;
> +	return ved;
> +
> +err_cleanup_entity:
> +	media_entity_cleanup(ved->ent);
> +err_cleanup_pads:
> +	vimc_pads_cleanup(ved->pads);
> +err_free_ent:
> +	kfree(ved->ent);
> +err_free_ved:
> +	kfree(ved);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static int vimc_device_register(struct vimc_device *vimc)
> +{
> +	unsigned int i;
> +	int ret = 0;

There's no need to assign 0 to ret here.

> +	/* Allocate memory for the vimc_ent_devices pointers */
> +	vimc->ved = devm_kcalloc(vimc->mdev.dev, vimc->pipe_cfg->num_ents,
> +				 sizeof(*vimc->ved), GFP_KERNEL);
> +	if (!vimc->ved)
> +		return -ENOMEM;
> +
> +	/* Register the media device */
> +	ret = media_device_register(&vimc->mdev);

Shouldn't you register the media device after creating the entities and links 
?

> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"media device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the media device within the v4l2_device */
> +	vimc->v4l2_dev.mdev = &vimc->mdev;
> +
> +	/* Register the v4l2 struct */
> +	ret = v4l2_device_register(vimc->mdev.dev, &vimc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"v4l2 device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Initialize entities */
> +	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
> +		struct vimc_ent_device *(*create_func)(struct v4l2_device *,
> +						       const char *const,
> +						       u16,
> +						       const unsigned long *);
> +
> +		/* Register the specific node */
> +		switch (vimc->pipe_cfg->ents[i].node) {
> +		case VIMC_ENT_NODE_SENSOR:
> +			create_func = vimc_sen_create;
> +			break;
> +
> +		case VIMC_ENT_NODE_CAPTURE:
> +			create_func = vimc_cap_create;
> +			break;
> +
> +		/* TODO: Instantiate the specific topology node */
> +		case VIMC_ENT_NODE_INPUT:
> +		case VIMC_ENT_NODE_DEBAYER:
> +		case VIMC_ENT_NODE_SCALER:
> +		default:
> +			/* TODO: remove this when all the entities specific
> +			 * code are implemented
> +			 */
> +			create_func = vimc_raw_create;
> +			break;
> +		}
> +
> +		vimc->ved[i] = create_func(&vimc->v4l2_dev,
> +					   vimc->pipe_cfg->ents[i].name,
> +					   vimc->pipe_cfg->ents[i].pads_qty,
> +					   vimc->pipe_cfg->ents[i].pads_flag);
> +		if (IS_ERR(vimc->ved[i])) {
> +			ret = PTR_ERR(vimc->ved[i]);
> +			vimc->ved[i] = NULL;
> +			goto err;
> +		}
> +
> +		/* Set use_count to keep track of the ved structure */
> +		vimc->ved[i]->ent->use_count = i;

The media_entity::use_count field is managed by the media controller core. You 
can't use it for your own purpose.

> +	}
> +
> +	/* Initialize the links between entities */
> +	for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
> +		const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
> +
> +		ret = media_create_pad_link(vimc->ved[link->src_ent]->ent,
> +					    link->src_pad,
> +					    vimc->ved[link->sink_ent]->ent,
> +					    link->sink_pad,
> +					    link->flags);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* Expose all subdev's nodes*/
> +	ret = v4l2_device_register_subdev_nodes(&vimc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"vimc subdev nodes registration failed (err=%d)\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	/* Destroy the so far created topology */
> +	vimc_device_unregister(vimc);
> +
> +	return ret;
> +}
> +
> +static int vimc_probe(struct platform_device *pdev)
> +{
> +	struct vimc_device *vimc;
> +	int ret;
> +
> +	/* Prepare the vimc topology structure */
> +
> +	/* Allocate memory for the vimc structure */
> +	vimc = devm_kzalloc(&pdev->dev, sizeof(*vimc), GFP_KERNEL);
> +	if (!vimc)
> +		return -ENOMEM;

We have recently come to an agreement that devm_kzalloc() is harmful to 
allocate structures that embed instances of struct media_device. While this is 
still an unresolved problem, could you please use kzalloc() to avoid making it 
worse ? It will require a kfree() in the error paths and in the remove 
handler.

> +	/* Set the pipeline configuration struct */
> +	vimc->pipe_cfg = &pipe_cfg;
> +
> +	/* Initialize media device */
> +	strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
> +		sizeof(vimc->mdev.model));
> +	vimc->mdev.dev = &pdev->dev;
> +	media_device_init(&vimc->mdev);
> +
> +	/* Create vimc topology */
> +	ret = vimc_device_register(vimc);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"vimc device registration failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the topology object with the platform device object */
> +	platform_set_drvdata(pdev, vimc);
> +
> +	return 0;
> +}
> +
> +static int vimc_remove(struct platform_device *pdev)
> +{
> +	struct vimc_device *vimc;
> +
> +	/* Get the topology object linked with the platform device object */
> +	vimc = platform_get_drvdata(pdev);

You could combine that in a single line

	struct vimc_device *vimc = platform_get_drvdata(pdev);

I understand that the comment was written when you had less experience with 
the kernel code which pushed you on the side of verbosity, but I believe it's 
not really needed :-)

> +
> +	/* Destroy all the topology */
> +	vimc_device_unregister(vimc);
> +
> +	return 0;
> +}

[snip]

> diff --git a/drivers/media/platform/vimc/vimc-sensor.c
> b/drivers/media/platform/vimc/vimc-sensor.c new file mode 100644
> index 0000000..174e5dc
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-sensor.c

[snip]

> +static int vimc_thread_sen(void *data)
> +{
> +	unsigned int i;
> +	struct vimc_sen_device *vsen = data;
> +
> +	set_freezable();
> +
> +	for (;;) {
> +		try_to_freeze();
> +		if (kthread_should_stop())
> +			break;
> +
> +		memset(vsen->frame, 100, vsen->frame_size);
> +
> +		/* Send the frame to all source pads */
> +		for (i = 0; i < vsen->sd.entity.num_pads; i++)
> +			vimc_propagate_frame(vsen->dev,
> +					     &vsen->sd.entity.pads[i],
> +					     vsen->frame);
> +
> +		/* 60 frames per second */
> +		schedule_timeout_interruptible(HZ/60);

What can this be interrupted by ?

> +	}
> +
> +	return 0;
> +}

[snip]

> +struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	int ret;
> +	unsigned int i;
> +	struct vimc_sen_device *vsen;
> +
> +	if (!name || (num_pads && !pads_flag))
> +		return ERR_PTR(-EINVAL);

I think you need at least one pad. Or actually, exactly one pad.

> +	/* check if all pads are sources */
> +	for (i = 0; i < num_pads; i++)
> +		if (!(pads_flag[i] & MEDIA_PAD_FL_SOURCE))
> +			return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vsen struct */
> +	vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
> +	if (!vsen)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vimc_sen_device struct with the v4l2 parent */
> +	vsen->v4l2_dev = v4l2_dev;
> +	/* Link the vimc_sen_device struct with the dev parent */
> +	vsen->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vsen->ved.pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vsen->ved.pads)) {
> +		ret = PTR_ERR(vsen->ved.pads);
> +		goto err_free_vsen;
> +	}
> +
> +	/* Initialize the media entity */
> +	vsen->sd.entity.name = name;
> +	ret = media_entity_pads_init(&vsen->sd.entity,
> +				     num_pads, vsen->ved.pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Set the active frame format (this is hardcoded for now) */
> +	vsen->mbus_format.width = 640;
> +	vsen->mbus_format.height = 480;
> +	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
> +	vsen->mbus_format.field = V4L2_FIELD_NONE;
> +	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
> +	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vsen->ved.destroy = vimc_sen_destroy;
> +	vsen->ved.ent = &vsen->sd.entity;
> +
> +	/* Initialize the subdev */
> +	v4l2_subdev_init(&vsen->sd, &vimc_sen_ops);
> +	vsen->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	vsen->sd.entity.ops = &vimc_sen_mops;
> +	vsen->sd.owner = THIS_MODULE;
> +	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
> +	v4l2_set_subdevdata(&vsen->sd, vsen);
> +
> +	/* Expose this subdev to user space */
> +	vsen->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* Register the subdev with the v4l2 and the media framework */
> +	ret = v4l2_device_register_subdev(vsen->v4l2_dev, &vsen->sd);
> +	if (ret) {
> +		dev_err(vsen->dev,
> +			"subdev register failed (err=%d)\n", ret);
> +		goto err_clean_m_ent;
> +	}
> +
> +	return &vsen->ved;
> +
> +err_clean_m_ent:
> +	media_entity_cleanup(&vsen->sd.entity);
> +err_clean_pads:
> +	vimc_pads_cleanup(vsen->ved.pads);
> +err_free_vsen:
> +	kfree(vsen);
> +
> +	return ERR_PTR(ret);
> +}

[snip]

-- 
Regards,

Laurent Pinchart

