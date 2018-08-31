Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33613 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbeHaT1C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:27:02 -0400
Received: by mail-yw1-f68.google.com with SMTP id x67-v6so5179430ywg.0
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 08:19:04 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id y188-v6sm3666944ywe.2.2018.08.31.08.19.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Aug 2018 08:19:02 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id w202-v6so5179705yww.3
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 08:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20180828134911.44086-1-hverkuil@xs4all.nl>
In-Reply-To: <20180828134911.44086-1-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 1 Sep 2018 00:18:49 +0900
Message-ID: <CAAFQd5BENL=0mOizPRBudSPGAsB752eh9gVkuAbrmR5GM+8RWA@mail.gmail.com>
Subject: Re: [PATCHv2 00/10] Post-v18: Request API updates
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 28, 2018 at 10:49 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Hi all,
>
> This patch series sits on top of my v18 series for the Request API.
> It makes some final (?) changes as discussed in:
>
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg134419.html
>
> and:
>
> https://www.spinics.net/lists/linux-media/msg138596.html
>
> The combined v18 patches + this series is available here:
>
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv18-1
>
> Updated v4l-utils for this is available here:
>
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request
>
> Userspace visible changes:
>
> - Invalid request_fd values now return -EINVAL instead of -ENOENT.
> - It is no longer possible to use VIDIOC_G_EXT_CTRLS for requests
>   that are not completed. -EACCES is returned in that case.
> - Attempting to use requests if requests are not supported by the driver
>   will result in -EACCES instead of -EPERM.
>
> Driver visible changes (important for the cedrus driver!):
>
> Drivers should set the new vb2_queue 'supports_request' bitfield to 1
> if a vb2_queue can support requests. Otherwise the queue cannot be
> used with requests.
>
> This bitfield is also used to fill in the new capabilities field
> in struct v4l2_requestbuffers and v4l2_create_buffers.
>
> Changes since v1:
>
> - Updated patch 4/10 to explain how to query the capabilities
>   with REQBUFS/CREATE_BUFS with a minimum of side-effects
>   (requested by Tomasz).
> - Added patches 6-10:
>   6: Sakari found a corner case: when accessing a request the
>      request has to be protected from being re-inited. New
>      media_request_(un)lock_for_access helpers are added for this.
>   7: use these helpers in g_ext_ctrls.
>   8: make s/try_ext_ctrls more robust by keeping the request
>      references until we're fully done setting/trying the controls.
>   9: Change two more EPERM's to EACCES. EPERM suggests that you can
>      fix it by changing permissions somehow, but in this case the
>      driver simply doesn't support requests at all.
>   10: Update the request documentation based on Laurent's comments:
>       https://www.spinics.net/lists/linux-media/msg139152.html
>       To do: split off the V4L2 specifics into a V4L2 specific
>       rst file. But this will take more time and is for later.

For all the patches which still don't have my Reviewed-by, except
patch 9/10 ("media-request: EPERM -> EACCES"):

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks a lot for this great work!

Best regards,
Tomasz
