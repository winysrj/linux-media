Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CED3C43612
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 01:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A927222CD
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 01:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pv53glUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfAFBtH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 20:49:07 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36973 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfAFBtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 20:49:07 -0500
Received: by mail-qk1-f193.google.com with SMTP id g125so23613063qke.4;
        Sat, 05 Jan 2019 17:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tUkkl0qhZM5DIglKjRN2EUbO0Hda5vdnVX9N8SgLzRE=;
        b=Pv53glUuZxl6mBClUTV1FxbaIrGhL+fV+T5FesPtsripD4FwJIedMm/2r2MyJYv1DM
         45n+UEQMOksDVraDoWe7VOf5vqO/p5ctSLxb8P8uiG1/Tk8XVdgjgOfiI4fuFaczjvCb
         8YftyQC1tR7wvDafFEkIqoqrsKhRpUCTw/gmXOfzlaMionIZZvTup4eAUZ1nk8ikpka9
         9/JP1YKZTbF91Fp99iF/V3eW7ED4ff6Mj2izhc7E+sD73Qiho6pb6svFtun9ZpphaSoA
         U4yzgEiBBgSwvP5jshXSuk4/DOWOZ7blkXtUe0KnqbaYQrCefBPgGugoQqnNSx2NbvrU
         Souw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tUkkl0qhZM5DIglKjRN2EUbO0Hda5vdnVX9N8SgLzRE=;
        b=JzxcaMejBbHpM0T8yN+MDwO/z9Fgf0JCcxHHPzaxeeyQeuPztr79HSuRuIMmbH1nks
         upujhaR0GT4hg+7DYCehlzkmNr8DUuSu/sBHR4G8DI/mj76vQ6u+iDUc3dZGOnRn0cRS
         +fCOLuvJGmyLjqQ939IrzTDDaVDSo5izPc7hGghJdHqLMNOyVL8cSidLsu+zhfc6O/mz
         M1dIXQmc1RLFFBKPF/HVKmlXQEvKLtrNKMySisU1OnHcEYIir/JBGjkaE59/tWtuZ/Yx
         irk6rSkNrrXnCj9W0t9Grr4aZ/kngZH0iXURLLJAMSF87CgPIejecvMRyWC9bzo34SCh
         Ps9w==
X-Gm-Message-State: AJcUukfwy5kkQkQq4J0c32sED2KULcK4w4fayQyHX0N7Dleu60VqIK+G
        jfNbD5isCyzz22ihiwl8tS4=
X-Google-Smtp-Source: ALg8bN6mt1xfYZZfBL7kb0unqrAxEul9ILb/kK2gRalb3SUmEypl4vDjWjHNWmbW6DdgtsNL4tsDEQ==
X-Received: by 2002:a37:dc04:: with SMTP id v4mr53509361qki.101.1546739344955;
        Sat, 05 Jan 2019 17:49:04 -0800 (PST)
Received: from fedoramac ([2607:fcc8:c903:be00:ba9b:4d78:e27c:1d15])
        by smtp.gmail.com with ESMTPSA id x200sm30240733qkx.47.2019.01.05.17.49.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Jan 2019 17:49:03 -0800 (PST)
Message-ID: <204ed67fafd1ecdc58158da9758a3b6b01ec5ada.camel@gmail.com>
Subject: Re: [PATCH v3] [bug/urgent] dvb-usb-v2: Fix incorrect use of
 transfer_flags URB_FREE_BUFFER
From:   Dan Ziemba <zman0900@gmail.com>
To:     Malcolm Priestley <tvboxspy@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, stable@vger.kernel.org
Date:   Sat, 05 Jan 2019 20:49:00 -0500
In-Reply-To: <7dd3e986-d838-1210-922c-4f8793eea2e9@gmail.com>
References: <7dd3e986-d838-1210-922c-4f8793eea2e9@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 2018-11-26 at 20:18 +0000, Malcolm Priestley wrote:
> In commit 1a0c10ed7b media: dvb-usb-v2: stop using coherent memory
> for URBs
> incorrectly adds URB_FREE_BUFFER after every urb transfer.
> 
> It cannot use this flag because it reconfigures the URBs accordingly
> to suit connected devices. In doing a call to usb_free_urb is made
> and
> invertedly frees the buffers.
> 
> The stream buffer should remain constant while driver is up.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> CC: stable@vger.kernel.org # v4.18+
> ---
> v3 change commit message to the actual cause
> 
>  drivers/media/usb/dvb-usb-v2/usb_urb.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> index 024c751eb165..2ad2ddeaff51 100644
> --- a/drivers/media/usb/dvb-usb-v2/usb_urb.c
> +++ b/drivers/media/usb/dvb-usb-v2/usb_urb.c
> @@ -155,7 +155,6 @@ static int usb_urb_alloc_bulk_urbs(struct
> usb_data_stream *stream)
>  				stream->props.u.bulk.buffersize,
>  				usb_urb_complete, stream);
>  
> -		stream->urb_list[i]->transfer_flags = URB_FREE_BUFFER;
>  		stream->urbs_initialized++;
>  	}
>  	return 0;
> @@ -186,7 +185,7 @@ static int usb_urb_alloc_isoc_urbs(struct
> usb_data_stream *stream)
>  		urb->complete = usb_urb_complete;
>  		urb->pipe = usb_rcvisocpipe(stream->udev,
>  				stream->props.endpoint);
> -		urb->transfer_flags = URB_ISO_ASAP | URB_FREE_BUFFER;
> +		urb->transfer_flags = URB_ISO_ASAP;
>  		urb->interval = stream->props.u.isoc.interval;
>  		urb->number_of_packets = stream-
> >props.u.isoc.framesperurb;
>  		urb->transfer_buffer_length = stream-
> >props.u.isoc.framesize *
> @@ -210,7 +209,7 @@ static int usb_free_stream_buffers(struct
> usb_data_stream *stream)
>  	if (stream->state & USB_STATE_URB_BUF) {
>  		while (stream->buf_num) {
>  			stream->buf_num--;
> -			stream->buf_list[stream->buf_num] = NULL;
> +			kfree(stream->buf_list[stream->buf_num]);
>  		}
>  	}
>  

I have tested this against Arch Linux's kernel packages for both linux
4.20 and linux-lts 4.19.13.  For both, the patch seems to fix the
crashes I reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=201055

Thanks,
Dan Ziemba


