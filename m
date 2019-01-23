Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFF9C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 03:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 811A520855
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 03:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PONGGhHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfAWDqb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 22:46:31 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44835 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfAWDqa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 22:46:30 -0500
Received: by mail-oi1-f193.google.com with SMTP id m6so667631oig.11
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 19:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VUyGMJwdOju815lSxuJOfNwG0uhHxdTDAEqArdJ43r0=;
        b=PONGGhHdh3iak/+L5H/FFVwxBL1b2kLT+2K1ctHNEr22A6Y2IiBkk41HCkj8r4QkuA
         FlrEeOn+q50FfLBD/mxbb/ek31o/o6dwha0UNt0VSCOg7NJluCtocFiAHW/Qd6I9v4nJ
         3mD9fdQlQ7G7zePIosBRHfKv/SlM7tl1MFh7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VUyGMJwdOju815lSxuJOfNwG0uhHxdTDAEqArdJ43r0=;
        b=JbMrVQ1mtd1jRqUTNS/s/N8TOQ7zrF2WWUAXo9nlkMF3MN1zm0B3H1QTQibyrn9sii
         99ufcqvsv1mJ03k7H2bVNQ3Nh71JMJRJ3l4lxoSMdI682hfUlhzUbvvk02E8WgtDQImL
         ZIzNrE/epc7YwJXdTKbmVN3AGu8ikYQhZKtDVyTl2VmCZ1pmfcvDbwf+H3M0Jw86Rjct
         HGDxYpiGvTpLXqWJvbpIFpT1AKXy7f8jzdtQgiNJtl+e+h7ZtWFaKAiqiMFVTm1M0vxr
         G8n8EURT4mJN3k/oP4VpWT+2JTZF3LaeQ3FMc2WN/zNelj3V9jPO/cWNITjIpg5E+YLr
         gHYQ==
X-Gm-Message-State: AJcUukeue8cN5S1troKgqbypU3/KniJlhpFetRFs9Uiebj5D9JDKZ8/i
        N+G9rM+AHCBgxZHpSqDSo4yqTThivv4icQ==
X-Google-Smtp-Source: ALg8bN7VmUp2TvPNJnXDZLm/XSgo07CEl3C/AS6o7DnZQKfXSo6a7kSeepdxQPdT0ywBhaH8vSVFLQ==
X-Received: by 2002:aca:6c04:: with SMTP id h4mr402495oic.10.1548215189551;
        Tue, 22 Jan 2019 19:46:29 -0800 (PST)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id m3sm7587652ote.64.2019.01.22.19.46.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 19:46:28 -0800 (PST)
Received: by mail-ot1-f53.google.com with SMTP id j10so700389otn.11
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 19:46:28 -0800 (PST)
X-Received: by 2002:a05:6830:1193:: with SMTP id u19mr401533otq.152.1548215188193;
 Tue, 22 Jan 2019 19:46:28 -0800 (PST)
MIME-Version: 1.0
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
 <20190122112727.12662-4-hverkuil-cisco@xs4all.nl> <CAAFQd5DDGJnRMFq+f5o4YzOaRPPWUzWWr6woOeEa8+tBUz_1fQ@mail.gmail.com>
In-Reply-To: <CAAFQd5DDGJnRMFq+f5o4YzOaRPPWUzWWr6woOeEa8+tBUz_1fQ@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 12:46:17 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C4-nxgUb=ufhga9w+267EpeDzGobz2nVaLrcBwxc3DwQ@mail.gmail.com>
Message-ID: <CAAFQd5C4-nxgUb=ufhga9w+267EpeDzGobz2nVaLrcBwxc3DwQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Documentation/media: rename "Codec Interface"
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 23, 2019 at 12:17 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Hans,
>
> On Tue, Jan 22, 2019 at 8:27 PM <hverkuil-cisco@xs4all.nl> wrote:
> >
> > From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >
> > The "Codec Interface" chapter is poorly named since codecs are just one
> > use-case of the Memory-to-Memory Interface. Rename it and clean up the
> > text a bit.
> >
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  .../media/uapi/mediactl/request-api.rst       |  4 ++--
> >  .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 21 +++++++------------
> >  Documentation/media/uapi/v4l/devices.rst      |  2 +-
> >  .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
> >  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
> >  5 files changed, 13 insertions(+), 18 deletions(-)
> >  rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (79%)
> >
>
> Thanks for this cleanup! Indeed it makes much more sense with your
> changes. Some comments inline.
>
> > diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
> > index 4b25ad03f45a..1ad631e549fe 100644
> > --- a/Documentation/media/uapi/mediactl/request-api.rst
> > +++ b/Documentation/media/uapi/mediactl/request-api.rst
> > @@ -91,7 +91,7 @@ A request must contain at least one buffer, otherwise ``ENOENT`` is returned.
> >  A queued request cannot be modified anymore.
> >
> >  .. caution::
> > -   For :ref:`memory-to-memory devices <codec>` you can use requests only for
> > +   For :ref:`memory-to-memory devices <mem2mem>` you can use requests only for
> >     output buffers, not for capture buffers. Attempting to add a capture buffer
> >     to a request will result in an ``EACCES`` error.
> >
> > @@ -152,7 +152,7 @@ if it had just been allocated.
> >  Example for a Codec Device
> >  --------------------------
> >
> > -For use-cases such as :ref:`codecs <codec>`, the request API can be used
> > +For use-cases such as :ref:`codecs <mem2mem>`, the request API can be used
>
> I guess this should eventually be made to point to the codec sections.
> Alex, perhaps it would make sense to do it in your documentation
> patch.
>
> >  to associate specific controls to
> >  be applied by the driver for the OUTPUT buffer, allowing user-space
> >  to queue many such buffers in advance. It can also take advantage of requests'
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> > similarity index 79%
> > rename from Documentation/media/uapi/v4l/dev-codec.rst
> > rename to Documentation/media/uapi/v4l/dev-mem2mem.rst
> > index b5e017c17834..69efcc747588 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> > @@ -7,11 +7,11 @@
> >  ..
> >  .. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
> >
> > -.. _codec:
> > +.. _mem2mem:
> >
> > -***************
> > -Codec Interface
> > -***************
> > +********************************
> > +Video Memory To Memory Interface
> > +********************************
> >

Also to bikeshed a bit, the text seems to follow the
"memory-to-memory" convention, so perhaps "Video Memory-to-memory
Interface" would be more consistent?

Best regards,
Tomasz
