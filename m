Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E967C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 19:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF112217D4
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 19:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="k3ZBpOvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbfAXTzV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 14:55:21 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42141 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730554AbfAXTzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 14:55:20 -0500
Received: by mail-qt1-f194.google.com with SMTP id d19so8110891qtq.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 11:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=D2DpmYRNVQtbvlzPzUuRBNiPxDNorQmKQkpApf2FSTU=;
        b=k3ZBpOvS+eH3nyNivULfNIPm5obG8tAPQuPHcOAsVGTUWCZtVcFJg0kz3OVPwJXbxl
         PnbxDCUokLXzn5aVED60tHzI1TAaOa8A3qiAtF89QaCsjkThrkixueheabN9iN2j2Prb
         nvZsQ1fABqmTL82bJBtMPDaj/+hLFDWRWjhZWHg99yvg0nYUw4cjK+MW+TbsT8JOWCXO
         CtXh4MZAg+2/PgDKnXp8Uqk9/5vY2Zb31aZrJTh252S8ObEwWX+bO3gDnW1A9ibufGdb
         DgTsD9NX8SlIXEDOX/A+i/fYJqOc/Xq6R7/qT0xiU81TgcNVu3qpTgCsItS0sHZA0axa
         /1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=D2DpmYRNVQtbvlzPzUuRBNiPxDNorQmKQkpApf2FSTU=;
        b=G0CWKhdXNDwAdIfae93m43IqNsKZ0PrpfitjYoceofkg8Q3mMlo7vgMHGVu/sHubjC
         3iY8N6jzk3P8nqd0++F0vgzkllOoriCWlL2E6IdVwtOKU3fjaGNCEjKz+XElXCbuQr8I
         fICv19MIjSz/I/zbB9/knOCNGMNa1/uPcXJXhk5mbY7ge7KKG8O3/M/nHeTNPlX0yMMu
         HuyY0IMM+lYUYQ9z+gWb61/sr3uVV0Cd67OPC8D+x952VmDDeGQC4+WPT4AbKWkOkH5p
         lyHaWnmbwbfs39yfVE8SgZTgKd+56wUpJsBrEAUKZviCEs4wGG/lDgbMCP0y70Y7kt6S
         cAKg==
X-Gm-Message-State: AJcUukcPG4vDC3JYOrPXkwy+4DwChYfcZpC4PY5HGYoHXE/XhSyGA3YV
        0jI6vw86nz/JLvk+ajKNTWy6WA==
X-Google-Smtp-Source: ALg8bN5suTD/Zfz9CkqUuBDiuFpWfLgObPF6lA+DMqG7XVwt8g3cQAS6AZyxWDgfphWGBCjhMUbWGQ==
X-Received: by 2002:a0c:df12:: with SMTP id g18mr7269784qvl.208.1548359719064;
        Thu, 24 Jan 2019 11:55:19 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id y14sm87528408qky.83.2019.01.24.11.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 11:55:17 -0800 (PST)
Message-ID: <3ea3bf5bf9904ce877142c41f595207752172d27.camel@ndufresne.ca>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?= 
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date:   Thu, 24 Jan 2019 14:55:16 -0500
In-Reply-To: <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-2-tfiga@chromium.org>
         <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl>
         <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
         <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl>
         <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
         <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le jeudi 24 janvier 2019 à 18:06 +0900, Tomasz Figa a écrit :
> > Actually I just realized the last point might not even be achievable
> > for some of the decoders (s5p-mfc, mtk-vcodec), as they don't report
> > which frame originates from which bitstream buffer and the driver just
> > picks the most recently consumed OUTPUT buffer to copy the timestamp
> > from. (s5p-mfc actually "forgets" to set the timestamp in some cases
> > too...)
> > 
> > I need to think a bit more about this.
> 
> Actually I misread the code. Both s5p-mfc and mtk-vcodec seem to
> correctly match the buffers.

Ok good, since otherwise it would have been a regression in MFC driver.
This timestamp passing thing could in theory be made optional though,
it lives under some COPY_TIMESTAMP kind of flag. What that means though
is that a driver without such a capability would need to signal dropped
frames using some other mean.

In userspace, the main use is to match the produced frame against a
userspace specific list of frames. At least this seems to be the case
in Gst and Chromium, since the userspace list contains a superset of
the metadata found in the v4l2_buffer.

Now, using the produced timestamp, userspace can deduce frame that the
driver should have produced but didn't (could be a deadline case codec,
or simply the frames where corrupted). It's quite normal for a codec to
just keep parsing until it finally find something it can decode.

That's at least one way to do it, but there is other possible
mechanism. The sequence number could be used, or even producing buffers
with the ERROR flag set. What matters is just to give userspace a way
to clear these frames, which would simply grow userspace memory usage
over time.

Nicolas

