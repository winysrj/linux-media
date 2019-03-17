Return-Path: <SRS0=+2CU=RU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078EAC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 17:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EE712082F
	for <linux-media@archiver.kernel.org>; Sun, 17 Mar 2019 17:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="euurhpjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCQRKs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:10:48 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38929 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfCQRKs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Mar 2019 13:10:48 -0400
Received: by mail-qt1-f195.google.com with SMTP id t28so15448809qte.6
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2019 10:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=TyAGEXQlsgs9j870Dy+fzHozW2byN8UISMQxPxkqylY=;
        b=euurhpjCqTDkaEAydKbw7wE45GLeSh0HiVHoTjfJSPUsrOOJkCbUm60yxfF7CSRe9i
         aDzTwtrb6adLUZTvE6EHaX6sxsuQgk2+rh6huR7m7glR6yxgMBaDy355WurXS00tDKi8
         jZ4p20QcFprdOPkbhLDry3rRQ3S0eaehXlY8YtVNzIiiZD5orXxJkVvfcqro1YeJ5LTO
         rZ/3nphZUZVxzcaNffyx54ZU7w/FGljoGWDJlHp/ZO5A70U6E1iGaxcuZbKNDwGt3KkC
         oKWgUFpT7GiJI07orIsf9Z7NFUZzRCzmdnv6GDG33z2rraKwjKbSz5kcJGzrZK4OgyHP
         RqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TyAGEXQlsgs9j870Dy+fzHozW2byN8UISMQxPxkqylY=;
        b=fkp3MJWQfEaJILwMpuFokeWQTGkxnDy8fcDWud1uSfFnvv7Uk6ET1PK57UKnQ0He13
         Dfz0AHMoZiCYmC0c9Lqs7iSCPMWVJ26aFozUzqQDuB363NL8AHNgHpl5/wZOnKh9hA5Z
         ZdnJ1cLPyIjykfI0HA1/e//X+zF5o2ElNaC1yikcnpMnRre2dZ7wGiQlW78VhI9GR4r+
         wHQfRPhZQJL4WMfKmsvxjh4wDOq2oIIDkWW9p6pNtwbNq3n3F2W/1nNDEbAdIvd2Rybj
         KaGF4PEYeJuqRGep273/BDZ3ZyuLe//roiHkOHl0rUtTsNas7go9zZVxBYk9NrWiiQuZ
         te+w==
X-Gm-Message-State: APjAAAVPkh68Vk1G+7Vqep5GdIpiFZjdAPucuy1fCfE5UfxRplSwzPr2
        BCT3psdEKz0v49MIhNd4V8gHGg==
X-Google-Smtp-Source: APXvYqwPB/hkGS0iPw7fDUw83fFti71EFfM7YJfYJqRyIUeHqEnu6Z+d/x4PMAs8Q1rbODb+T5yCZw==
X-Received: by 2002:ac8:140a:: with SMTP id k10mr10441604qtj.66.1552842647471;
        Sun, 17 Mar 2019 10:10:47 -0700 (PDT)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id s18sm5134689qts.60.2019.03.17.10.10.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 10:10:46 -0700 (PDT)
