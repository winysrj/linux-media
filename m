Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CB1C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AB120700
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u/kBLNGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfBUOrn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:47:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41538 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728429AbfBUOrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:47:42 -0500
Received: by mail-pf1-f193.google.com with SMTP id d25so5587356pfn.8
        for <linux-media@vger.kernel.org>; Thu, 21 Feb 2019 06:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=T3Ik+nPuFV1FZjIR/q2fUpsFYQCrSxwwhlTRF5r9cyA=;
        b=u/kBLNGzwsk5oT1IbOTOgvt+qM7VsgsKw/C2kaSi4HNiqBJxyoG3om0qBKSL0K/1Cr
         NcPRjb6hsoyAHTijHQAlhYOUDRW1dpRgpWCDX6TgBLq3IpCiwo9h2X3+4zorcnasTzqp
         2A9JTjmHnOYD0WsKux9zpXQpE+nH/fCqMlWBrBvcgRgNe8zUES7jYSXKNpJAtkr7xP4l
         Ac7hnblSOv42aJbTsW0yLbXzEph7LA7TH+laP+jYOf9wUWYANdMpkSaoLDpSZhKtirLt
         T9x0xOhaPWO8cjwc/UT6Rf6CI9qyiMiCF7dQ3Q2OeHjcp7Q8iZsttobi34yKVq6KULf/
         YBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T3Ik+nPuFV1FZjIR/q2fUpsFYQCrSxwwhlTRF5r9cyA=;
        b=mHK5PXvNatsdHYeZNfwS0W84TyzVUbVlmqqog4BPbVFfCF6jAplI9MfLg0u2nWQeN6
         TAhN9A5fWgltDKuii5LC3ChAUGvVTjnKAEMVYNemvA8oWXNP+q1Av0uBGAyOQMW9AkKC
         yZnawPrWbVpadZCpvzrt25lA+lnY3yMtVmnzKmF/jVW/D2yB0oX7FdaBnHGVHRHWA2yh
         i0He177TCDy4ENh72z44mmKiVYlj9Js5fHRpqORtwUWc7XqrGo50L/SPF04QfMvMSbeE
         iG7WQzMU+ksly7nGAi/Q7edJ7jaxDZlPzau856/nbNv2mOO0XyQToWqq2viaNGSwhikW
         Ttag==
X-Gm-Message-State: AHQUAuYrWLMFhKMFzU2sTX8PN7hnqTnv95ProxZWuhHxr5cYBL0YJj6V
        iUzuXLhtp79U6+zselQEe1g=
X-Google-Smtp-Source: AHgI3IbGBemo/tWX5Sck5sYKuMI1GWBp4Y4uJGr1ZTT/YkSFNXo8KEUBZSQKVpUfNDG4p+ZWkIWxYw==
X-Received: by 2002:a63:e14e:: with SMTP id h14mr24083581pgk.184.1550760461730;
        Thu, 21 Feb 2019 06:47:41 -0800 (PST)
Received: from [192.168.3.4] (softbank219203027033.bbtec.net. [219.203.27.33])
        by smtp.gmail.com with ESMTPSA id y9sm33461524pfi.74.2019.02.21.06.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 06:47:41 -0800 (PST)
To:     sean@mess.org, linux-media@vger.kernel.org, mchehab@kernel.org
From:   Akihiro TSUKADA <tskd08@gmail.com>
Subject: Re: [PATCH] media: dvb/earth-pt1: fix wrong initialization for demod
 blocks
Message-ID: <80759e10-a3e3-6c69-114a-b91bcf1308d6@gmail.com>
Date:   Thu, 21 Feb 2019 23:47:31 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,
thank you for reviewing my patch,
 ( <20190110095623.28070-1-tskd08@gmail.com>
   https://patchwork.linuxtv.org/patch/53834/ ),
and excuse me for my late reply.
I somehow lost your mail and noticed it just today by checking Patchwork.

On Mon, 18 Feb 2019 21:04:28 +0000, you wrote:
> It might be possible to simplify the code a little by using strcmp() and
> making it into one loop, like so:
> 
> 	for (i = 0; i < PT1_NR_ADAPS; i++) {
> 		cl = pt1->adaps[i]->demod_i2c_client;
> 		if (strcmp(cl->name, TC90522_I2C_DEV_SAT) &&
> 		    strcmp(cl->name, TC90522_I2C_DEV_TER)) 
> 			continue;
> 
> 		ret = i2c_master_send(cl, buf, 2);
> 		if (ret < 0)
> 			return ret;
> 
> 		usleep_range(30000, 50000);
> 	}

Any "cl" has the name of either TC90522_I2C_DEV_SAT or TC90522_I2C_DEV_TER,
and no other name exists.  (adaps[0],adaps[2]: _SAT, adaps[1],adaps[3]: _TER)
The purpose of the code is to ensure that TER clients are processed
BEFORE SAT clients, as noted in the header comment of this function.
So I am afraid that unifying the two loops does not work.

--
Akihiro
