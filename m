Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3095 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3CZITM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:19:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH -next] [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
Date: Tue, 26 Mar 2013 09:18:36 +0100
Cc: Wei Yongjun <weiyj.lk@gmail.com>, devel@driverdev.osuosl.org,
	mchehab@redhat.com, gregkh@linuxfoundation.org,
	yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org
References: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com> <20130326070415.GH9138@mwanda> <20130326073557.GI9138@mwanda>
In-Reply-To: <20130326073557.GI9138@mwanda>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260918.36511.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 26 2013 08:35:57 Dan Carpenter wrote:
> On Tue, Mar 26, 2013 at 10:04:15AM +0300, Dan Carpenter wrote:
> > On Tue, Mar 26, 2013 at 02:42:47PM +0800, Wei Yongjun wrote:
> > > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > 
> > > sizeof() when applied to a pointer typed expression gives the
> > > size of the pointer, not that of the pointed data.
> > >
> > 
> > This fix isn't right.  "buf" is a char pointer.  I don't know what
> > this code is doing.  Instead of sizeof(*buf) it should be something
> > like "buflen", "msg[i].len", "msg[i].len + 1" or "msg[i].len + 3".
> 
> It should be "msg[i].len + 1", I think.

Yes, that's correct.

'buf' used to be a local array, so the memset was fine. I changed it to an
array that was kmalloc()ed but forgot about the memset. I never noticed
the bug because the sizeof the message is typically quite small, certainly
smaller than sizeof(pointer) on a 64-bit system.

Wei Yongjun, can you post a new patch fixing this?

Thanks,

	Hans

> 
> On the line before it writes buflen bytes to the hardware.  Then
> it clears the transfer buffer and reads "msg[i].len + 1" bytes from
> the hardware.  Then it saves the memory, except for the first byte,
> in msg[i].buf.
> 
> So it should clear "msg[i].len + 1" bytes so that the old data isn't
> confused with the data that we read from the hardware.
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
