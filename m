Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:15858 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZCXVb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:31:56 -0400
MIME-Version: 1.0
In-Reply-To: <20090324212445.224fd377@lxorguk.ukuu.org.uk>
References: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
	 <20090324212445.224fd377@lxorguk.ukuu.org.uk>
Date: Tue, 24 Mar 2009 16:31:54 -0500
Message-ID: <6d291e080903241431m3816e0a0sb55070e1d992054d@mail.gmail.com>
Subject: Re: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2009 at 4:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
>> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
>>  {
>> +     lock_kernel();
>>       pdabusb_t s = (pdabusb_t) file->private_data;
>
> After the variables or you'll get lots of warnings from gcc
>
>

Unfortunately I am not familiar with this driver and as such i was not
sure if the variable required the lock to be accessed or not so as to
play it safe i put it before the variable. But i can resubmit this
patch if there are no problems.

-- 

-Stoyan
