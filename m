Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5A5C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 17:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7322087C
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 17:15:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="JQxo9Blq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCQRPB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:15:01 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:46286 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfCQRPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 13:15:01 -0400
Received: by mail-qk1-f180.google.com with SMTP id i5so8315137qkd.13
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2019 10:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=dabFVq2vIfkiMJi0PCbmOTxkxSS04V2Qjkp35jIZ0hY=;
        b=JQxo9BlqkXJrUIRtaPO6UDfDf2KzhA2zHdJjzVBh8lbn6dItL9Or5gQKdit8MSYPRw
         CtSASVux6gCPRRybiaMv/Iw1vQRAfjEZ2GIu7o+xewIVogMmKp11yinjQb3HToaJHeb7
         Zh1h2alB1hcjr53X/rh5u4WnOqTmhV3fVm1NAo6libM3hoXftlR/gPMk58pCbJoc2wtJ
         cPMoM6Pq8mtGAx8qQDWpSpHLRcQKUKyfW0oYRXWekxkdFz4541RkGH1GZ9MB21FyL8J6
         AN8v6+wRv1r5Gh+P679xJiioOKzAMI3a/QJrUOKiV037qloJcf+NDzJKeXpMqwR/JosZ
         hldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dabFVq2vIfkiMJi0PCbmOTxkxSS04V2Qjkp35jIZ0hY=;
        b=kCnuuWkcHwsmVARE8IW+Po+FSnRHXtCKnxjER4pzNNaNiJS8YoiwZl442XOuniVDuD
         jLXPm2YeFsZQ2JqzxETYWjtlrg1HVKtI07FjNwmH377lciBFsmspeOBV8nMuFWb7lpnC
         eXoT3iDv+LPFo1XIVzr/awgiLmIJxPDlC6AyhB+WS2JsmrjDRekMW0f/Dwi84bRGXElD
         SF5p9YNQtWCbvrORovKaDs8tYsb5Ml8SCpIqYAhz8Z50IV7ayNZzUIxdnlnIOnzv1mJG
         b70FqJ1v9AvnF972FQCej4jh2EFNXgGgEjBIyGPB0kLiRwgSVhAjH9xDXc5MyIn1hvil
         aCKg==
X-Gm-Message-State: APjAAAU/JDtEeB1AQ1apAmuurA6o6mbaF9yUfB+N9yPCon8uWle2Fhdf
        5gFbbe7qO3lYXVnRNpnNql6lqw==
X-Google-Smtp-Source: APXvYqyVwot4uO6uP3wpOaXNZupsyOENiPAa3Z5aNHa5v/LMO/XfnExNrox1+Gy0AmaIYpM36TjKfQ==
X-Received: by 2002:a37:aa58:: with SMTP id t85mr10205984qke.291.1552842899719;
        Sun, 17 Mar 2019 10:14:59 -0700 (PDT)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id j27sm2665058qki.64.2019.03.17.10.14.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 10:14:58 -0700 (PDT)
Message-ID: <d04f72a473b2b2f9e2034160fb410cc16ed8eb4b.camel@ndufresne.ca>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>
Date:   Sun, 17 Mar 2019 13:14:57 -0400
In-Reply-To: <20190317161041.GC17898@pendragon.ideasonboard.com>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
         <CAAFQd5COSecRGOSUyQGAe0ob-do0C5=FqhQZoq-d1EULhMiWHg@mail.gmail.com>
         <2004464.r89rQTy7OA@avalon>
         <CAAFQd5Dp3xUba-p4qOcZAtfHUd=TQFkEh7TRVdQ_F1=9Qif-9Q@mail.gmail.com>
         <20190317161041.GC17898@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le dimanche 17 mars 2019 à 18:10 +0200, Laurent Pinchart a écrit :
> > 3) For CAPTURE buffers, it's actually defined as set-by-driver
> > (https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#struct-v4l2-plane),
> > so anything userspace sets there is bound to be ignored. I'm not sure
> > if we can change this now, as it would be a compatibility issue.
> > 
> > (There are actually real use cases for it, i.e. the venus driver
> > outputs VPx encoded frames prepended with the IVF header, but that's
> > not what the V4L2 VPx formats expect, so the data_offset is set by the
> > driver to point to the raw bitstream data.)
> 
> Doesn't that essentially create a custom format though ? Who consumes
> the IVF header ?

I see where you are going, but exposing IVF would be a useless dump of
complexity for the userspace. IFV contains no useful information that
is not already exposed by v4l2 interface. In this context, it's like
exposing the USB headers. The use of data_offset is simply to avoid a
copy. As Tomasz said, this is the exact purpose of data_offset.

> 
> Another use case is handling of embedded data with CSI-2.
> 
> CSI-2 sensors can send multiple types of data multiplexed in a single
> virtual channels. Common use cases include sending a few lines of
> metadata, or sending optical black lines, in addition to the main image.
> A CSI-2 source could also send the same image in multiple formats, but I
> haven't seen that happening in practice. The CSI-2 standard tags each
> line with a data type in order to differentiate them on the receiver
> side. On the receiver side, some receivers allow capturing different
> data types in different buffers, while other support a single buffer
> only, with or without data type filtering. It may thus be that a sensor
> sending 2 lines of embedded data before the image to a CSI-2 receiver
> that supports a single buffer will leave the user with two options,
> capturing the image only or capturing both in the same buffer (really
> simple receivers may only offer the last option). Reporting to the user
> how data is organized in the buffer is needed, and the data_offset field
> is used for this.
> 
> This being said, I don't think it's a valid use case fo data_offset. As
> mentioned above a sensor could send more than one data type in addition
> to the main image (embedded data + optical black is one example), so a
> single data_offset field wouldn't allow differentiating embedded data
> from optical black lines. I think a more powerful frame descriptor API
> would be needed for this. The fact that the buffer layout doesn't change
> between frames also hints that this should be supported at the format
> level, not the buffer level.

