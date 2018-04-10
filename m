Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:46578 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeDJF0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 01:26:40 -0400
Received: by mail-vk0-f65.google.com with SMTP id v205so6249061vkv.13
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 22:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-3-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-3-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Tue, 10 Apr 2018 05:26:28 +0000
Message-ID: <CAAFQd5AivHNx4z4WGMBUzVvnwO=FBqnTPyM1xaaciu2S-vYzPw@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Define the public request API.

> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> and two ioctls that operate on a request in order to queue the
> contents of the request to the driver and to re-initialize the
> request.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   include/uapi/linux/media.h | 8 ++++++++
>   1 file changed, 8 insertions(+)

> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c7e9a5cba24e..f8769e74f847 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -342,11 +342,19 @@ struct media_v2_topology {

>   /* ioctls */

> +struct __attribute__ ((packed)) media_request_alloc {
> +       __s32 fd;
> +};
> +
>   #define MEDIA_IOC_DEVICE_INFO  _IOWR('|', 0x00, struct media_device_info)
>   #define MEDIA_IOC_ENUM_ENTITIES        _IOWR('|', 0x01, struct
media_entity_desc)
>   #define MEDIA_IOC_ENUM_LINKS   _IOWR('|', 0x02, struct media_links_enum)
>   #define MEDIA_IOC_SETUP_LINK   _IOWR('|', 0x03, struct media_link_desc)
>   #define MEDIA_IOC_G_TOPOLOGY   _IOWR('|', 0x04, struct media_v2_topology)
> +#define MEDIA_IOC_REQUEST_ALLOC        _IOWR('|', 0x05, struct
media_request_alloc)
> +
> +#define MEDIA_REQUEST_IOC_QUEUE                _IO('|',  0x80)
> +#define MEDIA_REQUEST_IOC_REINIT       _IO('|',  0x81)

I wonder if it wouldn't make sense to add a comment here saying that these
are called on request FD, as opposed to the others above, which are called
on the media FD.

Best regards,
Tomasz
