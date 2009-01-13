Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1936 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZAMHYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 02:24:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
Date: Tue, 13 Jan 2009 08:24:20 +0100
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
References: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901130824.20888.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 13 January 2009 03:03:34 Aguirre Rodriguez, Sergio Alberto wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/Kconfig       |    8 +
>  drivers/media/video/Makefile      |    2 +
>  drivers/media/video/omap34xxcam.c | 2017
> +++++++++++++++++++++++++++++++++++++
> drivers/media/video/omap34xxcam.h |  215 ++++
>  4 files changed, 2242 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/omap34xxcam.c
>  create mode 100644 drivers/media/video/omap34xxcam.h
>

...

> +/**
> + * vidioc_default - private IOCTL handler
> + * @file: ptr. to system file structure
> + * @fh: ptr to hold address of omap34xxcam_fh struct (per-filehandle
> data) + * @cmd: ioctl cmd value
> + * @arg: ioctl arg value
> + *
> + * If the sensor being used is a "smart sensor", this request is
> returned to + * caller with -EINVAL err code.  Otherwise if the
> control id is the private + * VIDIOC_PRIVATE_ISP_AEWB_REQ to update
> the analog gain or exposure, + * then this request is forwared
> directly to the sensor to incorporate the + * feedback. The request
> is then passed on to the ISP private IOCTL handler, + *
> isp_handle_private()
> + */
> +static int vidioc_default(struct file *file, void *fh, int cmd, void
> *arg) +{
> +       struct omap34xxcam_fh *ofh = file->private_data;
> +       struct omap34xxcam_videodev *vdev = ofh->vdev;
> +       int rval;
> +
> +       if (vdev->vdev_sensor_config.sensor_isp) {
> +               rval = -EINVAL;
> +       } else {
> +               switch (cmd) {
> +               case VIDIOC_ENUM_FRAMESIZES:
> +                       rval = vidioc_enum_framesizes(file, fh, arg);
> +                       goto out;
> +               case VIDIOC_ENUM_FRAMEINTERVALS:
> +                       rval = vidioc_enum_frameintervals(file, fh,
> arg); +                       goto out;

These two have proper v4l2_ioctl_ops entries, so there is no need to handle
them in vidioc_default.

> +               case VIDIOC_PRIVATE_ISP_AEWB_REQ:
> +               {
> +                       /* Need to update sensor first */
> +                       struct isph3a_aewb_data *data;
> +                       struct v4l2_control vc;
> +
> +                       data = (struct isph3a_aewb_data *) arg;
> +                       if (data->update & SET_EXPOSURE) {
> +                               vc.id = V4L2_CID_EXPOSURE;
> +                               vc.value = data->shutter;
> +                               mutex_lock(&vdev->mutex);
> +                               rval =
> vidioc_int_s_ctrl(vdev->vdev_sensor, +                               
>                         &vc); +                              
> mutex_unlock(&vdev->mutex);
> +                               if (rval)
> +                                       goto out;
> +                       }
> +                       if (data->update & SET_ANALOG_GAIN) {
> +                               vc.id = V4L2_CID_GAIN;
> +                               vc.value = data->gain;
> +                               mutex_lock(&vdev->mutex);
> +                               rval =
> vidioc_int_s_ctrl(vdev->vdev_sensor, +                               
>                         &vc); +                              
> mutex_unlock(&vdev->mutex);
> +                               if (rval)
> +                                       goto out;
> +                       }
> +               }
> +               break;
> +               case VIDIOC_PRIVATE_ISP_AF_REQ: {
> +                       /* Need to update lens first */
> +                       struct isp_af_data *data;
> +                       struct v4l2_control vc;
> +
> +                       if (!vdev->vdev_lens) {
> +                               rval = -EINVAL;
> +                               goto out;
> +                       }
> +                       data = (struct isp_af_data *) arg;
> +                       if (data->update & LENS_DESIRED_POSITION) {
> +                               vc.id = V4L2_CID_FOCUS_ABSOLUTE;
> +                               vc.value =
> data->desired_lens_direction; +                              
> mutex_lock(&vdev->mutex);
> +                               rval =
> vidioc_int_s_ctrl(vdev->vdev_lens, &vc); +                           
>    mutex_unlock(&vdev->mutex);
> +                               if (rval)
> +                                       goto out;
> +                       }
> +                       if (data->update & REQUEST_STATISTICS) {
> +                               vc.id = V4L2_CID_FOCUS_ABSOLUTE;
> +                               mutex_lock(&vdev->mutex);
> +                               rval =
> vidioc_int_g_ctrl(vdev->vdev_lens, &vc); +                           
>    mutex_unlock(&vdev->mutex);
> +                               if (rval)
> +                                       goto out;
> +                               data->xtrastats.lens_position =
> vc.value; +                       }
> +               }
> +                       break;
> +               }
> +
> +               mutex_lock(&vdev->mutex);
> +               rval = isp_handle_private(cmd, arg);
> +               mutex_unlock(&vdev->mutex);
> +       }
> +out:
> +       return rval;
> +}
> +
> +/*
> + *
> + * File operations.
> + *
> + */
> +
> +static long omap34xxcam_unlocked_ioctl(struct file *file, unsigned
> int cmd, +                                      unsigned long arg)
> +{
> +       return (long)video_ioctl2(file->f_dentry->d_inode, file, cmd,
> arg); +}
> +
> +/**
> + * omap34xxcam_poll - file operations poll handler
> + * @file: ptr. to system file structure
> + * @wait: system poll table structure
> + *
> + */
> +static unsigned int omap34xxcam_poll(struct file *file,
> +                                    struct poll_table_struct *wait)
> +{
> +       struct omap34xxcam_fh *fh = file->private_data;
> +       struct omap34xxcam_videodev *vdev = fh->vdev;
> +       struct videobuf_buffer *vb;
> +
> +       mutex_lock(&vdev->mutex);
> +       if (vdev->streaming != file) {
> +               mutex_unlock(&vdev->mutex);
> +               return POLLERR;
> +       }
> +       mutex_unlock(&vdev->mutex);
> +
> +       mutex_lock(&fh->vbq.vb_lock);
> +       if (list_empty(&fh->vbq.stream)) {
> +               mutex_unlock(&fh->vbq.vb_lock);
> +               return POLLERR;
> +       }
> +       vb = list_entry(fh->vbq.stream.next, struct videobuf_buffer,
> stream); +       mutex_unlock(&fh->vbq.vb_lock);
> +
> +       poll_wait(file, &vb->done, wait);
> +
> +       if (vb->state == VIDEOBUF_DONE || vb->state ==
> VIDEOBUF_ERROR) +               return POLLIN | POLLRDNORM;
> +
> +       return 0;
> +}
> +
> +/**
> + * omap34xxcam_mmap - file operations mmap handler
> + * @file: ptr. to system file structure
> + * @vma: system virt. mem. area structure
> + *
> + * Maps a virtual memory area via the video buffer API
> + */
> +static int omap34xxcam_mmap(struct file *file, struct vm_area_struct
> *vma) +{
> +       struct omap34xxcam_fh *fh = file->private_data;
> +       return videobuf_mmap_mapper(&fh->vbq, vma);
> +}
> +
> +/**
> + * omap34xxcam_open - file operations open handler
> + * @inode: ptr. to system inode structure
> + * @file: ptr. to system file structure
> + *
> + * Allocates and initializes the per-filehandle data
> (omap34xxcam_fh), + * enables the sensor, opens/initializes the ISP
> interface and the + * video buffer queue.  Note that this function
> will allow multiple + * file handles to be open simultaneously,
> however only the first + * handle opened will initialize the ISP.  It
> is the application + * responsibility to only use one handle for
> streaming and the others + * for control only.
> + * This function returns 0 upon success and -ENODEV upon error.
> + */
> +static int omap34xxcam_open(struct inode *inode, struct file *file)
> +{
> +       struct omap34xxcam_videodev *vdev = NULL;
> +       struct omap34xxcam_device *cam = omap34xxcam;
> +       struct omap34xxcam_fh *fh;
> +       struct v4l2_format format;
> +       int i;
> +
> +       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
> +               if (cam->vdevs[i].vfd
> +                   && cam->vdevs[i].vfd->minor == iminor(inode)) {
> +                       vdev = &cam->vdevs[i];
> +                       break;
> +               }
> +       }
> +
> +       if (!vdev || !vdev->vfd)
> +               return -ENODEV;
> +
> +       fh = kzalloc(sizeof(*fh), GFP_KERNEL);
> +       if (fh == NULL)
> +               return -ENOMEM;
> +
> +       mutex_lock(&vdev->mutex);
> +       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
> +               if (vdev->slave[i] != v4l2_int_device_dummy()
> +                   && !try_module_get(vdev->slave[i]->module)) {
> +                       mutex_unlock(&vdev->mutex);
> +                       goto out_try_module_get;
> +               }
> +       }
> +
> +       if (atomic_inc_return(&vdev->users) == 1) {
> +               isp_get();
> +               if (omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
> +                                              
> OMAP34XXCAM_SLAVE_POWER_ALL)) +                       goto
> out_slave_power_set_standby;
> +               omap34xxcam_slave_power_set(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
> +               omap34xxcam_slave_power_suggest(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_LENS);
> +       }
> +
> +       fh->vdev = vdev;
> +
> +       /* FIXME: Check that we have sensor now... */
> +       if (vdev->vdev_sensor_config.sensor_isp)
> +               vidioc_int_g_fmt_cap(vdev->vdev_sensor, &format);
> +       else
> +               isp_g_fmt_cap(&format.fmt.pix);
> +
> +       mutex_unlock(&vdev->mutex);
> +       /* FIXME: how about fh->pix when there are more users? */
> +       fh->pix = format.fmt.pix;
> +
> +       file->private_data = fh;
> +
> +       spin_lock_init(&fh->vbq_lock);
> +
> +       videobuf_queue_sg_init(&fh->vbq, &omap34xxcam_vbq_ops, NULL,
> +                               &fh->vbq_lock,
> V4L2_BUF_TYPE_VIDEO_CAPTURE, +                              
> V4L2_FIELD_NONE,
> +                               sizeof(struct videobuf_buffer), fh);
> +
> +       return 0;
> +
> +out_slave_power_set_standby:
> +       omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF,
> +                                   OMAP34XXCAM_SLAVE_POWER_ALL);
> +       isp_put();
> +       atomic_dec(&vdev->users);
> +       mutex_unlock(&vdev->mutex);
> +
> +out_try_module_get:
> +       for (i--; i >= 0; i--)
> +               if (vdev->slave[i] != v4l2_int_device_dummy())
> +                       module_put(vdev->slave[i]->module);
> +
> +       kfree(fh);
> +
> +       return -ENODEV;
> +}
> +
> +/**
> + * omap34xxcam_release - file operations release handler
> + * @inode: ptr. to system inode structure
> + * @file: ptr. to system file structure
> + *
> + * Complement of omap34xxcam_open.  This function will flush any
> scheduled + * work, disable the sensor, close the ISP interface, stop
> the + * video buffer queue from streaming and free the per-filehandle
> data + * (omap34xxcam_fh).  Note that because multiple open file
> handles + * are allowed, this function will only close the ISP and
> disable the + * sensor when the last open file handle (by count) is
> closed. + * This function returns 0.
> + */
> +static int omap34xxcam_release(struct inode *inode, struct file
> *file) +{
> +       struct omap34xxcam_fh *fh = file->private_data;
> +       struct omap34xxcam_videodev *vdev = fh->vdev;
> +       int i;
> +
> +       mutex_lock(&vdev->mutex);
> +       if (vdev->streaming == file) {
> +               isp_stop();
> +               videobuf_streamoff(&fh->vbq);
> +               omap34xxcam_slave_power_set(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_SENSOR);
> +               omap34xxcam_slave_power_suggest(
> +                       vdev, V4L2_POWER_STANDBY,
> +                       OMAP34XXCAM_SLAVE_POWER_LENS);
> +               vdev->streaming = NULL;
> +       }
> +
> +       if (atomic_dec_return(&vdev->users) == 0) {
> +               omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF,
> +                                          
> OMAP34XXCAM_SLAVE_POWER_ALL); +               isp_put();
> +       }
> +       mutex_unlock(&vdev->mutex);
> +
> +       file->private_data = NULL;
> +
> +       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++)
> +               if (vdev->slave[i] != v4l2_int_device_dummy())
> +                       module_put(vdev->slave[i]->module);
> +
> +       kfree(fh);
> +
> +       return 0;
> +}
> +
> +static struct file_operations omap34xxcam_fops = {
> +       .owner = THIS_MODULE,
> +       .llseek = no_llseek,
> +       .unlocked_ioctl = omap34xxcam_unlocked_ioctl,
> +       .poll = omap34xxcam_poll,
> +       .mmap = omap34xxcam_mmap,
> +       .open = omap34xxcam_open,
> +       .release = omap34xxcam_release,
> +};
> +
> +static void omap34xxcam_vfd_name_update(struct omap34xxcam_videodev
> *vdev) +{
> +       struct video_device *vfd = vdev->vfd;
> +       int i;
> +
> +       strlcpy(vfd->name, CAM_SHORT_NAME, sizeof(vfd->name));
> +       for (i = 0; i <= OMAP34XXCAM_SLAVE_FLASH; i++) {
> +               strlcat(vfd->name, "/", sizeof(vfd->name));
> +               if (vdev->slave[i] == v4l2_int_device_dummy())
> +                       continue;
> +               strlcat(vfd->name, vdev->slave[i]->name,
> sizeof(vfd->name)); +       }
> +       dev_info(vdev->cam->dev, "video%d is now %s\n", vfd->minor,
> vfd->name); +}
> +
> +/**
> + * omap34xxcam_device_unregister - V4L2 detach handler
> + * @s: ptr. to standard V4L2 device information structure
> + *
> + * Detach sensor and unregister and release the video device.
> + */
> +static void omap34xxcam_device_unregister(struct v4l2_int_device *s)
> +{
> +       struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
> +       struct omap34xxcam_hw_config hwc;
> +
> +       BUG_ON(vidioc_int_g_priv(s, &hwc) < 0);
> +
> +       mutex_lock(&vdev->mutex);
> +
> +       if (vdev->slave[hwc.dev_type] != v4l2_int_device_dummy()) {
> +               vdev->slave[hwc.dev_type] = v4l2_int_device_dummy();
> +               vdev->slaves--;
> +               omap34xxcam_vfd_name_update(vdev);
> +       }
> +
> +       if (vdev->slaves == 0 && vdev->vfd) {
> +               if (vdev->vfd->minor == -1) {
> +                       /*
> +                        * The device was never registered, so
> release the +                        * video_device struct directly.
> +                        */
> +                       video_device_release(vdev->vfd);
> +               } else {
> +                       /*
> +                        * The unregister function will release the
> +                        * video_device struct as well as
> +                        * unregistering it.
> +                        */
> +                       video_unregister_device(vdev->vfd);
> +               }
> +               vdev->vfd = NULL;
> +       }
> +
> +       mutex_unlock(&vdev->mutex);
> +}
> +
> +static const struct v4l2_ioctl_ops omap34xxcam_ioctl_ops = {
> +       .vidioc_querycap         = vidioc_querycap,
> +       .vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> +       .vidioc_g_fmt_vid_cap    = vidioc_g_fmt_vid_cap,
> +       .vidioc_s_fmt_vid_cap    = vidioc_s_fmt_vid_cap,
> +       .vidioc_try_fmt_vid_cap  = vidioc_try_fmt_vid_cap,
> +       .vidioc_reqbufs          = vidioc_reqbufs,
> +       .vidioc_querybuf         = vidioc_querybuf,
> +       .vidioc_qbuf             = vidioc_qbuf,
> +       .vidioc_dqbuf            = vidioc_dqbuf,
> +       .vidioc_streamon         = vidioc_streamon,
> +       .vidioc_streamoff        = vidioc_streamoff,
> +       .vidioc_enum_input       = vidioc_enum_input,
> +       .vidioc_g_input          = vidioc_g_input,
> +       .vidioc_s_input          = vidioc_s_input,
> +       .vidioc_queryctrl        = vidioc_queryctrl,
> +       .vidioc_querymenu        = vidioc_querymenu,
> +       .vidioc_g_ext_ctrls      = vidioc_g_ext_ctrls,
> +       .vidioc_s_ext_ctrls      = vidioc_s_ext_ctrls,
> +       .vidioc_g_parm           = vidioc_g_parm,
> +       .vidioc_s_parm           = vidioc_s_parm,
> +       .vidioc_cropcap          = vidioc_cropcap,
> +       .vidioc_g_crop           = vidioc_g_crop,
> +       .vidioc_s_crop           = vidioc_s_crop,
> +       .vidioc_default          = vidioc_default,
> +};
> +
> +/**
> + * omap34xxcam_device_register - V4L2 attach handler
> + * @s: ptr. to standard V4L2 device information structure
> + *
> + * Allocates and initializes the V4L2 video_device structure,
> initializes + * the sensor, and finally
> + registers the device with V4L2 based on the
> + * video_device structure.
> + *
> + * Returns 0 on success, otherwise an appropriate error code on
> + * failure.
> + */
> +static int omap34xxcam_device_register(struct v4l2_int_device *s)
> +{
> +       struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
> +       struct omap34xxcam_device *cam = vdev->cam;
> +       struct omap34xxcam_hw_config hwc;
> +       struct video_device *vfd;
> +       int rval;
> +
> +       /* We need to check rval just once. The place is here. */
> +       if (vidioc_int_g_priv(s, &hwc))
> +               return -ENODEV;
> +
> +       if (vdev->index != hwc.dev_index)
> +               return -ENODEV;
> +
> +       if (hwc.dev_type < 0 || hwc.dev_type >
> OMAP34XXCAM_SLAVE_FLASH) +               return -EINVAL;
> +
> +       if (vdev->slave[hwc.dev_type] != v4l2_int_device_dummy())
> +               return -EBUSY;
> +
> +       mutex_lock(&vdev->mutex);
> +       if (atomic_read(&vdev->users)) {
> +               dev_err(cam->dev, "we're open (%d), can't
> register\n", +                       atomic_read(&vdev->users));
> +               mutex_unlock(&vdev->mutex);
> +               return -EBUSY;
> +       }
> +
> +       vdev->slaves++;
> +       vdev->slave[hwc.dev_type] = s;
> +       vdev->slave_config[hwc.dev_type] = hwc;
> +
> +       if (hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR)
> +               isp_get();
> +       rval = omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
> +                                          1 << hwc.dev_type);
> +       if (!rval && hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR) {
> +               struct v4l2_format format;
> +               struct v4l2_streamparm a;
> +
> +               format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               rval = vidioc_int_g_fmt_cap(vdev->vdev_sensor,
> &format); +
> +               a.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               rval |= vidioc_int_g_parm(vdev->vdev_sensor, &a);
> +               if (rval)
> +                       rval = -EBUSY;
> +
> +               vdev->want_pix = format.fmt.pix;
> +               vdev->want_timeperframe =
> a.parm.capture.timeperframe; +       }
> +       omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF, 1 <<
> hwc.dev_type); +       if (hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR)
> +               isp_put();
> +
> +       if (rval)
> +               goto err;
> +
> +       /* Are we the first slave? */
> +       if (vdev->slaves == 1) {
> +               /* initialize the video_device struct */
> +               vdev->vfd = video_device_alloc();
> +               vfd = vdev->vfd;
> +               if (!vfd) {
> +                       dev_err(cam->dev,
> +                               "could not allocate video device
> struct\n"); +                       return -ENOMEM;
> +               }
> +               vfd->release    = video_device_release;
> +               vfd->minor      = -1;
> +               vfd->fops       = &omap34xxcam_fops;
> +               vfd->ioctl_ops  = &omap34xxcam_ioctl_ops;
> +               video_set_drvdata(vfd, vdev);
> +
> +               if (video_register_device(vfd, VFL_TYPE_GRABBER,
> +                                         hwc.dev_minor) < 0) {
> +                       dev_err(cam->dev,
> +                               "could not register V4L device\n");
> +                       vfd->minor = -1;
> +                       rval = -EBUSY;
> +                       goto err;
> +               }
> +       } else {
> +               vfd = vdev->vfd;
> +       }
> +
> +       omap34xxcam_vfd_name_update(vdev);
> +
> +       mutex_unlock(&vdev->mutex);
> +
> +       return 0;
> +
> +err:
> +       if (s == vdev->slave[hwc.dev_type]) {
> +               vdev->slave[hwc.dev_type] = v4l2_int_device_dummy();
> +               vdev->slaves--;
> +       }
> +
> +       mutex_unlock(&vdev->mutex);
> +       omap34xxcam_device_unregister(s);
> +
> +       return rval;
> +}
> +
> +static struct v4l2_int_master omap34xxcam_master = {
> +       .attach = omap34xxcam_device_register,
> +       .detach = omap34xxcam_device_unregister,
> +};
> +
> +/*
> + *
> + * Driver Suspend/Resume
> + *
> + */
> +
> +#ifdef CONFIG_PM
> +/**
> + * omap34xxcam_suspend - platform driver PM suspend handler
> + * @pdev: ptr. to platform level device information structure
> + * @state: power state
> + *
> + * If applicable, stop capture and disable sensor.
> + *
> + * Returns 0 always
> + */
> +static int omap34xxcam_suspend(struct platform_device *pdev,
> pm_message_t state) +{
> +       struct omap34xxcam_videodev *vdev =
> platform_get_drvdata(pdev); +
> +       if (atomic_read(&vdev->users) == 0)
> +               return 0;
> +
> +       if (vdev->streaming) {
> +               isp_stop();
> +               omap34xxcam_slave_power_set(vdev, V4L2_POWER_OFF,
> +                                          
> OMAP34XXCAM_SLAVE_POWER_ALL); +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * omap34xxcam_resume - platform driver PM resume handler
> + * @pdev: ptr. to platform level device information structure
> + *
> + * If applicable, resume capture and enable sensor.
> + *
> + * Returns 0 always
> + */
> +static int omap34xxcam_resume(struct platform_device *pdev)
> +{
> +       struct omap34xxcam_videodev *vdev =
> platform_get_drvdata(pdev); +
> +       if (atomic_read(&vdev->users) == 0)
> +               return 0;
> +
> +       if (vdev->streaming) {
> +               omap34xxcam_slave_power_set(vdev, V4L2_POWER_ON,
> +                                          
> OMAP34XXCAM_SLAVE_POWER_ALL); +               isp_start();
> +       }
> +
> +       return 0;
> +}
> +#endif
> +
> +/*
> + *
> + * Driver initialisation and deinitialisation.
> + *
> + */
> +
> +/**
> + * omap34xxcam_remove - platform driver remove handler
> + * @pdev: ptr. to platform level device information structure
> + *
> + * Unregister device with V4L2, unmap camera registers, and
> + * free camera device information structure (omap34xxcam_device).
> + *
> + * Returns 0 always.
> + */
> +static int omap34xxcam_remove(struct platform_device *pdev)
> +{
> +       struct omap34xxcam_device *cam = platform_get_drvdata(pdev);
> +       int i;
> +
> +       if (!cam)
> +               return 0;
> +
> +       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
> +               if (cam->vdevs[i].cam == NULL)
> +                       continue;
> +
> +               v4l2_int_device_unregister(&cam->vdevs[i].master);
> +               cam->vdevs[i].cam = NULL;
> +       }
> +
> +       omap34xxcam = NULL;
> +
> +       kfree(cam);
> +
> +       return 0;
> +}
> +
> +/**
> + * omap34xxcam_probe - platform driver probe handler
> + * @pdev: ptr. to platform level device information structure
> + *
> + * Allocates and initializes camera device information structure
> + * (omap34xxcam_device), maps the device registers and gets the
> + * device IRQ.  Registers the device as a V4L2 client.
> + *
> + * Returns 0 on success or -ENODEV on failure.
> + */
> +static int omap34xxcam_probe(struct platform_device *pdev)
> +{
> +       struct omap34xxcam_device *cam;
> +       struct isp_sysc isp_sysconfig;
> +       int i;
> +
> +       cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> +       if (!cam) {
> +               dev_err(&pdev->dev, "could not allocate memory\n");
> +               goto err;
> +       }
> +
> +       platform_set_drvdata(pdev, cam);
> +
> +       cam->dev = &pdev->dev;
> +
> +       isp_get();
> +       isp_sysconfig.reset = 0;
> +       isp_sysconfig.idle_mode = 1;
> +       isp_power_settings(isp_sysconfig);
> +       isp_put();
> +
> +       omap34xxcam = cam;
> +
> +       for (i = 0; i < OMAP34XXCAM_VIDEODEVS; i++) {
> +               struct omap34xxcam_videodev *vdev = &cam->vdevs[i];
> +               struct v4l2_int_device *m = &vdev->master;
> +
> +               m->module       = THIS_MODULE;
> +               strlcpy(m->name, CAM_NAME, sizeof(m->name));
> +               m->type         = v4l2_int_type_master;
> +               m->u.master     = &omap34xxcam_master;
> +               m->priv         = vdev;
> +
> +               mutex_init(&vdev->mutex);
> +               vdev->index             = i;
> +               vdev->cam               = cam;
> +               vdev->vdev_sensor =
> +                       vdev->vdev_lens =
> +                       vdev->vdev_flash = v4l2_int_device_dummy();
> +               setup_timer(&vdev->poweroff_timer,
> +                           omap34xxcam_slave_power_timer, (unsigned
> long)vdev); +               INIT_WORK(&vdev->poweroff_work,
> omap34xxcam_slave_power_work); +
> +               if (v4l2_int_device_register(m))
> +                       goto err;
> +       }
> +
> +       return 0;
> +
> +err:
> +       omap34xxcam_remove(pdev);
> +       return -ENODEV;
> +}
> +
> +static struct platform_driver omap34xxcam_driver = {
> +       .probe = omap34xxcam_probe,
> +       .remove = omap34xxcam_remove,
> +#ifdef CONFIG_PM
> +       .suspend = omap34xxcam_suspend,
> +       .resume = omap34xxcam_resume,
> +#endif
> +       .driver = {
> +                  .name = CAM_NAME,
> +                  },
> +};
> +
> +/*
> + *
> + * Module initialisation and deinitialisation
> + *
> + */
> +
> +/**
> + * omap34xxcam_init - module_init function
> + *
> + * Calls platfrom driver to register probe, remove,
> + * suspend and resume functions.
> + *
> + */
> +static int __init omap34xxcam_init(void)
> +{
> +       return platform_driver_register(&omap34xxcam_driver);
> +}
> +
> +/**
> + * omap34xxcam_cleanup - module_exit function
> + *
> + * Calls platfrom driver to unregister probe, remove,
> + * suspend and resume functions.
> + *
> + */
> +static void __exit omap34xxcam_cleanup(void)
> +{
> +       platform_driver_unregister(&omap34xxcam_driver);
> +}
> +
> +MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com");
> +MODULE_DESCRIPTION("OMAP34xx Video for Linux camera driver");
> +MODULE_LICENSE("GPL");
> +
> +late_initcall(omap34xxcam_init);
> +module_exit(omap34xxcam_cleanup);
> diff --git a/drivers/media/video/omap34xxcam.h
> b/drivers/media/video/omap34xxcam.h new file mode 100644
> index 0000000..cc024eb
> --- /dev/null
> +++ b/drivers/media/video/omap34xxcam.h
> @@ -0,0 +1,215 @@
> +/*
> + * drivers/media/video/omap34xxcam.c
> + *
> + * Copyright (C) 2006--2008 Nokia Corporation
> + * Copyright (C) 2007, 2008 Texas Instruments
> + *
> + * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> + *          Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> + *
> + * Originally based on the OMAP 2 camera driver.
> + *
> + * Written by Sakari Ailus <sakari.ailus@nokia.com>
> + *            Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> + *            Sergio Aguirre <saaguirre@ti.com>
> + *            Mohit Jalori
> + *            Sameer Venkatraman
> + *            Leonides Martinez
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> but + * WITHOUT ANY WARRANTY; without even the implied warranty of +
> * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU +
> * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef OMAP34XXCAM_H
> +#define OMAP34XXCAM_H
> +
> +#include <media/v4l2-int-device.h>
> +#include "isp/isp.h"
> +
> +#define CAM_NAME                       "omap34xxcam"
> +#define CAM_SHORT_NAME                 "omap3"
> +
> +#define OMAP_ISP_AF            (1 << 4)
> +#define OMAP_ISP_HIST          (1 << 5)
> +#define OMAP34XXCAM_XCLK_NONE  -1
> +#define OMAP34XXCAM_XCLK_A     0
> +#define OMAP34XXCAM_XCLK_B     1
> +
> +#define OMAP34XXCAM_SLAVE_SENSOR       0
> +#define OMAP34XXCAM_SLAVE_LENS         1
> +#define OMAP34XXCAM_SLAVE_FLASH                2 /* This is the last
> slave! */ +
> +/* mask for omap34xxcam_slave_power_set */
> +#define OMAP34XXCAM_SLAVE_POWER_SENSOR (1 <<
> OMAP34XXCAM_SLAVE_SENSOR) +#define OMAP34XXCAM_SLAVE_POWER_LENS   (1
> << OMAP34XXCAM_SLAVE_LENS) +#define
> OMAP34XXCAM_SLAVE_POWER_SENSOR_LENS \
> +       (OMAP34XXCAM_SLAVE_POWER_SENSOR |
> OMAP34XXCAM_SLAVE_POWER_LENS) +#define OMAP34XXCAM_SLAVE_POWER_FLASH 
> (1 << OMAP34XXCAM_SLAVE_FLASH) +#define OMAP34XXCAM_SLAVE_POWER_ALL  
>  -1
> +
> +#define OMAP34XXCAM_VIDEODEVS          4
> +
> +struct omap34xxcam_device;
> +struct omap34xxcam_videodev;
> +
> +struct omap34xxcam_sensor_config {
> +       int xclk;
> +       int sensor_isp;
> +       u32 capture_mem;
> +};
> +
> +struct omap34xxcam_lens_config {
> +};
> +
> +struct omap34xxcam_flash_config {
> +};
> +
> +/**
> + * struct omap34xxcam_hw_config - struct for vidioc_int_g_priv ioctl
> + * @xclk: OMAP34XXCAM_XCLK_A or OMAP34XXCAM_XCLK_B
> + * @sensor_isp: Is sensor smart/SOC or raw
> + * @s_pix_sparm: Access function to set pix and sparm.
> + * Pix will override sparm
> + */
> +struct omap34xxcam_hw_config {
> +       int dev_index; /* Index in omap34xxcam_sensors */
> +       int dev_minor; /* Video device minor number */
> +       int dev_type; /* OMAP34XXCAM_SLAVE_* */
> +       union {
> +               struct omap34xxcam_sensor_config sensor;
> +               struct omap34xxcam_lens_config lens;
> +               struct omap34xxcam_flash_config flash;
> +       } u;
> +};
> +
> +/**
> + * struct omap34xxcam_videodev - per /dev/video* structure
> + * @mutex: serialises access to this structure
> + * @cam: pointer to cam hw structure
> + * @master: we are v4l2_int_device master
> + * @sensor: sensor device
> + * @lens: lens device
> + * @flash: flash device
> + * @slaves: how many slaves we have at the moment
> + * @vfd: our video device
> + * @capture_mem: maximum kernel-allocated capture memory
> + * @if_u: sensor interface stuff
> + * @index: index of this structure in cam->vdevs
> + * @users: how many users we have
> + * @power_state: Current power state
> + * @power_state_wish: New power state when poweroff_timer expires
> + * @power_state_mask: Bitmask of devices to set the new power state
> + * @poweroff_timer: Timer for dispatching poweroff_work
> + * @poweroff_work: Work for slave power state change
> + * @sensor_config: ISP-speicific sensor configuration
> + * @lens_config: ISP-speicific lens configuration
> + * @flash_config: ISP-speicific flash configuration
> + * @streaming: streaming file handle, if streaming is enabled
> + */
> +struct omap34xxcam_videodev {
> +       struct mutex mutex; /* serialises access to this structure */
> +
> +       struct omap34xxcam_device *cam;
> +       struct v4l2_int_device master;
> +
> +#define vdev_sensor slave[OMAP34XXCAM_SLAVE_SENSOR]
> +#define vdev_lens slave[OMAP34XXCAM_SLAVE_LENS]
> +#define vdev_flash slave[OMAP34XXCAM_SLAVE_FLASH]
> +       struct v4l2_int_device *slave[OMAP34XXCAM_SLAVE_FLASH + 1];
> +
> +       /* number of slaves attached */
> +       int slaves;
> +
> +       /*** video device parameters ***/
> +       struct video_device *vfd;
> +       int capture_mem;
> +
> +       /*** general driver state information ***/
> +       /*
> +        * Sensor interface parameters: interface type, CC_CTRL
> +        * register value and interface specific data.
> +        */
> +       u32 xclk;
> +       /* index to omap34xxcam_videodevs of this structure */
> +       int index;
> +       atomic_t users;
> +       enum v4l2_power power_state[OMAP34XXCAM_SLAVE_FLASH + 1];
> +       enum v4l2_power power_state_wish;
> +       int power_state_mask;
> +       struct timer_list poweroff_timer;
> +       struct work_struct poweroff_work;
> +
> +#define vdev_sensor_config
> slave_config[OMAP34XXCAM_SLAVE_SENSOR].u.sensor +#define
> vdev_lens_config slave_config[OMAP34XXCAM_SLAVE_LENS].u.lens +#define
> vdev_flash_config slave_config[OMAP34XXCAM_SLAVE_FLASH].u.flash +    
>   struct omap34xxcam_hw_config slave_config[OMAP34XXCAM_SLAVE_FLASH +
> 1]; +
> +       /*** capture data ***/
> +       struct v4l2_fract want_timeperframe;
> +       struct v4l2_pix_format want_pix;
> +       /* file handle, if streaming is on */
> +       struct file *streaming;
> +};
> +
> +/**
> + * struct omap34xxcam_device - per-device data structure
> + * @mutex: mutex serialises access to this structure
> + * @sgdma_in_queue: Number or sgdma requests in scatter-gather
> queue, + * protected by the lock above.
> + * @sgdma: ISP sgdma subsystem information structure
> + * @dma_notify: DMA notify flag
> + * @irq: irq number platform HW resource
> + * @mmio_base: register map memory base (platform HW resource)
> + * @mmio_base_phys: register map memory base physical address
> + * @mmio_size: register map memory size
> + * @dev: device structure
> + * @vdevs: /dev/video specific structures
> + * @fck: camera module fck clock information
> + * @ick: camera module ick clock information
> + */
> +struct omap34xxcam_device {
> +       struct mutex mutex; /* serialises access to this structure */
> +       int sgdma_in_queue;
> +       struct isp_sgdma sgdma;
> +       int dma_notify;
> +
> +       /*** interfaces and device ***/
> +       struct device *dev;
> +       struct omap34xxcam_videodev vdevs[OMAP34XXCAM_VIDEODEVS];
> +
> +       /*** camera module clocks ***/
> +       struct clk *fck;
> +       struct clk *ick;
> +       bool sensor_if_enabled;
> +};
> +
> +/**
> + * struct omap34xxcam_fh - per-filehandle data structure
> + * @vbq_lock: spinlock for the videobuf queue
> + * @vbq: V4L2 video buffer queue structure
> + * @pix: V4L2 pixel format structure (serialise pix by vbq->lock)
> + * @field_count: field counter for videobuf_buffer
> + * @vdev: our /dev/video specific structure
> + */
> +struct omap34xxcam_fh {
> +       spinlock_t vbq_lock; /* spinlock for the videobuf queue */
> +       struct videobuf_queue vbq;
> +       struct v4l2_pix_format pix;
> +       atomic_t field_count;
> +       /* accessing cam here doesn't need serialisation: it's
> constant */ +       struct omap34xxcam_videodev *vdev;
> +};
> +
> +#endif /* ifndef OMAP34XXCAM_H */

Urgh. v4l2_pix_format is NOT filehandle-specific! It is device global and
should be part of omap34xxcam_device. The same should probably be true for
videobuf_queue.

I know that there is a bunch of other v4l drivers that do the same that
you are doing here, but these are all wrong and do not follow the v4l2
specification correctly. They are on my to do list to fix.

Also note that substantial changes were made in the v4l2 core for 2.6.29,
so this patch will not apply there. The file_operations struct is replaced
by a v4l2_file_operations struct and the inode pointer was dropped from
the various ops.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
