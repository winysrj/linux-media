Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:39014 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbeDQEed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:34:33 -0400
Received: by mail-it0-f67.google.com with SMTP id 85-v6so11878065iti.4
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:33 -0700 (PDT)
Received: from mail-it0-f50.google.com (mail-it0-f50.google.com. [209.85.214.50])
        by smtp.gmail.com with ESMTPSA id l71-v6sm4917494itc.34.2018.04.16.21.34.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:34:33 -0700 (PDT)
Received: by mail-it0-f50.google.com with SMTP id h143-v6so14250641ita.4
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-3-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-3-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:34:21 +0000
Message-ID: <CAPBb6MW_eu4z0UXTD2paqCBsoAZHE5ZnU046ScCGot5AwESCpQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 02/29] uapi/linux/media.h: add request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Define the public request API.

> This adds the new MEDIA_IOC_REQUEST_ALLOC ioctl to allocate a request
> and two ioctls that operate on a request in order to queue the
> contents of the request to the driver and to re-initialize the
> request.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Like it that the API stays simple, with request ioctls tied to request FDs.

Acked-by: Alexandre Courbot <acourbot@chromium.org>

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

>   #if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)

> --
> 2.16.3
