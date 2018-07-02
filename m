Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34334 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753229AbeGBK4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 06:56:36 -0400
Received: by mail-yw0-f172.google.com with SMTP id j68-v6so2831066ywg.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 03:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-3-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-3-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Mon, 2 Jul 2018 19:56:24 +0900
Message-ID: <CAAFQd5BMjCJGdDRgF6rvRyi7FNVtvJA5sSqAsgYju1RcgkUPcA@mail.gmail.com>
Subject: Re: [PATCHv15 02/35] media-request: implement media requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 4, 2018 at 8:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
[snip]
> +static void media_request_object_release(struct kref *kref)
> +{
> +       struct media_request_object *obj =
> +               container_of(kref, struct media_request_object, kref);
> +       struct media_request *req = obj->req;
> +
> +       if (req)
> +               media_request_object_unbind(obj);

Is it possible and fine to have a request bound here?
media_request_clean() seems to explicitly unbind before releasing and
this function would be only called if last reference is put, so maybe
we should actually WARN_ON(req)?

> +       obj->ops->release(obj);
> +}
[snip]
> @@ -87,7 +104,12 @@ struct media_device_ops {
>   * @enable_source: Enable Source Handler function pointer
>   * @disable_source: Disable Source Handler function pointer
>   *
> + * @req_queue_mutex: Serialise validating and queueing requests in order to
> + *                  guarantee exclusive access to the state of the device on
> + *                  the tip of the request queue.
>   * @ops:       Operation handler callbacks
> + * @req_queue_mutex: Serialise the MEDIA_REQUEST_IOC_QUEUE ioctl w.r.t.
> + *                  other operations that stop or start streaming.

Merge conflict? req_queue_mutex is documented twice.

Best regards,
Tomasz
