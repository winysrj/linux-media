Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37786 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbZCXXNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:13:01 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "stoyboyker@gmail.com" <stoyboyker@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 24 Mar 2009 18:12:49 -0500
Subject: RE: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to
 unlocked
Message-ID: <A24693684029E5489D1D202277BE89442E804BDB@dlee02.ent.ti.com>
In-Reply-To: <1237930711-16200-1-git-send-email-stoyboyker@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stoyan,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of stoyboyker@gmail.com
> Sent: Tuesday, March 24, 2009 3:39 PM
> To: linux-kernel@vger.kernel.org
> Cc: Stoyan Gaydarov; linux-media@vger.kernel.org
> Subject: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to unlocked
> 
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  drivers/media/dvb/bt8xx/dst_ca.c |    7 +++++--
>  drivers/media/video/dabusb.c     |   11 ++++++++---
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/dvb/bt8xx/dst_ca.c
> b/drivers/media/dvb/bt8xx/dst_ca.c
> index 0258451..d3487c5 100644
> --- a/drivers/media/dvb/bt8xx/dst_ca.c
> +++ b/drivers/media/dvb/bt8xx/dst_ca.c
> @@ -552,8 +552,10 @@ free_mem_and_exit:
>  	return result;
>  }
> 
> -static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned
> int cmd, unsigned long ioctl_arg)
> +static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned
> long ioctl_arg)
>  {
> +	lock_kernel();
> +

Why moving to unlocked_ioctl if you're acquiring the Big Kernel Lock anyways?

