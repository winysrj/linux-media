Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26262 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2GMLvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:51:31 -0400
Date: Fri, 13 Jul 2012 14:51:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: manjunatha_halli@ti.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] drivers:media:radio: wl128x: FM Driver Common sources
Message-ID: <20120713115121.GA27595@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Manjunatha Halli,

The patch e8454ff7b9a4: "[media] drivers:media:radio: wl128x: FM
Driver Common sources" from Jan 11, 2011, leads to the following
warning:
drivers/media/radio/wl128x/fmdrv_common.c:596 fm_irq_handle_flag_getcmd_resp()
	 error: untrusted 'fm_evt_hdr->dlen' is not capped properly

[ this is on my private Smatch stuff with too many false positives for
  general release ].

   584  static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
   585  {
   586          struct sk_buff *skb;
   587          struct fm_event_msg_hdr *fm_evt_hdr;
   588  
   589          if (check_cmdresp_status(fmdev, &skb))
   590                  return;
   591  
   592          fm_evt_hdr = (void *)skb->data;
   593  
   594          /* Skip header info and copy only response data */
   595          skb_pull(skb, sizeof(struct fm_event_msg_hdr));
   596          memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   597  
   598          fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
   599          fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
   600  
   601          /* Continue next function in interrupt handler table */
   602          fm_irq_call_stage(fmdev, FM_HW_MAL_FUNC_IDX);
   603  }

What are we copying here?  How do we know that ->dlen doesn't overflow
the buffer?  Why do we memcpy() and the overwrite part of the data on
the next line?

regards,
dan carpenter
