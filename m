Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B57C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D02F20645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BTTeGePb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfAODXG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 22:23:06 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42622 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfAODXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 22:23:06 -0500
Received: by mail-ot1-f65.google.com with SMTP id v23so1214664otk.9
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 19:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=srtLab/5/oksBt3T1uFQDnpuaZ2VDkbyu9U/xf0gVE0=;
        b=BTTeGePbsGkYjbE5knz0VEWEaoA3MgYrtu87J0gqj1N2q2EjcI5FN5iXzQ5S+AVm+I
         WGLzYX82CMpS1IKl7SfLVkmbNWbp7s20iQm4sgz/JvN05Uyr/74D+ysxncyWJbgd7NXW
         sXTzfHr+/ZQOFRPV+vf80GslEOfpJQF/YfbKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=srtLab/5/oksBt3T1uFQDnpuaZ2VDkbyu9U/xf0gVE0=;
        b=Z5doZXIudol4oeWEsh8sAoeixw7nAqRa3IV0/pwYRJTMXP5q6KVH8VyKbaEmZhZkHs
         Iv81CCh9FLDrYCmdcEU4kUzcvND2RCo2lvL6YGZEVYYZJfv99gnFMKw11Gd1n7wqTVcW
         fiUtHkcf+yv8iRkxqZcmhtj7kjfLIzoa53+BviOUzJjkHJGiIeccOTbluBmIUX1Ej5Qe
         6JTDAUwBlRR2QAt3b0jShEslfOllgjexgWA9s3+CTOZaFLgAUVD1iB9M/qQ0bkyAZDZW
         djQshByhMs09nGPUyqCsmvRxBUzhaX8d4ItwXs/+Z2HbF3RlLI2DML+J78TOGf4ZzXY2
         gkCA==
X-Gm-Message-State: AJcUukfASPnkUhXr5sy54K34Eqkd/G5CXn97Oh6Lltuf2BiNMpTXPePO
        z8dFdJc6VufsvkMpgWyH9lOGkBN03+Y=
X-Google-Smtp-Source: ALg8bN7q9aNxjeOqR0dF12TnlY6AdROtdXTemOC7Pbbc9bPGvkTWznm/5j9osJ2tN86iE9qqnODdUg==
X-Received: by 2002:a9d:6552:: with SMTP id q18mr1064955otl.128.1547522585208;
        Mon, 14 Jan 2019 19:23:05 -0800 (PST)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id d66sm1101733oia.29.2019.01.14.19.23.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 19:23:04 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id v23so1214574otk.9
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 19:23:04 -0800 (PST)
X-Received: by 2002:a9d:1b67:: with SMTP id l94mr965605otl.147.1547522583856;
 Mon, 14 Jan 2019 19:23:03 -0800 (PST)
MIME-Version: 1.0
References: <1547176516-18074-1-git-send-email-ben.kao@intel.com>
In-Reply-To: <1547176516-18074-1-git-send-email-ben.kao@intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 15 Jan 2019 12:22:52 +0900
X-Gmail-Original-Message-ID: <CAAFQd5B1nkEDou9Jj78sMnB-pc+qx-76i8hk0mdb-sjj6TkCfw@mail.gmail.com>
Message-ID: <CAAFQd5B1nkEDou9Jj78sMnB-pc+qx-76i8hk0mdb-sjj6TkCfw@mail.gmail.com>
Subject: Re: [PATCH v2] media: ov8856: Add support for OV8856 sensor
To:     Ben Kao <ben.kao@intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ben,

On Fri, Jan 11, 2019 at 12:12 PM Ben Kao <ben.kao@intel.com> wrote:
>
> This patch adds driver for Omnivision's ov8856 sensor,
> the driver supports following features:
[snip]
> +static int ov8856_write_reg(struct ov8856 *ov8856, u16 reg, u16 len, u32 __val)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&ov8856->sd);
> +       unsigned int buf_i, val_i;
> +       u8 buf[6];
> +       u8 *val_p;
> +       __be32 val;
> +
> +       if (len > 4)
> +               return -EINVAL;
> +
> +       buf[0] = reg >> 8;
> +       buf[1] = reg & 0xff;

The two lines above can be simplified into one put_unaligned_be16(reg, buf);

> +
> +       val = cpu_to_be32(__val);
> +       val_p = (u8 *)&val;
> +       buf_i = 2;
> +       val_i = 4 - len;
> +
> +       while (val_i < 4)
> +               buf[buf_i++] = val_p[val_i++];

All the code above can be simplified into:

val <<= 8 * (4 - len);
put_unaligned_be32(val, buf + 2);

> +
> +       if (i2c_master_send(client, buf, len + 2) != len + 2)
> +               return -EIO;
> +
> +       return 0;
> +}

Best regards,
Tomasz
