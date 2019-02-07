Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE93C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 20:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B1952146E
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 20:51:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYenkfTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfBGUu5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 15:50:57 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:56280 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfBGUu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 15:50:57 -0500
Received: by mail-it1-f193.google.com with SMTP id m62so3345780ith.5;
        Thu, 07 Feb 2019 12:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hO9LKfL1892BakhneVS6wEyee5Ldym6m5VVQx8Fbp7I=;
        b=nYenkfTRi/hiXjr5Bztao6vgR9eWzRsbunZxpoPfuCC18dQSrfvkCo0V9aCY4w/KbU
         yYJ5De5YtIqXbGa8mtMrxSnAA1KdPLx5xE/ZyQMV6dZ7kpYLNQEUArm/9TVKczcxtFMM
         6p1fZClqRFegr94aOrO7fcFVsgqsGlDxT2LFZHxjVgl/1S1V2MWp94FTPi4a+6U5/U0r
         Faw36d3hJTar/KU7fKdZ2XnG+s08GqZScKm9yiv4WA4eV0tT1cyOH1onrAlhFlFq9sUe
         QsAX3krUEEIf1LbZ78XtFCnwtDiWrncNZuwhZinbzEwa+yoD6YaXETL5qYj2tIeV5B33
         y/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hO9LKfL1892BakhneVS6wEyee5Ldym6m5VVQx8Fbp7I=;
        b=XA5rLgP3TdDnyHH1PRX/kav4sL7e7UKnyk6TLG56nnKOwyiXas4LHlQ+YVQi6mypUS
         NCDAp3OTKh+cU9rxg4vG+tpx677QKknDRf/4rWKDZF2shJNF5GlvKhzDAEi95on0cwLL
         49NlKPmOFsz4R+dTQf1KklCuFMphu8DW91l9ZKpEqyrEgJOiFxhCqDxAA+NvJU7he44K
         wCJxSiLHtyPyTDTKiMZjjRHY5P5UfHs4gagKBn5iqehJJ46ahK6c2VnApsBmC9f/NXXA
         6+we4MujW/ZYfds6MUIbuSKxkfSuB3TIoqsCfoQd49l6r9oIoPoYBFxuJxtKx3ZnJyUq
         Wt1g==
X-Gm-Message-State: AHQUAuZq51EpMM4SByE3v/+jQEDQjLFX0HonMeG5QHemluSqfrSuJrw2
        84kcWWiH0aixSlIYw+OBUexEycNG4tAz5TxD7ds=
X-Google-Smtp-Source: AHgI3Ia8INPy6OdFJ0yMvXIEHWwPnwIHwGPtsYWoyluU1Y/TnRBD/SSZB0AXMB8cDw8Mn2N9dnAKO1xX+Cna15vdnTU=
X-Received: by 2002:a6b:c544:: with SMTP id v65mr9784991iof.118.1549572656318;
 Thu, 07 Feb 2019 12:50:56 -0800 (PST)
MIME-Version: 1.0
References: <20190122010501.15933-1-lucmaga@gmail.com> <e2359d6c-5f14-14d1-fbba-7fcd8d66de5f@xs4all.nl>
In-Reply-To: <e2359d6c-5f14-14d1-fbba-7fcd8d66de5f@xs4all.nl>
From:   =?UTF-8?Q?Lucas_Magalh=C3=A3es?= <lucmaga@gmail.com>
Date:   Thu, 7 Feb 2019 18:50:45 -0200
Message-ID: <CAK0xOaEDhHfdpM5BaOcACQhXH1_Xt3+208ZAGpEqn1SdwJTbDQ@mail.gmail.com>
Subject: Re: [PATCH v4] media: vimc: Add vimc-streamer for stream control
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

>
> frame_size is set, but not used:
>
> vimc-sensor.c:208:15: warning: variable 'frame_size' set but not used [-W=
unused-but-set-variable]
>
> Can you make a patch fixing this?
>
> I'm not sure how I missed this sparse warning, weird.

Sorry about that. I will be more careful next time with this warnings.
Just sent the next version.

Regards,
Lucas A. M. Magalh=C3=A3es
