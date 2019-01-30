Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F91C282CD
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 04:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8EB2175B
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 04:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="peYpHg6e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfA3ECm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 23:02:42 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:46067 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbfA3ECm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 23:02:42 -0500
Received: by mail-qt1-f174.google.com with SMTP id e5so24797896qtr.12
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 20:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mpAyJ6A+4zaq0y6PQ+k7WfMDxV/WMZyQex98KcwNFrc=;
        b=peYpHg6e9zxANg71FCvjlY+J/nOX+aNC3OKf3IKw8pTL8bchvs6AM3M37QAchtaMKi
         baYaZEysPvjzu0RhGvA2A5XdapqWYOsnzJHL89qz6yl5kosfAu5kjr/TQQ3303LXomE3
         zP/6lOm4XltjVZBReWbvpiZmuad4EaWgcO+G6jDioLNMQux+umIXwbQksoad0WJD1iVo
         zsqiPPEd2Qk9rKawHL8UMzXTuRDyVa4RQZ4GPynu1l7zIrRM+IDonmZ0miEDo8aB7N3R
         oZmYJR9NKthRF/EUHC+sRrCq7oYoRr8Dd2wIL78yIaCj2nf45G6+TPfZVqUoGTj9ngXw
         vxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mpAyJ6A+4zaq0y6PQ+k7WfMDxV/WMZyQex98KcwNFrc=;
        b=oCXKht4iAxmD+3/6H3kdbU7++V3cQE/aXvojTOMSdFASZbxrPzFlNZt6hyitpIywGc
         OyZvE769GiVNlv2rC2gXg3bZkSN8dv8MimBRKH3pv5h49pa5zG2+/2m7Fb/7/tvCYakH
         YSbhmIvubQcoM/U3H45EoJcV3UNjOgMGWagKYkiMmqK19+DBavysoziV2ittd0/AjrLg
         HNxj1CnB/O3xQwDsllP2Qffcbg6zRQEPCdkRkhxdmUVKSpLKd/5yVjiXzGw2Yy1qXwtN
         4Vi3xiHTk/GFqiw2x9mxOZoIwkJHI8jZ+5uKgs2UtQNbD59nd5OA8xLTAVFk7/T0YF78
         a8sA==
X-Gm-Message-State: AJcUuke1sc0ZCR2Cc8t9gGlk+rdeTnUZUQxFGIDbECzqKZNw4notLB77
        +n3+07TMMyK6Ew33DpL00GQI1g==
X-Google-Smtp-Source: ALg8bN5v2rYu51uuBZ6Afl5qNvz8Y884DGYQ5ePGJddYAunCyNqPumPoHOYpF9TIEBaXzRifwwbfXw==
X-Received: by 2002:a0c:e394:: with SMTP id a20mr26413478qvl.42.1548820960990;
        Tue, 29 Jan 2019 20:02:40 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id y4sm670810qtc.47.2019.01.29.20.02.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 20:02:39 -0800 (PST)
Message-ID: <c145fbf21301d03bdfdd8bf6613f0f68576e66be.camel@ndufresne.ca>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
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
Date:   Tue, 29 Jan 2019 23:02:38 -0500
In-Reply-To: <CAAFQd5C_OD=bvAxG0B_G+T6bnWddPHuiVZApj_8_+4xpMjH9+g@mail.gmail.com>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-2-tfiga@chromium.org>
         <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl>
         <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
         <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl>
         <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
         <CAAFQd5BPJv3cbJOWrziEjz_yE32DhfZv9vb-pG1Ltx-KS2=PQg@mail.gmail.com>
         <3ea3bf5bf9904ce877142c41f595207752172d27.camel@ndufresne.ca>
         <CAAFQd5C_OD=bvAxG0B_G+T6bnWddPHuiVZApj_8_+4xpMjH9+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le vendredi 25 janvier 2019 à 12:27 +0900, Tomasz Figa a écrit :
> On Fri, Jan 25, 2019 at 4:55 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > Le jeudi 24 janvier 2019 à 18:06 +0900, Tomasz Figa a écrit :
> > > > Actually I just realized the last point might not even be achievable
> > > > for some of the decoders (s5p-mfc, mtk-vcodec), as they don't report
> > > > which frame originates from which bitstream buffer and the driver just
> > > > picks the most recently consumed OUTPUT buffer to copy the timestamp
> > > > from. (s5p-mfc actually "forgets" to set the timestamp in some cases
> > > > too...)
> > > > 
> > > > I need to think a bit more about this.
> > > 
> > > Actually I misread the code. Both s5p-mfc and mtk-vcodec seem to
> > > correctly match the buffers.
> > 
> > Ok good, since otherwise it would have been a regression in MFC driver.
> > This timestamp passing thing could in theory be made optional though,
> > it lives under some COPY_TIMESTAMP kind of flag. What that means though
> > is that a driver without such a capability would need to signal dropped
> > frames using some other mean.
> > 
> > In userspace, the main use is to match the produced frame against a
> > userspace specific list of frames. At least this seems to be the case
> > in Gst and Chromium, since the userspace list contains a superset of
> > the metadata found in the v4l2_buffer.
> > 
> > Now, using the produced timestamp, userspace can deduce frame that the
> > driver should have produced but didn't (could be a deadline case codec,
> > or simply the frames where corrupted). It's quite normal for a codec to
> > just keep parsing until it finally find something it can decode.
> > 
> > That's at least one way to do it, but there is other possible
> > mechanism. The sequence number could be used, or even producing buffers
> > with the ERROR flag set. What matters is just to give userspace a way
> > to clear these frames, which would simply grow userspace memory usage
> > over time.
> 
> Is it just me or we were missing some consistent error handling then?
> 
> I feel like the drivers should definitely return the bitstream buffers
> with the ERROR flag, if there is a decode failure of data in the
> buffer. Still, that could become more complicated if there is more
> than 1 frame in that piece of bitstream, but only 1 frame is corrupted
> (or whatever).

I agree, but it might be more difficult then it looks (even FFMPEG does
not do that). I believe the code that is processing the bitstream in
stateful codecs is mostly unrelated from the code actually doing the
decoding. So what might happen is that the decoding part will never
actually allocate a buffer for the skipped / corrupted part of the
bitstream. Also, the notion of a skipped frame is not always evident in
when parsing H264 or HEVC NALs. There is still a full page of text just
to explain how to detect that start of a new frame.

Yet, it would be interesting to study the firmwares we have and see
what they provide that would help making decode errors more explicit.

> 
> Another case is when the bitstream, even if corrupted, is still enough
> to produce some output. My intuition tells me that such CAPTURE buffer
> should be then returned with the ERROR flag. That wouldn't still be
> enough for any more sophisticated userspace error concealment, but
> could still let the userspace know to perhaps drop the frame.

You mean if a frame was concealed (typically the frame was decoded from
a closed by reference instead of the expected reference). That is
something signalled by FFPEG. We should document this possibility. I
actually have something implemented in GStreamer. Basically if we have
the ERROR flag with a payload size smaller then expected, I drop the
frame and produce a drop event message, while if I have a frame with
ERROR flag but of the right payload size, I assume it is corrupted, and
simply flag it as corrupted, leaving to the application the decision to
display it or not. This is a case that used to happen with some UVC
cameras (though some have been fixed, and the UVC camera should drop
smaller payload size buffers now).

> 
> Best regards,
> Tomasz

