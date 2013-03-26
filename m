Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39483 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934095Ab3CZIar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:30:47 -0400
Received: by mail-bk0-f52.google.com with SMTP id it16so792080bkc.25
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 01:30:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303260918.36511.hverkuil@xs4all.nl>
References: <CAPgLHd-+DNxxVHsXiJpk2KFk8mzrQUkwaYPUFeWHyAmz-H6=4Q@mail.gmail.com>
	<20130326070415.GH9138@mwanda>
	<20130326073557.GI9138@mwanda>
	<201303260918.36511.hverkuil@xs4all.nl>
Date: Tue, 26 Mar 2013 16:30:45 +0800
Message-ID: <CAPgLHd-faL5S2ztdKfhKDHrmm5FMrk8hFOeWpt6xOvBiRsJ9=w@mail.gmail.com>
Subject: Re: [PATCH -next] [media] go7007: fix invalid use of sizeof in go7007_usb_i2c_master_xfer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hverkuil@xs4all.nl
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
	mchehab@redhat.com, gregkh@linuxfoundation.org,
	yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Dan Carpenter,

On 03/26/2013 04:18 PM, Hans Verkuil wrote:
> On Tue March 26 2013 08:35:57 Dan Carpenter wrote:
>> On Tue, Mar 26, 2013 at 10:04:15AM +0300, Dan Carpenter wrote:
>>> On Tue, Mar 26, 2013 at 02:42:47PM +0800, Wei Yongjun wrote:
>>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>>
>>>> sizeof() when applied to a pointer typed expression gives the
>>>> size of the pointer, not that of the pointed data.
>>>>
>>> This fix isn't right.  "buf" is a char pointer.  I don't know what
>>> this code is doing.  Instead of sizeof(*buf) it should be something
>>> like "buflen", "msg[i].len", "msg[i].len + 1" or "msg[i].len + 3".
>> It should be "msg[i].len + 1", I think.
> Yes, that's correct.
>
> 'buf' used to be a local array, so the memset was fine. I changed it to an
> array that was kmalloc()ed but forgot about the memset. I never noticed
> the bug because the sizeof the message is typically quite small, certainly
> smaller than sizeof(pointer) on a 64-bit system.
>
> Wei Yongjun, can you post a new patch fixing this?

Thanks very much, I will send the v2 of this patch soon.

Regards,
Yongjun





