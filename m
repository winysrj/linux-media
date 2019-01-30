Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E62AC282CD
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18A5C2184D
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZpsKRDfW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfA3DzE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:55:04 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43707 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbfA3DzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:55:04 -0500
Received: by mail-oi1-f195.google.com with SMTP id u18so18094376oie.10
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JtqYzs3ogvtBl1pHrIvstQIgR6IPY7CyIrvWnG0AaJ4=;
        b=ZpsKRDfWgA/XH0uvXO2d6sI1QYVtoOK8jFg4V/0XzKOalDWA428rz76be0QV9c3I7+
         UxEPO+eM+llHdRWk6eDn61qL7pENYR1x75BVRole8r5oJ3XoxsP3IEF+AACvbW5tu0Si
         xYviNDn104B4LTvV0iynr+37GgwqMQ7sjTNZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JtqYzs3ogvtBl1pHrIvstQIgR6IPY7CyIrvWnG0AaJ4=;
        b=PM4rpfQqOrbcy7LoWP4YWI2dOAxu79ijLefDZqE0V0jeVy5Uc77q4+3isX5ZgarVV1
         jdrex6JTBYll58boS0PTGvvw3+SITeiG4Xd0XmEh8JkVTD/ICjktXQw1xGbiIdMYg64/
         7ak6KFwudPiST93wgQNVIkGTavRTvG+letWf2Wnp+mYhGPWkIIW+JQ4eERwMyD9F9+K9
         otRqKgAglNxlDyqNJSJ2Fra85nDG3/COQOnf6cc9INRLTskpKVOTQM4rijTOfnLJNW5i
         gQGErPFbLxqwMTZ6Z1V6H5LLK2d53EQLIYqOBTmrjwg8V41Q4fyBw1j5YE1E2nlE8ys7
         FFog==
X-Gm-Message-State: AJcUukdsNSvPV4qIu3kA9PT3s1MPV/+PNxxiSdUnyXP+IrD5aBoJ3AdW
        LZz1NbnA1bWitz5INcEFxBtIRnvLBSw=
X-Google-Smtp-Source: AHgI3IaPzN5zNsoelE7Hbt+hHUIIJopvqz61MxTkrlYiO2qdJ23Y3kbqZ9Z+pJiLKPhpI/UzW+xLhA==
X-Received: by 2002:a05:6808:493:: with SMTP id z19mr11650257oid.46.1548820503074;
        Tue, 29 Jan 2019 19:55:03 -0800 (PST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id 75sm153874otc.67.2019.01.29.19.55.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 19:55:02 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id y23so18138974oia.4
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:55:02 -0800 (PST)
X-Received: by 2002:aca:5a88:: with SMTP id o130mr11656800oib.275.1548820501527;
 Tue, 29 Jan 2019 19:55:01 -0800 (PST)
MIME-Version: 1.0
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
 <20190118133716.29288-3-m.tretter@pengutronix.de> <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
 <20190123151709.395eec98@litschi.hi.pengutronix.de> <f0df52b3ac7dfd5bdac8f18053f7db27de5bc230.camel@ndufresne.ca>
In-Reply-To: <f0df52b3ac7dfd5bdac8f18053f7db27de5bc230.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 30 Jan 2019 12:54:50 +0900
X-Gmail-Original-Message-ID: <CAAFQd5A7w0veEeNXFYMfpzZw4d9HCwHMk8EyKBMv4wmUOVJYiA@mail.gmail.com>
Message-ID: <CAAFQd5A7w0veEeNXFYMfpzZw4d9HCwHMk8EyKBMv4wmUOVJYiA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core driver
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org, Sasha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 30, 2019 at 12:46 PM Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
>
> Le mercredi 23 janvier 2019 =C3=A0 15:17 +0100, Michael Tretter a =C3=A9c=
rit :
> > > I have a patch pending that allows an encoder to spread the compresse=
d
> > > output over multiple buffers:
> > >
> > > https://patchwork.linuxtv.org/patch/53536/
> > >
> > > I wonder if this encoder would be able to use it.
> >
> > I don't think that the encoder could use this, because of how the
> > PUT_STREAM_BUFFER and the ENCODE_FRAME command are working: The
> > ENCODE_FRAME will always write the compressed output to a single buffer=
.
> >
> > However, if I stop passing the vb2 buffers to the encoder, use an
> > internal buffer pool for the encoder stream buffers and copy the
> > compressed buffer from the internal buffers to the vb2 buffers, I can
> > spread the output over multiple buffers. That would also allow me, to
> > get rid of putting filler nal units in front of the compressed data.
> >
> > I will try to implement it that way.
>
> As explained in my previous email, this will break current userspace
> expectation, and will force userspace into parsing the following frame
> to find the end of it (adding 1 frame latency).

I don't think you would need to do any parsing to detect it. I think
the assumption that a buffer only contains 1 frame would still hold.
An extra buffer would be used for the remaining part of the current
frame and then we would take another buffer for the next frame.

Still, I also recall that we assumed that we have 1 buffer per 1 frame
for encoders, so indeed it could break some apps. At least it needs
some careful analysis, if we want to change it.

>
> I have used a lot the vendor driver for this platform and it has always
> been able possible to get the frame size right, so this should be
> possible here too.
>
> Nicolas
>
