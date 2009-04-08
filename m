Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:52410 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZDHXgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 19:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <1239212193-27618-2-git-send-email-david.vrabel@csr.com>
References: <1239212193-27618-1-git-send-email-david.vrabel@csr.com>
	 <1239212193-27618-2-git-send-email-david.vrabel@csr.com>
Date: Thu, 9 Apr 2009 03:36:51 +0400
Message-ID: <208cbae30904081636x71e7675egad7566bc601cb2cf@mail.gmail.com>
Subject: Re: [PATCH] usb: add reset endpoint operations
From: Alexey Klimov <klimov.linux@gmail.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added linux-media maillist)

Hello, David

On Wed, Apr 8, 2009 at 9:36 PM, David Vrabel <david.vrabel@csr.com> wrote:
> Wireless USB endpoint state has a sequence number and a current
> window and not just a single toggle bit.  So allow HCDs to provide a
> endpoint_reset method and call this or clear the software toggles as
> required (after a clear halt, set configuration etc.).
>
> usb_settoggle() and friends are then HCD internal and are moved into
> core/hcd.h and all device drivers call usb_reset_endpoint() instead.
>
> If the device endpoint state has been reset (with a clear halt) but
> the host endpoint state has not then subsequent data transfers will
> not complete. The device will only work again after it is reset or
> disconnected.
>
> Signed-off-by: David Vrabel <david.vrabel@csr.com>
> ---
>  drivers/block/ub.c                        |   20 ++++-----
>  drivers/isdn/hisax/st5481_usb.c           |    9 +----
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c |    1 -

Looks like you change file under /drivers/video. It's better at least
to add linux-media maillist  or driver maintainer (not only linux-usb
list) to let developers know that you change drivers.

Another approach here - you can create separate patch for this driver
and post it to linux-media list at vger.kernel.org and to linux-usb
list. It will be easy for v4l developers to handle things like merging
changes from upstream kernel tree to v4l-dvb mercurial tree (in case
if there are changes that went to v4l drivers not from v4l).