Message-ID: <976b754b4f08626b4b41ee3b743f0c6712173e21.camel@ndufresne.ca>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Boris Brezillon <boris.brezillon@collabora.com>
Date:   Sun, 17 Mar 2019 13:10:45 -0400
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
> Hi Tomasz,
> 
> On Fri, Mar 15, 2019 at 01:18:17PM +0900, Tomasz Figa wrote:
> > On Fri, Oct 26, 2018 at 10:42 PM Laurent Pinchart wrote:
> > > On Friday, 26 October 2018 14:41:26 EEST Tomasz Figa wrote:
> > > > On Thu, Sep 20, 2018 at 11:42 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > Some parts of the V4L2 API are awkward to use and I think it would be
> > > > > a good idea to look at possible candidates for that.
> > > > > 
> > > > > Examples are the ioctls that use struct v4l2_buffer: the multiplanar
> > > > > support is really horrible, and writing code to support both single and
> > > > > multiplanar is hard. We are also running out of fields and the timeval
> > > > > isn't y2038 compliant.
> > > > > 
> > > > > A proof-of-concept is here:
> > > > > 
> > > > > https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a
> > > > > 95549df06d9900f3559afdbb9da06bd4b22d1f3
> > > > > 
> > > > > It's a bit old, but it gives a good impression of what I have in mind.
> > > > 
> > > > On a related, but slightly different note, I'm wondering how we should
> > > > handle a case where we have an M format (e.g. NV12M with 2 memory
> > > > planes), but only 1 DMA-buf with all planes to import. That generally
> > > > means that we have to use the same DMA-buf FD with an offset for each
> > > > plane. In theory, v4l2_plane::data_offset could be used for this, but
> > > > the documentation says that it should be set by the application only
> > > > for OUTPUT planes. Moreover, existing drivers tend to just ignore
> > > > it...
> > > 
> > > The following patches may be of interest.
> > > 
> > > https://patchwork.linuxtv.org/patch/29177/
> > > https://patchwork.linuxtv.org/patch/29178/
> > 
> > [+CC Boris]
> > 
> > Thanks Laurent for pointing me to those patches.
> > 
> > Repurposing the data_offset field may sound like a plausible way to do
> > it, but it's not, for several reasons:
> > 
> > 1) The relation between data_offset and other fields in v4l2_buffer
> > makes it hard to use in drivers and userspace.
> 
> Could you elaborate on this ?
> 
> > 2) It is not handled by vb2, so each driver would have to
> > explicitly add data_offset to the plane address and subtract it from
> > plane size and/or bytesused (since data_offset counts into plane size
> > and bytesused),
> 
> We should certainly handle that in the V4L2 core and/or in vb2. I think
> we should go one step further and handle the compose rectangle there
> too, as composing for capture devices is essentially offsetting the
> buffer and setting the correct stride. I wonder if it was a mistake to
> expose compose rectangle on capture video nodes, maybe stride + offset
> would be a better API.

If you have let's say a YUYV buffer, and you want to do a 1 pixel crop
from the left, this approach is not possible since you would introduce
a chroma shift. To implement this correctly, you also need to shift the
UV by half a pixel. Most people take the habit of ignoring this, or
simply refusing unaligned crop, but if you want to let's say to provide
HW for video editing, then you are just doing it wrong. Some HW goes
further and propose sub-pixel coordinates using Q16 representation.

> 
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
> 
> > > > There is also the opposite problem. Sometimes the application is given
> > > > 3 different FDs but pointing to the same buffer. If it has to work
> > > > with a video device that only supports non-M formats, it can either
> > > > fail, making it unusable, or blindly assume that they all point to the
> > > > same buffer and just give the first FD to the video device (we do it
> > > > in Chromium, since our allocator is guaranteed to keep all planes of
> > > > planar formats in one buffer, if to be used with V4L2).
> > > > 
> > > > Something that we could do is allowing the QBUF semantics of M formats
> > > > for non-M formats, where the application would fill the planes[] array
> > > > for all planes with all the FDs it has and the kernel could then
> > > > figure out if they point to the same buffer (i.e. resolve to the same
> > > > dma_buf struct) or fail if not.
> > > > 
> > > > [...]
> > > > 
> > > > > Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps,
> > > > > again in order to improve single vs multiplanar handling.
> > > > 
> > > > I'd definitely be more than happy to see the plane handling unified
> > > > between non-M and M formats, in general. The list of problems with
> > > > current interface:
> > > > 
> > > > 1) The userspace has to hardcode the computations of bytesperline for
> > > > chroma planes of non-M formats (while they are reported for M
> > > > formats).
> > > > 
> > > > 2) Similarly, offsets of the planes in the buffer for non-M formats
> > > > must be explicitly calculated in the application,
> > > > 
> > > > 3) Drivers have to explicitly handle both non-M and M formats or
> > > > otherwise they would suffer from issues with application compatibility
> > > > or sharing buffers with other devices (one supporting only M and the
> > > > other only non-M),
> > > > 
> > > > 4) Inconsistency in the meaning of planes[0].sizeimage for non-M
> > > > formats and M formats, making it impossible to use planes[0].sizeimage
> > > > to set the luma plane size in the hardware for non-M formats (since
> > > > it's the total size of all planes).
> > > > 
> > > > I might have probably forgotten about something, but generally fixing
> > > > the 4 above, would be a really big step forward.

