Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59998 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374AbZCXVXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:23:47 -0400
Date: Tue, 24 Mar 2009 21:24:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org,
	Stoyan Gaydarov <stoyboyker@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
Message-ID: <20090324212445.224fd377@lxorguk.ukuu.org.uk>
In-Reply-To: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	lock_kernel();
>  	pdabusb_t s = (pdabusb_t) file->private_data;

After the variables or you'll get lots of warnings from gcc

