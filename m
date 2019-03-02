Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCC6C43381
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 00:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 722FB2083E
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 00:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="DXAPKXKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfCBA6Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 19:58:24 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36293 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCBA6X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 19:58:23 -0500
Received: by mail-qt1-f195.google.com with SMTP id p25so30038563qtb.3
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2019 16:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=LvCny/GDFFdzo486Pbeic4NcFjL9suZt6f9wY9a4FQQ=;
        b=DXAPKXKlQbEa0dGqTN76xsOxg/G+g1FXPSvISxinmN39aB+sybKve35J9fyDTg2ao7
         N4CpQClvxGNoC5NkHHqv0tE+sSnuU/FLOTKyJaexaRNjWp0FhwF7910fcA8It96RdFFk
         cn+oxbDN8ewbKnrd61EQUhSzS/UCwvsCxcOP4cA1crZaeh7nCFcRYi8j++P2wrg4tz0o
         LVNfyA3KSo+x+jAbPZSPSvLCfaCDXjwUzYkgEedVs3bDjMpr2QVmDSDfNqFtqU4PsvTs
         HYbeTIpt3QIOffm2/qLnqZsjPLUQ3cguRlJF0BmS8nqjgWXRAJi5hYY8AgtKuGo75kwo
         6/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LvCny/GDFFdzo486Pbeic4NcFjL9suZt6f9wY9a4FQQ=;
        b=ndL+qvtJ6Qvhbi+q+Ftu8hL2FDgmwQ/AbvfTDR8ndJa07jKhEB3I9b/P8URCAY8Es2
         a7FIrtq1LjT+anahkfd1XMUxpLxpPkZ1uZu8zKG5r0hwbO1FCSVr8QUDqpGeiuwAzs9I
         d+J/Nk2DSf6wm807KVoj17aywiaHlRvSs4oIWyrVHIyhsDa4O2wpSQ04y/erGkPWaJ1H
         ETS8FXy6nZVDlH/Lvwd7uebtxQKaBdq5aYdS1jHHM8VUbyNvH6jy6r4ZLO07UACURYhp
         6tx9pJfBjEb9Rc8kJ+uWbuoa4y8hqCT4doADOs1UaMyedext4GzPFsPKksHTomqMwrrC
         F5TA==
X-Gm-Message-State: APjAAAU102/FO6zlHdxLUa7Fhpon+pOPcPXgloiO+rHoFbrQcmqsHyf6
        Qh7VRVCVEomfknmunNyUTBhKCK4eQXM=
X-Google-Smtp-Source: APXvYqxJf0y7aoa9lJMZjVXBRw3bxiBdj8ry4VdZVNlb6a1df8pSnS5du75XBSE5e8XYFeNz2ODC4A==
X-Received: by 2002:a0c:d2a5:: with SMTP id q34mr6200272qvh.102.1551488302442;
        Fri, 01 Mar 2019 16:58:22 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id l129sm13615895qkb.44.2019.03.01.16.58.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 16:58:21 -0800 (PST)
Message-ID: <db785f414b3baa570aa798d84d46ba9f1d5ea93b.camel@ndufresne.ca>
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Date:   Fri, 01 Mar 2019 19:58:20 -0500
In-Reply-To: <01f029cc-1e2b-524c-5db8-4cd87c18b669@xs4all.nl>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
         <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
         <20190228110914.0b2613eb@coco.lan>
         <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
         <20190228122139.6ac6c25d@coco.lan>
         <170efbf2-794a-7314-179d-d5c4af4d7e57@xs4all.nl>
         <20190228143124.3953adff@coco.lan>
         <01f029cc-1e2b-524c-5db8-4cd87c18b669@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le vendredi 01 mars 2019 à 11:19 +0100, Hans Verkuil a écrit :
> > $ gst-launch-1.0 videotestsrc num-buffers=120 ! video/x-raw,format=RGB,width=322,height=200 ! v4l2video0convert disable-passthrough=1 ! video/x-raw,width=428,height=400 ! videoconvert ! xvimagesink
> 
> But you explicitly set different resolutions for source and sink.
> What happens in gstreamer if the driver doesn't support scaling? Will
> gstreamer continue with wrong values? Give an error?

It will post an error or type NOT_NEGOTIATED after failing to set the
OUTPUT or CAPTURE format. It does assume your converter driver do
scaling though, the caps negotiation is written in a way that it will
first try to avoid it. So if it's unavoidable, and your driver does not
support scaling, it's also unavoidable that negotiation will fail.

In the case of this test pipeline, you cannot test scaling without
forcing the width/height on both side of it. Because videotestsrc can
produce frames at any raw video format mapped into GStreamer. Then
xvimagesink does scaling, so it would accept any given videotestsrc
resolution without the need for scaling.

Nicolas

