Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77699C07E85
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 02:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3609F2081C
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 02:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CE8N0kvB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3609F2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbeLJCys (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 21:54:48 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46808 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbeLJCys (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 21:54:48 -0500
Received: by mail-yw1-f66.google.com with SMTP id t13so3395781ywe.13
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 18:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awjqjDfRF6TeQt6arOFEI/4R9K2VKVEvz/ATGdH81WM=;
        b=CE8N0kvBw3QMOhoR60MLta2S6jeuKmhb6sr4J6muv4Kzf8lEtJh5da9z22552847xx
         NnKW3CWPNvtjlqPPZDJVpqysp0sn6Zhmxr4JuCACAZiPgnDDCfXKoczIYSjfVApxgI28
         pT0E9FauRV/B6a0oEfXy6BoH2bD4/0QP8xKMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awjqjDfRF6TeQt6arOFEI/4R9K2VKVEvz/ATGdH81WM=;
        b=MxNtNSPf0O67pNbX6X2qSJTQX0J+YXMeLP1OLWEQ5P65Owd4Di9HbtBjm5Dzc+f61L
         NFaFMV2Aqfp5qUPtRhTZ3RuKoP1d7erLJpFOxPvE7MZ3h+ggQWRIXH+abytCXtPeEEKn
         MPJp5RnjDPIcZ8fhDR9tMGfKjL4Fj3K3p+jYNjrf4kONTEHIy6220VmxKVVn0d9FjHHf
         gPkVRhAcfpLNmApgy46lOKlB+mA4fdHxWAaW02MMy6ka2WNK5GfLq+idoW7L8Z/CYd55
         B0CxYqCAIKb3tnjvlkqV8Ogk8LDSh5fi2E5OlYJa+o9x8lYJm0gMHhhzXEWcANHZ7Ngy
         sYPg==
X-Gm-Message-State: AA+aEWbi5GEijmbUnNC0ukBvvuKGjeBv0voZEEbuJVQsoVku54DXBSQ/
        kiuzU4X3YrokHwa28OGZhMxOxV2DfXNkbg==
X-Google-Smtp-Source: AFSGD/U6/nktj1fVko8Q7Z1UhNjBUvuVRaP1VJulIahfNQR/2GkvHY/RleQRkA2uGnHoaAVAN4VURQ==
X-Received: by 2002:a0d:cac7:: with SMTP id m190mr10449424ywd.319.1544410486680;
        Sun, 09 Dec 2018 18:54:46 -0800 (PST)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id a72sm3256719ywh.42.2018.12.09.18.54.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 18:54:45 -0800 (PST)
Received: by mail-yw1-f44.google.com with SMTP id f65so3392965ywc.8
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 18:54:45 -0800 (PST)
X-Received: by 2002:a81:3d51:: with SMTP id k78mr11006302ywa.415.1544410485420;
 Sun, 09 Dec 2018 18:54:45 -0800 (PST)
MIME-Version: 1.0
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Dzk2AxMXA+QUFJ+LqRudVe6T6-tt2wY1q4Zpw2Hhhhrw@mail.gmail.com>
 <28de442c-5893-adc4-5801-c54f45a82849@linux.intel.com> <20181203102503.j5ts32pchn6jdsfk@paasikivi.fi.intel.com>
In-Reply-To: <20181203102503.j5ts32pchn6jdsfk@paasikivi.fi.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 10 Dec 2018 11:54:33 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BrJVS1EVum2NQip8MxFTtT2vA3qAaxQ=AR9qeZ48hWag@mail.gmail.com>
Message-ID: <CAAFQd5BrJVS1EVum2NQip8MxFTtT2vA3qAaxQ=AR9qeZ48hWag@mail.gmail.com>
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     bingbu.cao@linux.intel.com, Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari, Bingbu,

On Mon, Dec 3, 2018 at 7:25 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Bing Bu, Tomasz,
>
> On Mon, Dec 03, 2018 at 10:53:34AM +0800, Bingbu Cao wrote:
> >
> >
> > On 12/01/2018 02:08 AM, Tomasz Figa wrote:
> > > Hi Bingbu,
> > >
> > > On Mon, Nov 26, 2018 at 7:56 PM <bingbu.cao@intel.com> wrote:
> > > > From: Bingbu Cao <bingbu.cao@intel.com>
> > > >
> > > > Some Sony camera sensors have same test pattern
> > > > definitions, this patch unify the pattern naming
> > > > to make it more clear to the userspace.
> > > >
> > > > Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > > > ---
> > > >   drivers/media/i2c/imx258.c | 8 ++++----
> > > >   drivers/media/i2c/imx319.c | 8 ++++----
> > > >   drivers/media/i2c/imx355.c | 8 ++++----
> > > >   3 files changed, 12 insertions(+), 12 deletions(-)
> > > >
> > > Thanks for the patch! One comment inline.
> > >
> > > > diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> > > > index 31a1e2294843..a8a2880c6b4e 100644
> > > > --- a/drivers/media/i2c/imx258.c
> > > > +++ b/drivers/media/i2c/imx258.c
> > > > @@ -504,10 +504,10 @@ struct imx258_mode {
> > > >
> > > >   static const char * const imx258_test_pattern_menu[] = {
> > > >          "Disabled",
> > > > -       "Color Bars",
> > > > -       "Solid Color",
> > > > -       "Grey Color Bars",
> > > > -       "PN9"
> > > > +       "Solid Colour",
> > > > +       "Eight Vertical Colour Bars",
> > > Is it just me or "solid color" and "color bars" are being swapped
> > > here? Did the driver had the names mixed up before or the order of
> > > modes is different between these sensors?
> > The test pattern value order of the 3 camera sensors should be same.
> > All are:
> > 0 - Disabled
> > 1 - Solid Colour
> > 2 - Eight Vertical Colour Bars
> > ...
> >
> > This patch swapped the first 2 item for imx258 (wrong order before) and use unified
> > name for all 3 sensors.
>
> I guess this isn't based on Jason's patch (now merged) that fixed the
> issue. I'll rebase this; it's trivial.

Thanks for clarifying.

Best regards,
Tomasz
