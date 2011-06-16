Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53092 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935Ab1FPJWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 05:22:15 -0400
References: <20110616013957.GA9809@xanatos>
In-Reply-To: <20110616013957.GA9809@xanatos>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: uvcvideo failure under xHCI
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 16 Jun 2011 05:22:19 -0400
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Andiry Xu <andiry.xu@amd.com>
Message-ID: <32b20f69-8be0-408b-a2f9-bf262af2b457@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:

>Hi Laurent,
>
>I think this issue has been happening for a while now, but my recent
>patches to remove most of the xHCI debugging


have finally allowed me to
>use a webcam under xHCI with debugging on.  Unfortunately, it doesn't
>work very well.
>
>When I plug in a webcam under an xHCI host controller in 3.0-rc3+
>(basically top of Greg's usb-linus branch) with xHCI debugging turned
>on, the host controller occasionally cannot keep up with the
>isochronous
>transfers, and it tells the xHCI driver that it had to "skip" several
>microframes of transfers.  These "Missed Service Intervals" aren't
>supposed to be fatal errors, just an indication that something was
>hogging the PCI memory bandwidth.
>
>The xHCI driver then sets the URB's status to -EXDEV, to indicate that
>some of the iso_frame_desc transferred, and sets at least one frame's
>status to -EXDEV:
>
>static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
>                        struct xhci_transfer_event *event,
>                        struct xhci_virt_ep *ep, int *status)
>{
>        struct xhci_ring *ep_ring;
>        struct urb_priv *urb_priv;
>        struct usb_iso_packet_descriptor *frame;
>        int idx;
>
>   ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
>        urb_priv = td->urb->hcpriv;
>        idx = urb_priv->td_cnt; 
>        frame = &td->urb->iso_frame_desc[idx];
>        
>        /* The transfer is partly done */
>        *status = -EXDEV;
>        frame->status = -EXDEV;
>        
>        /* calc actual length */
>        frame->actual_length = 0;
>        
>        /* Update ring dequeue pointer */
>        while (ep_ring->dequeue != td->last_trb)
>                inc_deq(xhci, ep_ring, false);
>        inc_deq(xhci, ep_ring, false);
>        
>        return finish_td(xhci, td, NULL, event, ep, status, true);
>}
>
>The urb->status causes uvcvideo code in
>uvc_status.c:uvc_status_complete() to
>fail with the message:
>
>Jun 15 17:37:11 talon kernel: [  117.987769] uvcvideo: Non-zero status
>(-18) in video completion handler.
>
>It doesn't resubmit the isochronous URB in that case, and the userspace
>video freezes.  If I restart the application, the video comes back
>until
>the next Missed Service Interval event from the xHCI driver.  Ideally,
>the video driver would just resubmit the URB, and the xHCI host
>controller would complete transfers as best it can.  I think the frames
>with -EXDEV status should be treated like short transfers.
>
>I've grepped through drivers/media/video, and it seems like none of the
>drivers handle the -EXDEV status.  What should the xHCI driver be
>setting the URB's status and frame status to when the xHCI host
>controller skips over transfers?  -EREMOTEIO?
>
>Or does it need to set the URB's status to zero, but only set the
>individual frame status to -EXDEV?
>
>Sarah Sharp
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Video drivers don't handle EXDEV probably because it is an error code about filesystem links:

http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_03.html#tag_02_03


Regards,
Andy
