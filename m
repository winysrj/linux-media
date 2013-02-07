Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:63909 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3BGLBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:01:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [media] tm6000: add support for control events and prio handling
Date: Thu, 7 Feb 2013 12:01:29 +0100
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org
References: <20130207104454.GA466@elgon.mountain>
In-Reply-To: <20130207104454.GA466@elgon.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071201.29331.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 7 February 2013 11:44:54 Dan Carpenter wrote:
> Hello Hans Verkuil,
> 
> The patch 770056c47fbb: "[media] tm6000: add support for control
> events and prio handling" from Sep 11, 2012, leads to the following
> Smatch warning:
> "drivers/media/usb/tm6000/tm6000-video.c:1462 __tm6000_poll()
> 	 error: potentially dereferencing uninitialized 'buf'."
> 
> drivers/media/usb/tm6000/tm6000-video.c
>   1453          if (!is_res_read(fh->dev, fh)) {
>   1454                  /* streaming capture */
>   1455                  if (list_empty(&fh->vb_vidq.stream))
>   1456                          return res | POLLERR;
>   1457                  buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
>   1458          } else if (req_events & (POLLIN | POLLRDNORM)) {
>   1459                  /* read() capture */
>   1460                  return res | videobuf_poll_stream(file, &fh->vb_vidq, wait);
>   1461          }
> 
> If we don't hit either side of the if else statement then buf is
> uninitialized.

Oops! Thanks for catching this. I'll post a patch immediately.

Regards,

	Hans

> 
>   1462          poll_wait(file, &buf->vb.done, wait);
>   1463          if (buf->vb.state == VIDEOBUF_DONE ||
>   1464              buf->vb.state == VIDEOBUF_ERROR)
>   1465                  return res | POLLIN | POLLRDNORM;
>   1466          return res;
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
