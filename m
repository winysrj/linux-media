Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:57096 "EHLO
        resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932255AbdC2WFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 18:05:09 -0400
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
To: Sean Young <sean@mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org> <58D80838.8050809@comcast.net>
 <20170326203130.GA6070@gofer.mess.org> <58D8CAD9.80304@comcast.net>
 <20170328202516.GA27790@gofer.mess.org> <58DB1075.60302@comcast.net>
 <20170329210645.GA6080@gofer.mess.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: A Sun <as1033x@comcast.net>
Message-ID: <58DC2F89.7000304@comcast.net>
Date: Wed, 29 Mar 2017 18:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170329210645.GA6080@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/29/2017 5:06 PM, Sean Young wrote:
<snip>
> 
> Anyway, you're right and this patch looks ok. It would be nice to have the
> tx case handled too though.
> 
> Thanks
> Sean
> 

Thanks; I'm looking at handling the tx case. If I can figure out the details, I'll post a new patch proposal separate, and likely dependent, on this one.

My main obstacle at the moment, is I'm looking for a way to get mceusb device to respond with a USB TX error halt/stall (rather than the typical ACK and NAK) on a TX endpoint, in order to test halt/stall error detection and recovery for TX. ..A Sun
