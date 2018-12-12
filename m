Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B914BC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 15:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA0D20870
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 15:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTSqbC6d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EA0D20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbeLLPPT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 10:15:19 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38196 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeLLPPS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 10:15:18 -0500
Received: by mail-ot1-f66.google.com with SMTP id e12so17922822otl.5;
        Wed, 12 Dec 2018 07:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jt4OPLC3HMDSuL2FQ7hksnCbfZMLUf1/RFOr3LQh2eo=;
        b=qTSqbC6dcFl+iwxCpQ+kXl0eX8ZbbGW9vxXTPhbhI8wM+k7j2fV4K7E4pbus0GFBQa
         +0DHqWcckI22bnHjfjCB6kNZm23cKNESIQj6du5/SZctqnyZQWxF9hx/8EXIPAh0XtUR
         B9EQkIYh21+R7SJFikNJa+Adn9Hc4FUMi/m+xeaCCIQooI3hjP7XN3gm+WsRtQOrlcq6
         0cMUmme8rWXNi/7mnuoQVu2mwOcqcKZPAp9MVd935ql5ujasVzxo1hBMMzvx7n+UVGvc
         SeSS0fyngjy3Bsj2xYs+2P1pe+4fSXpTwDruLJzYs4KkK515AZT/hMQFZOUrLdYzT1MM
         XetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jt4OPLC3HMDSuL2FQ7hksnCbfZMLUf1/RFOr3LQh2eo=;
        b=CYoR5Z4RKTAHIuYIODRXhrsP8OS5RebvV+e29QGdfghx9heEjQcTNo8RE6gvCHQLjs
         EQEBNWYGYAwPgs8lWEa42CptYhjDoziHxzq0+Qm8jaTd6Md8FSjYHehVXuy27O7KrYJp
         DWan2zL3KF7zGh0DBJkJbGfea+HWuBZQcHJZMU31xY4NRS1ClNBooPq9mlhkVI6cJnzY
         422fSxcILUkTo1bEqw5QDaADlTrc2CTNFGPAHWEbL2H6Ra3YpmJIFGAxQflsMTnYC6w3
         1VVNGV6SRC99GOUjLN/zAO1V0kG4RdCs3Bv1LZoXaH7wb6soMQe7gF0zLu4rMDH3iDRp
         trLA==
X-Gm-Message-State: AA+aEWb+dl0ejBO9TnZGK1wiCynofRo+qIX9oUFEl49DE9c3ryFj2KVs
        mVwNEEt3XygrqF9+bUkFicEe2v5DDGs17JrhNCM=
X-Google-Smtp-Source: AFSGD/Vkho3+iyNX0CprvX8I+6BN0PXDfiefeh/grDyYuxiX1eTaIzPDavtrJ+/cUeiCvN5Gcf+qxg2TX1k6TwbteiE=
X-Received: by 2002:a9d:77d4:: with SMTP id w20mr14053318otl.196.1544627717831;
 Wed, 12 Dec 2018 07:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20181109190327.23606-1-matwey@sai.msu.ru> <20181109190327.23606-3-matwey@sai.msu.ru>
 <CAJs94Eb6Ev5O+Q_THYruxozSW2sTjWCrHhU8wciFNgYx7oCRuQ@mail.gmail.com>
 <CAJs94EYmRpUSnxzyt-8bdSwp3WgvOuqpt4b55wKQ41jDynFceg@mail.gmail.com>
 <CAJs94EbrOqdn5=xEnyQEC6aqYh=Wojh3-wGxT325f5Q7wnc36w@mail.gmail.com>
 <20181212085622.6b590540@gandalf.local.home> <20181212090123.046ced92@gandalf.local.home>
In-Reply-To: <20181212090123.046ced92@gandalf.local.home>
From:   "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date:   Wed, 12 Dec 2018 18:15:06 +0300
Message-ID: <CAJs94EZmzdSBc9xdGmDnga6a9AKERqQprFGwO1tDcvz3q8sLow@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

=D1=81=D1=80, 12 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 17:01, Steven Rost=
edt <rostedt@goodmis.org>:
>
> On Wed, 12 Dec 2018 08:56:22 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > Can someone please take this patch or at least say what's wrong with it
> > if you have a problem?
> >
> > Matwey has been patiently pinging us once every other week for over a
> > month asking for a reply. I've already given my Reviewed-by from a
> > tracing perspective.
> >
> > Ignoring patches is not a friendly gesture.
> >
>
> Nevermind, it appears that v5 is still under discussion.
>
> Matwey, does v6 address the comments made in v5?

Hi,

v6 addresses the comments made by Laurent Pinchart on Oct, 31:

https://www.spinics.net/lists/linux-media/msg142216.html

namely, dma_sync_single_for_device() is introduced in the proper place



>
> -- Steve



--=20
With best regards,
Matwey V. Kornilov