>  drivers/usb/core/devio.c                  |    2 +-
>  drivers/usb/core/hcd.c                    |   26 +++++++++++++
>  drivers/usb/core/hcd.h                    |   14 +++++++
>  drivers/usb/core/message.c                |   58 ++++++++++++++++++----------
>  drivers/usb/core/usb.c                    |    2 +-
>  drivers/usb/storage/transport.c           |    4 +-
>  include/linux/usb.h                       |    9 +----
>  10 files changed, 91 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/block/ub.c b/drivers/block/ub.c
> index 69b7f8e..689cd27 100644
> --- a/drivers/block/ub.c
> +++ b/drivers/block/ub.c
> @@ -1025,6 +1025,7 @@ static void ub_scsi_urb_compl(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>  {
>        struct urb *urb = &sc->work_urb;
>        struct bulk_cs_wrap *bcs;
> +       int endp;
>        int len;
>        int rc;
>
> @@ -1033,6 +1034,10 @@ static void ub_scsi_urb_compl(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>                return;
>        }
>
> +       endp = usb_pipeendpoint(sc->last_pipe);
> +       if (usb_pipein(sc->last_pipe))
> +               endp |= USB_DIR_IN;
> +
>        if (cmd->state == UB_CMDST_CLEAR) {
>                if (urb->status == -EPIPE) {
>                        /*
> @@ -1048,9 +1053,7 @@ static void ub_scsi_urb_compl(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>                 * We ignore the result for the halt clear.
>                 */
>
> -               /* reset the endpoint toggle */
> -               usb_settoggle(sc->dev, usb_pipeendpoint(sc->last_pipe),
> -                       usb_pipeout(sc->last_pipe), 0);
> +               usb_reset_endpoint(sc->dev, endp);
>
>                ub_state_sense(sc, cmd);
>
> @@ -1065,9 +1068,7 @@ static void ub_scsi_urb_compl(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>                 * We ignore the result for the halt clear.
>                 */
>
> -               /* reset the endpoint toggle */
> -               usb_settoggle(sc->dev, usb_pipeendpoint(sc->last_pipe),
> -                       usb_pipeout(sc->last_pipe), 0);
> +               usb_reset_endpoint(sc->dev, endp);
>
>                ub_state_stat(sc, cmd);
>
> @@ -1082,9 +1083,7 @@ static void ub_scsi_urb_compl(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>                 * We ignore the result for the halt clear.
>                 */
>
> -               /* reset the endpoint toggle */
> -               usb_settoggle(sc->dev, usb_pipeendpoint(sc->last_pipe),
> -                       usb_pipeout(sc->last_pipe), 0);
> +               usb_reset_endpoint(sc->dev, endp);
>
>                ub_state_stat_counted(sc, cmd);
>
> @@ -2119,8 +2118,7 @@ static int ub_probe_clear_stall(struct ub_dev *sc, int stalled_pipe)
>        del_timer_sync(&timer);
>        usb_kill_urb(&sc->work_urb);
>
> -       /* reset the endpoint toggle */
> -       usb_settoggle(sc->dev, endp, usb_pipeout(sc->last_pipe), 0);
> +       usb_reset_endpoint(sc->dev, endp);
>
>        return 0;
>  }
> diff --git a/drivers/isdn/hisax/st5481_usb.c b/drivers/isdn/hisax/st5481_usb.c
> index ec3c0e5..2b3a055 100644
> --- a/drivers/isdn/hisax/st5481_usb.c
> +++ b/drivers/isdn/hisax/st5481_usb.c
> @@ -149,14 +149,7 @@ static void usb_ctrl_complete(struct urb *urb)
>        if (ctrl_msg->dr.bRequest == USB_REQ_CLEAR_FEATURE) {
>                /* Special case handling for pipe reset */
>                le16_to_cpus(&ctrl_msg->dr.wIndex);
> -
> -               /* toggle is reset on clear */
> -               usb_settoggle(adapter->usb_dev,
> -                             ctrl_msg->dr.wIndex & ~USB_DIR_IN,
> -                             (ctrl_msg->dr.wIndex & USB_DIR_IN) == 0,
> -                             0);
> -
> -
> +               usb_reset_endpoint(adapter->usb_dev, ctrl_msg->dr.wIndex);
>        }
>
>        if (ctrl_msg->complete)
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index d9d974a..add3395 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -1461,7 +1461,6 @@ static int pvr2_upload_firmware1(struct pvr2_hdw *hdw)
>                return ret;
>        }
>
> -       usb_settoggle(hdw->usb_dev, 0 & 0xf, !(0 & USB_DIR_IN), 0);
>        usb_clear_halt(hdw->usb_dev, usb_sndbulkpipe(hdw->usb_dev, 0 & 0x7f));
>
>        pipe = usb_sndctrlpipe(hdw->usb_dev, 0);
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index df3c539..3086090 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -841,7 +841,7 @@ static int proc_resetep(struct dev_state *ps, void __user *arg)
>        ret = checkintf(ps, ret);
>        if (ret)
>                return ret;
> -       usb_settoggle(ps->dev, ep & 0xf, !(ep & USB_DIR_IN), 0);
> +       usb_reset_endpoint(ps->dev, ep);
>        return 0;
>  }
>
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 81fa850..42b93da 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1539,6 +1539,32 @@ void usb_hcd_disable_endpoint(struct usb_device *udev,
>                hcd->driver->endpoint_disable(hcd, ep);
>  }
>
> +/**
> + * usb_hcd_reset_endpoint - reset host endpoint state
> + * @udev: USB device.
> + * @ep:   the endpoint to reset.
> + *
> + * Resets any host endpoint state such as the toggle bit, sequence
> + * number and current window.
> + */
> +void usb_hcd_reset_endpoint(struct usb_device *udev,
> +                           struct usb_host_endpoint *ep)
> +{
> +       struct usb_hcd *hcd = bus_to_hcd(udev->bus);
> +
> +       if (hcd->driver->endpoint_reset)
> +               hcd->driver->endpoint_reset(hcd, ep);
> +       else {
> +               int epnum = usb_endpoint_num(&ep->desc);
> +               int is_out = usb_endpoint_dir_out(&ep->desc);
> +               int is_control = usb_endpoint_xfer_control(&ep->desc);
> +
> +               usb_settoggle(udev, epnum, is_out, 0);
> +               if (is_control)
> +                       usb_settoggle(udev, epnum, !is_out, 0);
> +       }
> +}
> +
>  /* Protect against drivers that try to unlink URBs after the device
>  * is gone, by waiting until all unlinks for @udev are finished.
>  * Since we don't currently track URBs by device, simply wait until
> diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
> index f750eb1..e7d4479 100644
> --- a/drivers/usb/core/hcd.h
> +++ b/drivers/usb/core/hcd.h
> @@ -206,6 +206,11 @@ struct hc_driver {
>        void    (*endpoint_disable)(struct usb_hcd *hcd,
>                        struct usb_host_endpoint *ep);
>
> +       /* (optional) reset any endpoint state such as sequence number
> +          and current window */
> +       void    (*endpoint_reset)(struct usb_hcd *hcd,
> +                       struct usb_host_endpoint *ep);
> +
>        /* root hub support */
>        int     (*hub_status_data) (struct usb_hcd *hcd, char *buf);
>        int     (*hub_control) (struct usb_hcd *hcd,
> @@ -234,6 +239,8 @@ extern void usb_hcd_flush_endpoint(struct usb_device *udev,
>                struct usb_host_endpoint *ep);
>  extern void usb_hcd_disable_endpoint(struct usb_device *udev,
>                struct usb_host_endpoint *ep);
> +extern void usb_hcd_reset_endpoint(struct usb_device *udev,
> +               struct usb_host_endpoint *ep);
>  extern void usb_hcd_synchronize_unlinks(struct usb_device *udev);
>  extern int usb_hcd_get_frame_number(struct usb_device *udev);
>
> @@ -279,6 +286,13 @@ extern irqreturn_t usb_hcd_irq(int irq, void *__hcd);
>  extern void usb_hc_died(struct usb_hcd *hcd);
>  extern void usb_hcd_poll_rh_status(struct usb_hcd *hcd);
>
> +/* The D0/D1 toggle bits ... USE WITH CAUTION (they're almost hcd-internal) */
> +#define usb_gettoggle(dev, ep, out) (((dev)->toggle[out] >> (ep)) & 1)
> +#define        usb_dotoggle(dev, ep, out)  ((dev)->toggle[out] ^= (1 << (ep)))
> +#define usb_settoggle(dev, ep, out, bit) \
> +               ((dev)->toggle[out] = ((dev)->toggle[out] & ~(1 << (ep))) | \
> +                ((bit) << (ep)))
> +
>  /* -------------------------------------------------------------------------- */
>
>  /* Enumeration is only for the hub driver, or HCD virtual root hubs */
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 30a0690..b626283 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -1002,8 +1002,7 @@ int usb_clear_halt(struct usb_device *dev, int pipe)
>         * the copy in usb-storage, for as long as we need two copies.
>         */
>
> -       /* toggle was reset by the clear */
> -       usb_settoggle(dev, usb_pipeendpoint(pipe), usb_pipeout(pipe), 0);
> +       usb_reset_endpoint(dev, endp);
>
>        return 0;
>  }
> @@ -1076,6 +1075,30 @@ void usb_disable_endpoint(struct usb_device *dev, unsigned int epaddr,
>  }
>
>  /**
> + * usb_reset_endpoint - Reset an endpoint's state.
> + * @dev: the device whose endpoint is to be reset
> + * @epaddr: the endpoint's address.  Endpoint number for output,
> + *     endpoint number + USB_DIR_IN for input
> + *
> + * Resets any host-side endpoint state such as the toggle bit,
> + * sequence number or current window.
> + */
> +void usb_reset_endpoint(struct usb_device *dev, unsigned int epaddr)
> +{
> +       unsigned int epnum = epaddr & USB_ENDPOINT_NUMBER_MASK;
> +       struct usb_host_endpoint *ep;
> +
> +       if (usb_endpoint_out(epaddr))
> +               ep = dev->ep_out[epnum];
> +       else
> +               ep = dev->ep_in[epnum];
> +       if (ep)
> +               usb_hcd_reset_endpoint(dev, ep);
> +}
> +EXPORT_SYMBOL_GPL(usb_reset_endpoint);
> +
> +
> +/**
>  * usb_disable_interface -- Disable all endpoints for an interface
>  * @dev: the device whose interface is being disabled
>  * @intf: pointer to the interface descriptor
> @@ -1117,7 +1140,6 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
>                usb_disable_endpoint(dev, i, true);
>                usb_disable_endpoint(dev, i + USB_DIR_IN, true);
>        }
> -       dev->toggle[0] = dev->toggle[1] = 0;
>
>        /* getting rid of interfaces will disconnect
>         * any drivers bound to them (a key side effect)
> @@ -1154,28 +1176,24 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
>  * usb_enable_endpoint - Enable an endpoint for USB communications
>  * @dev: the device whose interface is being enabled
>  * @ep: the endpoint
> - * @reset_toggle: flag to set the endpoint's toggle back to 0
> + * @reset_ep: flag to reset the endpoint state
>  *
> - * Resets the endpoint toggle if asked, and sets dev->ep_{in,out} pointers.
> + * Resets the endpoint state if asked, and sets dev->ep_{in,out} pointers.
>  * For control endpoints, both the input and output sides are handled.
>  */
>  void usb_enable_endpoint(struct usb_device *dev, struct usb_host_endpoint *ep,
> -               bool reset_toggle)
> +               bool reset_ep)
>  {
>        int epnum = usb_endpoint_num(&ep->desc);
>        int is_out = usb_endpoint_dir_out(&ep->desc);
>        int is_control = usb_endpoint_xfer_control(&ep->desc);
>
> -       if (is_out || is_control) {
> -               if (reset_toggle)
> -                       usb_settoggle(dev, epnum, 1, 0);
> +       if (reset_ep)
> +               usb_hcd_reset_endpoint(dev, ep);
> +       if (is_out || is_control)
>                dev->ep_out[epnum] = ep;
> -       }
> -       if (!is_out || is_control) {
> -               if (reset_toggle)
> -                       usb_settoggle(dev, epnum, 0, 0);
> +       if (!is_out || is_control)
>                dev->ep_in[epnum] = ep;
> -       }
>        ep->enabled = 1;
>  }
>
> @@ -1183,18 +1201,18 @@ void usb_enable_endpoint(struct usb_device *dev, struct usb_host_endpoint *ep,
>  * usb_enable_interface - Enable all the endpoints for an interface
>  * @dev: the device whose interface is being enabled
>  * @intf: pointer to the interface descriptor
> - * @reset_toggles: flag to set the endpoints' toggles back to 0
> + * @reset_eps: flag to reset the endpoints' state
>  *
>  * Enables all the endpoints for the interface's current altsetting.
>  */
>  void usb_enable_interface(struct usb_device *dev,
> -               struct usb_interface *intf, bool reset_toggles)
> +               struct usb_interface *intf, bool reset_eps)
>  {
>        struct usb_host_interface *alt = intf->cur_altsetting;
>        int i;
>
>        for (i = 0; i < alt->desc.bNumEndpoints; ++i)
> -               usb_enable_endpoint(dev, &alt->endpoint[i], reset_toggles);
> +               usb_enable_endpoint(dev, &alt->endpoint[i], reset_eps);
>  }
>
>  /**
> @@ -1335,7 +1353,7 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
>  * This issues a standard SET_CONFIGURATION request to the device using
>  * the current configuration.  The effect is to reset most USB-related
>  * state in the device, including interface altsettings (reset to zero),
> - * endpoint halts (cleared), and data toggle (only for bulk and interrupt
> + * endpoint halts (cleared), and endpoint state (only for bulk and interrupt
>  * endpoints).  Other usbcore state is unchanged, including bindings of
>  * usb device drivers to interfaces.
>  *
> @@ -1343,7 +1361,7 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
>  * (multi-interface) devices.  Instead, the driver for each interface may
>  * use usb_set_interface() on the interfaces it claims.  Be careful though;
>  * some devices don't support the SET_INTERFACE request, and others won't
> - * reset all the interface state (notably data toggles).  Resetting the whole
> + * reset all the interface state (notably endpoint state).  Resetting the whole
>  * configuration would affect other drivers' interfaces.
>  *
>  * The caller must own the device lock.
> @@ -1376,8 +1394,6 @@ int usb_reset_configuration(struct usb_device *dev)
>        if (retval < 0)
>                return retval;
>
> -       dev->toggle[0] = dev->toggle[1] = 0;
> -
>        /* re-init hc/hcd interface/endpoint state */
>        for (i = 0; i < config->desc.bNumInterfaces; i++) {
>                struct usb_interface *intf = config->interface[i];
> diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
> index dcfc072..7eee400 100644
> --- a/drivers/usb/core/usb.c
> +++ b/drivers/usb/core/usb.c
> @@ -362,7 +362,7 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
>        dev->ep0.desc.bLength = USB_DT_ENDPOINT_SIZE;
>        dev->ep0.desc.bDescriptorType = USB_DT_ENDPOINT;
>        /* ep0 maxpacket comes later, from device descriptor */
> -       usb_enable_endpoint(dev, &dev->ep0, true);
> +       usb_enable_endpoint(dev, &dev->ep0, false);
>        dev->can_submit = 1;
>
>        /* Save readable and stable topology id, distinguishing devices
> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
> index 49aedb3..fcb3202 100644
> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -247,10 +247,8 @@ int usb_stor_clear_halt(struct us_data *us, unsigned int pipe)
>                USB_ENDPOINT_HALT, endp,
>                NULL, 0, 3*HZ);
>
> -       /* reset the endpoint toggle */
>        if (result >= 0)
> -               usb_settoggle(us->pusb_dev, usb_pipeendpoint(pipe),
> -                               usb_pipeout(pipe), 0);
> +               usb_reset_endpoint(us->pusb_dev, endp);
>
>        US_DEBUGP("%s: result = %d\n", __func__, result);
>        return result;
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index c6b2ab4..3aa2cd1 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1387,6 +1387,7 @@ extern int usb_string(struct usb_device *dev, int index,
>  extern int usb_clear_halt(struct usb_device *dev, int pipe);
>  extern int usb_reset_configuration(struct usb_device *dev);
>  extern int usb_set_interface(struct usb_device *dev, int ifnum, int alternate);
> +extern void usb_reset_endpoint(struct usb_device *dev, unsigned int epaddr);
>
>  /* this request isn't really synchronous, but it belongs with the others */
>  extern int usb_driver_set_configuration(struct usb_device *udev, int config);
> @@ -1491,14 +1492,6 @@ void usb_sg_wait(struct usb_sg_request *io);
>  #define usb_pipecontrol(pipe)  (usb_pipetype((pipe)) == PIPE_CONTROL)
>  #define usb_pipebulk(pipe)     (usb_pipetype((pipe)) == PIPE_BULK)
>
> -/* The D0/D1 toggle bits ... USE WITH CAUTION (they're almost hcd-internal) */
> -#define usb_gettoggle(dev, ep, out) (((dev)->toggle[out] >> (ep)) & 1)
> -#define        usb_dotoggle(dev, ep, out)  ((dev)->toggle[out] ^= (1 << (ep)))
> -#define usb_settoggle(dev, ep, out, bit) \
> -               ((dev)->toggle[out] = ((dev)->toggle[out] & ~(1 << (ep))) | \
> -                ((bit) << (ep)))
> -
> -
>  static inline unsigned int __create_pipe(struct usb_device *dev,
>                unsigned int endpoint)
>  {
> --
> 1.5.4.3

-- 
Best regards, Klimov Alexey
