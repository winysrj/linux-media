Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48700 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2GMUgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 16:36:19 -0400
Date: Fri, 13 Jul 2012 23:36:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: halli manjunatha <hallimanju@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] drivers:media:radio: wl128x: FM Driver Common sources
Message-ID: <20120713203605.GR6113@mwanda>
References: <20120713115121.GA27595@elgon.mountain>
 <CAMT6PyccqZ=KJ4+EuPXXaCHZ+YK3+MHWmPVbZEuTOD_e1WTBKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMT6PyccqZ=KJ4+EuPXXaCHZ+YK3+MHWmPVbZEuTOD_e1WTBKA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 13, 2012 at 01:17:11PM -0500, halli manjunatha wrote:
> On Fri, Jul 13, 2012 at 6:51 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > Hello Manjunatha Halli,
> >
> > The patch e8454ff7b9a4: "[media] drivers:media:radio: wl128x: FM
> > Driver Common sources" from Jan 11, 2011, leads to the following
> > warning:
> > drivers/media/radio/wl128x/fmdrv_common.c:596
> > fm_irq_handle_flag_getcmd_resp()
> >          error: untrusted 'fm_evt_hdr->dlen' is not capped properly
> >
> > [ this is on my private Smatch stuff with too many false positives for
> >   general release ].
> >
> >    584  static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
> >    585  {
> >    586          struct sk_buff *skb;
> >    587          struct fm_event_msg_hdr *fm_evt_hdr;
> >    588
> >    589          if (check_cmdresp_status(fmdev, &skb))
> >    590                  return;
> >    591
> >    592          fm_evt_hdr = (void *)skb->data;
> >    593
> >    594          /* Skip header info and copy only response data */
> >    595          skb_pull(skb, sizeof(struct fm_event_msg_hdr));
> >    596          memcpy(&fmdev->irq_info.flag, skb->data,
> > fm_evt_hdr->dlen);
> >                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> >    597
> >    598          fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
> >    599          fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
> >    600
> >    601          /* Continue next function in interrupt handler table */
> >    602          fm_irq_call_stage(fmdev, FM_HW_MAL_FUNC_IDX);
> >    603  }
> >
> > What are we copying here?  How do we know that ->dlen doesn't overflow
> > the buffer?  Why do we memcpy() and the overwrite part of the data on
> > the next line?
> 
> Here I am trying to get the current value of the flag register which
> is of maximum 16bit wide.
> 
> So ->dlen value never overflow the buffer.
> 
> In memcopy() case I am just trying to avoid 1 more variable so first I
> memcopy the skb->data to  ->irq_info.flag then I will correct the
> endianness of
> 
> ->irq_info.flag in next line.
> 

I am sorry but your email makes no sense at all.  This is a remote
security hole because ->dlen is a u8 that is chosen from over the
network.  The memcpy would let us copy over some function pointers
in fmdev->irq_info->timer and use that to become root.

->dlen is not checked anywhere.

You say it copies 16 bits of data (in other words ->dlen is a
maximum of 2 (2 bytes).  fmdev->irq_info.flag is 16 bits.  In other
words the memcpy() can be removed.

Then you contradict yourself and say it copies other unspecified
data as well.

Can someone else take a look?

regards,
dan carpenter
