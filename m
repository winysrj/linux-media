Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:56056 "EHLO
        resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbdCZQhr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 12:37:47 -0400
Subject: Re: [PATCH 0/3] [media] mceusb: RX -EPIPE lockup fault and more
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58D7EDFA.3090903@comcast.net>
Date: Sun, 26 Mar 2017 12:36:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170326102748.GA1672@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/26/2017 6:27 AM, Sean Young wrote:
...

>> +		status = usb_submit_urb(ir->urb_in, GFP_ATOMIC);
> 
> This can be GFP_KERNEL.
> 
...

>> +	rc_free_device(ir->rc);
> 
> That change is wrong and will cause a double free.
> 
>>  	usb_kill_urb(ir->urb_in);
>>  	usb_free_urb(ir->urb_in);
>>  	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);
> 
> Would you be able to split this into multiple commits please?
> 
> Thanks,
> Sean
> 

Hi Sean,

Thank you for the quick reply, review, corrections, and suggestions. Please bear with me since this is my first contribution for Linux. The patch production submission/review process is entirely new to me at this time.

I'll perform the corrections in the forthcoming replies containing the split patches:
    [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup failure fix
    [PATCH 2/3] [media] mceusb: sporadic RX truncation corruption fix
    [PATCH 3/3] [media] mceusb: fix inaccurate debug buffer dumps and misleading debug messages

Thanks again. ..A Sun
