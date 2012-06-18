Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:58533 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab2FRKPF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 06:15:05 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: "balbi@ti.com" <balbi@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 18 Jun 2012 18:14:51 +0800
Subject: RE: [PATCH 5/5] usb: gadget/uvc: Add support for
 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FAA27582D@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <b0c0023b38755f2b9103adb17fd7847b9ba45d0b.1338543124.git.bhupesh.sharma@st.com>
In-Reply-To: <b0c0023b38755f2b9103adb17fd7847b9ba45d0b.1338543124.git.bhupesh.sharma@st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Can you please review this patch and let me know if any modifications are required..

> -----Original Message-----
> From: Bhupesh SHARMA
> Sent: Friday, June 01, 2012 3:09 PM
> To: laurent.pinchart@ideasonboard.com; linux-usb@vger.kernel.org
> Cc: balbi@ti.com; linux-media@vger.kernel.org;
> gregkh@linuxfoundation.org; Bhupesh SHARMA
> Subject: [PATCH 5/5] usb: gadget/uvc: Add support for
> 'USB_GADGET_DELAYED_STATUS' response for a set_intf(alt-set 1) command
> 
> This patch adds the support in UVC webcam gadget design for providing
> USB_GADGET_DELAYED_STATUS in response to a set_interface(alt setting 1)
> command
> issue by the Host.
> 
> The current UVC webcam gadget design generates a STREAMON event
> corresponding
> to a set_interface(alt setting 1) command from the Host. This STREAMON
> event
> will eventually be routed to a real V4L2 device.
> 
> To start video streaming, it may be required to perform some register
> writes to
> a camera sensor device over slow external busses like I2C or SPI. So,
> it makes
> sense to ensure that we delay the STATUS stage of the
> set_interface(alt setting 1) command.
> 
> Otherwise, a lot of ISOC IN tokens sent by the Host will be replied to
> by
> zero-length packets by the webcam device. On certain Hosts this may
> even lead
> to ISOC URBs been cancelled from the Host side.
> 
> So, as soon as we finish doing all the "streaming" related stuff on the
> real
> V4L2 device, we call a STREAMON ioctl on the UVC side and from here we
> call the
> 'usb_composite_setup_continue' function to complete the status stage of
> the
> set_interface(alt setting 1) command.
> 
> Further, we need to ensure that we queue no video buffers on the UVC
> webcam
> gadget, until we de-queue a video buffer from the V4L2 device. Also, we
> need to
> enable UVC video related stuff at the first QBUF ioctl call itself,
> as the application will call the STREAMON on UVC side only when it has
> dequeued sufficient buffers from the V4L2 side and queued them to the
> UVC
> gadget. So, the UVC video enable stuff cannot be done in STREAMON ioctl
> call.
> 
> For the same we add two more UVC states:
> 	- PRE_STREAMING : not even a single buffer has been queued to UVC
> 	- BUF_QUEUED_STREAMING_OFF : one video buffer has been queued to
> UVC
> 			but we have not yet enabled STREAMING on UVC side.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> ---
>  drivers/usb/gadget/f_uvc.c    |   17 ++++++++++++-----
>  drivers/usb/gadget/uvc.h      |    3 +++
>  drivers/usb/gadget/uvc_v4l2.c |   38
> ++++++++++++++++++++++++++++++++++++--
>  3 files changed, 51 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
> index 2a8bf06..3589ed0 100644
> --- a/drivers/usb/gadget/f_uvc.c
> +++ b/drivers/usb/gadget/f_uvc.c
> @@ -272,6 +272,13 @@ uvc_function_setup(struct usb_function *f, const
> struct usb_ctrlrequest *ctrl)
>  	return 0;
>  }
> 
> +void uvc_function_setup_continue(struct uvc_device *uvc)
> +{
> +	struct usb_composite_dev *cdev = uvc->func.config->cdev;
> +
> +	usb_composite_setup_continue(cdev);
> +}
> +
>  static int
>  uvc_function_get_alt(struct usb_function *f, unsigned interface)
>  {
> @@ -334,7 +341,8 @@ uvc_function_set_alt(struct usb_function *f,
> unsigned interface, unsigned alt)
>  		v4l2_event_queue(uvc->vdev, &v4l2_event);
> 
>  		uvc->state = UVC_STATE_CONNECTED;
> -		break;
> +
> +		return 0;
> 
>  	case 1:
>  		if (uvc->state != UVC_STATE_CONNECTED)
> @@ -352,14 +360,13 @@ uvc_function_set_alt(struct usb_function *f,
> unsigned interface, unsigned alt)
>  		v4l2_event.type = UVC_EVENT_STREAMON;
>  		v4l2_event_queue(uvc->vdev, &v4l2_event);
> 
> -		uvc->state = UVC_STATE_STREAMING;
> -		break;
> +		uvc->state = UVC_STATE_PRE_STREAMING;
> +
> +		return USB_GADGET_DELAYED_STATUS;
> 
>  	default:
>  		return -EINVAL;
>  	}
> -
> -	return 0;
>  }
> 
>  static void
> diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> index d78ea25..6cd1435 100644
> --- a/drivers/usb/gadget/uvc.h
> +++ b/drivers/usb/gadget/uvc.h
> @@ -141,6 +141,8 @@ enum uvc_state
>  {
>  	UVC_STATE_DISCONNECTED,
>  	UVC_STATE_CONNECTED,
> +	UVC_STATE_PRE_STREAMING,
> +	UVC_STATE_BUF_QUEUED_STREAMING_OFF,
>  	UVC_STATE_STREAMING,
>  };
> 
> @@ -190,6 +192,7 @@ struct uvc_file_handle
>   * Functions
>   */
> 
> +extern void uvc_function_setup_continue(struct uvc_device *uvc);
>  extern void uvc_endpoint_stream(struct uvc_device *dev);
> 
>  extern void uvc_function_connect(struct uvc_device *uvc);
> diff --git a/drivers/usb/gadget/uvc_v4l2.c
> b/drivers/usb/gadget/uvc_v4l2.c
> index 9c2b45b..5f23571 100644
> --- a/drivers/usb/gadget/uvc_v4l2.c
> +++ b/drivers/usb/gadget/uvc_v4l2.c
> @@ -235,10 +235,36 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int
> cmd, void *arg)
>  	}
> 
>  	case VIDIOC_QBUF:
> +		/*
> +		 * Theory of operation:
> +		 * - for the very first QBUF call the uvc state will be
> +		 *   UVC_STATE_PRE_STREAMING, so we need to initialize
> +		 *   the UVC video pipe (allocate requests, init queue,
> +		 *   ..) and change the uvc state to
> +		 *   UVC_STATE_BUF_QUEUED_STREAMING_OFF.
> +		 *
> +		 * - For the QBUF calls thereafter, (until STREAMON is
> +		 *   called) we just need to queue the buffers.
> +		 *
> +		 * - Once STREAMON has been called (which is handled by the
> +		 *   STREAMON case below), we need to start pumping the
> data
> +		 *   to USB side here itself.
> +		 */
>  		if ((ret = uvc_queue_buffer(&video->queue, arg)) < 0)
>  			return ret;
> 
> -		return uvc_video_pump(video);
> +		if (uvc->state == UVC_STATE_PRE_STREAMING) {
> +			ret = uvc_video_enable(video, 1);
> +			if (ret < 0)
> +				return ret;
> +
> +			uvc->state = UVC_STATE_BUF_QUEUED_STREAMING_OFF;
> +			return 0;
> +		} else if (uvc->state == UVC_STATE_STREAMING) {
> +			return uvc_video_pump(video);
> +		} else {
> +			return 0;
> +		}
> 
>  	case VIDIOC_DQBUF:
>  		return uvc_dequeue_buffer(&video->queue, arg,
> @@ -251,7 +277,15 @@ uvc_v4l2_do_ioctl(struct file *file, unsigned int
> cmd, void *arg)
>  		if (*type != video->queue.queue.type)
>  			return -EINVAL;
> 
> -		return uvc_video_enable(video, 1);
> +		/*
> +		 * since the real video device has now started streaming
> +		 * its safe now to complete the status phase of the
> +		 * set_interface (alt setting 1)
> +		 */
> +		uvc_function_setup_continue(uvc);
> +		uvc->state = UVC_STATE_STREAMING;
> +
> +		return 0;
>  	}
> 
>  	case VIDIOC_STREAMOFF:
> --
> 1.7.2.2

Regards,
Bhupesh
