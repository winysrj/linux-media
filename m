Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:33967 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbcDROWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 10:22:08 -0400
Received: by mail-yw0-f171.google.com with SMTP id j74so25999241ywg.1
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2016 07:22:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460736595.973.5.camel@ndufresne.ca>
References: <570B9285.9000209@linaro.org>
	<570B9454.6020307@linaro.org>
	<1460391908.30296.12.camel@collabora.com>
	<570CB882.4090805@linaro.org>
	<CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
	<1460736595.973.5.camel@ndufresne.ca>
Date: Mon, 18 Apr 2016 10:22:07 -0400
Message-ID: <CAF6AEGt1R3KtVFfRg=1qNGjPUiOv4syZ_0C=SaFqLRXQpB_i_Q@mail.gmail.com>
Subject: Re: gstreamer: v4l2videodec plugin
From: Rob Clark <robdclark@gmail.com>
To: nicolas@ndufresne.ca
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 15, 2016 at 12:09 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> Le vendredi 15 avril 2016 à 11:58 -0400, Rob Clark a écrit :
>> The issue is probably the YUV format, which we cannot really deal
>> with
>> properly in gallium..  it's a similar issue to multi-planer even if
>> it
>> is in a single buffer.
>>
>> The best way to handle this would be to import the same dmabuf fd
>> twice, with appropriate offsets, to create one GL_RED eglimage for Y
>> and one GL_RG eglimage for UV, and then combine them in shader in a
>> similar way to how you'd handle separate Y and UV planes..
>
> That's the strategy we use in GStreamer, as very few GL stack support
> implicit color conversions. For that to work you need to implement the
> "offset" field in winsys_handle, that was added recently, and make sure
> you have R8 and RG88 support (usually this is just mapping).

oh, heh, looks like nobody bothered to add this yet:

---------
diff --git a/src/gallium/drivers/freedreno/freedreno_resource.c
b/src/gallium/drivers/freedreno/freedreno_resource.c
index 9aded3b..fab78ab 100644
--- a/src/gallium/drivers/freedreno/freedreno_resource.c
+++ b/src/gallium/drivers/freedreno/freedreno_resource.c
@@ -669,6 +669,7 @@ fd_resource_from_handle(struct pipe_screen *pscreen,
     rsc->base.vtbl = &fd_resource_vtbl;
     rsc->cpp = util_format_get_blocksize(tmpl->format);
     slice->pitch /= rsc->cpp;
+    slice->offset = handle->offset;

     assert(rsc->cpp);
---------


> cheers,
> Nicolas
