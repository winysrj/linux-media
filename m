Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab1KOUSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 15:18:16 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so7564371bke.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 12:18:16 -0800 (PST)
Message-ID: <4EC2C904.2010308@gmail.com>
Date: Tue, 15 Nov 2011 21:18:12 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/3] V4L2: Add per-device-node capabilities
References: <1320662246-8531-1-git-send-email-hverkuil@xs4all.nl> <43f3b62f1a17a91a02b5a66026b8af02ad31fa2f.1320661643.git.hans.verkuil@cisco.com>
In-Reply-To: <43f3b62f1a17a91a02b5a66026b8af02ad31fa2f.1320661643.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 11/07/2011 11:37 AM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
> 
> If V4L2_CAP_DEVICE_CAPS is set, then the new device_caps field is filled with
> the capabilities of the opened device node.
> 
> The capabilities field traditionally contains the capabilities of the whole
> device. E.g., if you open video0, then if it contains VBI caps then that means
> that there is a corresponding vbi node as well. And the capabilities field of
> both the video and vbi node should contain identical caps.
> 
> However, it would be very useful to also have a capabilities field that contains
> just the caps for the currently open device, hence the new CAP bit and field.
> 
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> ---
>   include/linux/videodev2.h |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..2b6338b 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -243,8 +243,9 @@ struct v4l2_capability {
>   	__u8	card[32];	/* i.e. "Hauppauge WinTV" */
>   	__u8	bus_info[32];	/* "PCI:" + pci_name(pci_dev) */
>   	__u32   version;        /* should use KERNEL_VERSION() */
> -	__u32	capabilities;	/* Device capabilities */
> -	__u32	reserved[4];
> +	__u32	capabilities;	/* Global device capabilities */
> +	__u32	device_caps;	/* Device node capabilities */

How about changing this to

	__u32	devnode_caps;	/* Device node capabilities */

> +	__u32	reserved[3];
>   };
> 
>   /* Values for 'capabilities' field */
> @@ -274,6 +275,8 @@ struct v4l2_capability {
>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> 
> +#define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */

..and

#define V4L2_CAP_DEVNODE_CAPS            0x80000000  /* sets device node capabilities field */

?

'device' might suggest a whole physical device/system at first sight.
Maybe devnode_caps is not be the best name but it seems more explicit and
less confusing :) 

It's just my personal opinion though.

--
Regards,
Sylwester
