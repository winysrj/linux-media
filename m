Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:48020 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab3DJLmN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 07:42:13 -0400
Date: Wed, 10 Apr 2013 12:42:11 +0100
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] redrat3: remove memcpys and fix unaligned memory access
Message-ID: <20130410114211.GA21530@pequod.mess.org>
References: <20130409090259.GA1544@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409090259.GA1544@longonot.mountain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 09, 2013 at 12:02:59PM +0300, Dan Carpenter wrote:
> I had a question about 4c055a5ae94c: "[media] redrat3: remove memcpys
> and fix unaligned memory access" from Feb 16, 2013.
> 
> drivers/media/rc/redrat3.c
>    619          /* grab the Length and type of transfer */
>    620          pktlen = be16_to_cpu(header->length);
>    621          pkttype = be16_to_cpu(header->transfer_type);
>    622  
>    623          if (pktlen > sizeof(rr3->irdata)) {
>    624                  dev_warn(rr3->dev, "packet length %u too large\n", pktlen);
>    625                  return;
>    626          }
>    627  
>    628          switch (pkttype) {
>    629          case RR3_ERROR:
>    630                  if (len >= sizeof(struct redrat3_error)) {
>    631                          struct redrat3_error *error = rr3->bulk_in_buf;
>    632                          unsigned fw_error = be16_to_cpu(error->fw_error);
>    633                          redrat3_dump_fw_error(rr3, fw_error);
>    634                  }
>    635                  break;
>    636  
>    637          case RR3_MOD_SIGNAL_IN:
>    638                  memcpy(&rr3->irdata, rr3->bulk_in_buf, len);
>                                                                ^^^
>    639                  rr3->bytes_read = len;
>                                           ^^^
>    640                  rr3_dbg(rr3->dev, "bytes_read %d, pktlen %d\n",
>    641                          rr3->bytes_read, pktlen);
>                                                  ^^^^^^
> Should we be copying "pktlen" bytes on the line before?  It seems
> inconsistent that it doesn't match the debug code.

The pktlen is the length of the entire packet, and here we might have
received only part of it. This debug line would have been better if
it was:

	rr3_dbg(rr3->dev, "%s read of total %d\n", len, pktlen);

> My main concern is that we limit the size of "pktlen" but then we only
> use it for debug output.

pktlen is a copy of the length field of the packet. That gets memcpy'd
(line 638) into rr3->irdata where it is available as rr3->irdata.length. 
It is later used to check if we've received the full packet:

 689         if (rr3->bytes_read < be16_to_cpu(rr3->irdata.header.length))
 690                 /* we're still accumulating data */
 691                 return 0;

HTH and thanks for checking my changes.

Sean
