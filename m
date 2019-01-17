Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098D5C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 12:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD78620851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 12:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hokTKV3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfAQMrs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 07:47:48 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33968 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfAQMrs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 07:47:48 -0500
Received: by mail-io1-f67.google.com with SMTP id b16so7729734ior.1;
        Thu, 17 Jan 2019 04:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3fwbbwVsofMKhpSE5fgZb9rOkZsQ89dbXltbx9H7jo=;
        b=hokTKV3DkuY+UmoJLIaODm8H1uM2q2eHdB2UFA9XliRcOHACcuFQSHZdlEYQlPTtq6
         98+eWC348NCWG8WiLRXkNUPIVC5eGnvh5204//bX129BoryMPq085AaoSONGswxfekN0
         uZvO6k/OVCOcS5icPOjl8Vlpt3toNOkB/71o0ORYjCk5dWZ4pJgPhUHZWt+/Yr12pcOu
         5IvBPzZWALb7oMTu40SvC9qqe/Jcuyi9GB4/qry20ywcsDUXNjoloujbyenIVcAoJS7P
         X7LaUBLnRnUJxeIcIKrqVtLwsfcjZdxRB3EXVML/NRqjjC+MmhAH7lxJc6NHB07y+RZL
         awIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3fwbbwVsofMKhpSE5fgZb9rOkZsQ89dbXltbx9H7jo=;
        b=tpXUun1qKJWWAQHJWZ5sJQPOrOzf8hAUTDyODxVTMqlaZCGGz/MiQxwSig2f0WEidK
         CXtX9Yo8r7VmGO4BvvC4SKDBzBBAzS2hXC3TQYGdGw3cCZHZQd0grXMMiUv6NnwD8fen
         E1RXtAzWZbfvF0gPkhhcqAnVw9LByKQrzX8JnpVOJqJcQPMCCvwrzXtrrmavYu0SHmat
         GHtW1VD3K+SEGekceasz4WJlYik7Ios37mGikCFFF/aWRUe1zSxfaUaoHzvQPsIXVNOm
         aT2w9/Bv0xbDRCeTHfv0nQGbWb30in9hKIdBSUYMQcDTElrs2m9vM9JNbdutYnW58K9H
         NORw==
X-Gm-Message-State: AJcUukerrQ98AoyPEe7CJzp9AxTt8CxvYtUbXl7C9HgembKfyHiIHTmZ
        HJzVk380cjTRFdqa0mfedIfTI/yDx3Vln1CSCZQ=
X-Google-Smtp-Source: ALg8bN4BHnqWtoWTeCAAQunkiLirqvZhbHCN5R2etw5yo6gZ38XcxEvjraow8SbmCnMb0dvr0LCSiHwsxvFoTImPs/Q=
X-Received: by 2002:a6b:f814:: with SMTP id o20mr7437690ioh.129.1547729266696;
 Thu, 17 Jan 2019 04:47:46 -0800 (PST)
MIME-Version: 1.0
References: <20180619082445.11062-1-thellstrom@vmware.com> <20180619082445.11062-3-thellstrom@vmware.com>
 <CAF6AEGubXRVL-PA7TUvW-oF3tTL=oaQ4F+AD_AiX=wUjxCov1g@mail.gmail.com> <9c07b391c16db8b0c788afd4692cc8191baff1aa.camel@vmware.com>
In-Reply-To: <9c07b391c16db8b0c788afd4692cc8191baff1aa.camel@vmware.com>
From:   Rob Clark <robdclark@gmail.com>
Date:   Thu, 17 Jan 2019 07:47:34 -0500
Message-ID: <CAF6AEGvLOKOScQFMHVAFweGDnbR1E3ORqzH6mymJ60rTXkZEfw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] locking: Implement an algorithm choice for
 Wound-Wait mutexes
To:     Thomas Hellstrom <thellstrom@vmware.com>
Cc:     "corbet@lwn.net" <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dave@stgolabs.net" <dave@stgolabs.net>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "seanpaul@chromium.org" <seanpaul@chromium.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "maarten.lankhorst@linux.intel.com" 
        <maarten.lankhorst@linux.intel.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 11:49 AM Thomas Hellstrom <thellstrom@vmware.com> wrote:
>
> Hi,
>
> On Wed, 2019-01-16 at 09:24 -0500, Rob Clark wrote:
> > So, I guess this is to do w/ the magic of merge commits, but it looks
> > like the hunk changing the crtc_ww_class got lost:
>
> So what happened here is that this commit changed it to
> DEFINE_WD_CLASS
> and the following commit changed it back again to
> DEFINE_WW_CLASS
> so that the algorithm change and only that came with the last commit.
> Apparently the history of that line got lost when merging since the
> merge didn't change it; git blame doesn't show it changed, but when
> looking at the commit history in gitk it's all clear. I guess that's a
> feature of git.
>
> The modeset locks now use true wound-wait rather than wait-die.

ahh, ok, that makes sense.  Thanks for clearing up my confusion.

BR,
-R
