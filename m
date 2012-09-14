Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64779 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab2INRe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 13:34:59 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so1362498bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:34:59 -0700 (PDT)
Message-ID: <50536AC0.8070003@gmail.com>
Date: Fri, 14 Sep 2012 19:34:56 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv3 API PATCH 31/31] Add vfl_dir field documentation.
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com> <77a2489dac81a471ef53aeffa172b11f676ae3c7.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <77a2489dac81a471ef53aeffa172b11f676ae3c7.1347619766.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2012 12:57 PM, Hans Verkuil wrote:
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   Documentation/video4linux/v4l2-framework.txt |    9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 89318be..20f1c05 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -583,11 +583,18 @@ You should also set these fields:
>
>   - name: set to something descriptive and unique.
>
> +- vfl_dir: set to VFL_DIR_TX for output devices and VFL_DIR_M2M for mem2mem
> +  (codec) devices.
> +

No need to document VFL_DIR_RX ?

>   - fops: set to the v4l2_file_operations struct.
>
>   - ioctl_ops: if you use the v4l2_ioctl_ops to simplify ioctl maintenance
>     (highly recommended to use this and it might become compulsory in the
> -  future!), then set this to your v4l2_ioctl_ops struct.
> +  future!), then set this to your v4l2_ioctl_ops struct. The vfl_type and
> +  vfl_dir fields are used to disable ops that do not match the type/dir
> +  combination. E.g. VBI ops are disabled for non-VBI nodes, and output ops
> +  are disabled for a capture device. This makes it possible to provide
> +  just one v4l2_ioctl_ops struct for both vbi and video nodes.
>
>   - lock: leave to NULL if you want to do all the locking in the driver.
>     Otherwise you give it a pointer to a struct mutex_lock and before the

--

Regards,
Sylwester
