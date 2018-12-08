Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072F1C65BAF
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 13:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C9220892
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 13:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ly0EHkfH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5C9220892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbeLHNLt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 08:11:49 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44879 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeLHNLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 08:11:49 -0500
Received: by mail-qt1-f194.google.com with SMTP id n32so7580972qte.11;
        Sat, 08 Dec 2018 05:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=woh+MkfLHQzFXhkzBgmfQ8EJ6mnVyeDQkKoJcxYaR2M=;
        b=ly0EHkfHxPpGr6YmHFk5EFn4IRADi1POjsT7ngGgutiogEbHB5U1B3ftUGLr+uK1JJ
         I7Sjg65VooTtXLBc9PzEobkm5XIgtNeP/TP9+T1W4kZan5HuYIO88toci8T60hMXI6qJ
         3BxWACNdhAjdToKp9JYOt6MORoKnx9T4sDvIeKBpX7ivqxgTijK+T/Pb46/SsEKRnN+k
         jpUY5rXdV8WrAq4lEO/N/XPtTWNrM+7xsTEgSq8FmQfYqR+c42MGNZv8DpfwE9DsYgOW
         l3boKbPW5V3feKok8+F3Vei5UU2zurTgNdsZxY0QXRhZAsTgK3pIXNjKyHjW0nz+NBWA
         /i9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=woh+MkfLHQzFXhkzBgmfQ8EJ6mnVyeDQkKoJcxYaR2M=;
        b=k1vSV89jBhvz0I6R0FxMsI01t42mB91TM8i4hwglBN9nIghvRLGznnhqQw/G8boopT
         83PijZdu+EnmQy9+Lc9mXmicftR3DYYv0z8v32Rs8MYZVFjEr5F9f6gbG/+Qp5vnfJjJ
         TeKkHv+e2dLLdW28ZDALC/YzbRTWEzodyocc6yYXalaBJhxGYucklA+woGYBq7zwgsy6
         ZVnjREflaKjEEwQtzy1ARJQKq40ovFiEYe63sUXvJLsS81g8tI/MM5TPs4xSAPjyEpiq
         gP/tFdF+fQzqIRxLc38tYgUflUa4Si4TmrWE4UpXAdSrCNlU7gi7EPxLDhj6SuiU0eME
         Jz3A==
X-Gm-Message-State: AA+aEWa0Pm1jPkL89HkV6d8W5qFVKqPDg+xMx3DtWixcPnD8gpP40JWz
        6vaDpivm5BAz1jY+4bsEX+8=
X-Google-Smtp-Source: AFSGD/Wf6l/dQZNZJa7GIFS99A4CQLW0bLOHZtzLA4ju8VrZr9yUy6vgwAldkLPQluyC3iq4EkNKSg==
X-Received: by 2002:a0c:9471:: with SMTP id i46mr5395311qvi.120.1544274707985;
        Sat, 08 Dec 2018 05:11:47 -0800 (PST)
Received: from gfm-ubuntu ([2804:14c:482:ff6:7125:16d4:3eab:35b4])
        by smtp.gmail.com with ESMTPSA id c48sm4126072qtd.9.2018.12.08.05.11.46
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 08 Dec 2018 05:11:47 -0800 (PST)
Date:   Sat, 8 Dec 2018 11:11:44 -0200
From:   Gabriel Francisco Mandaji <gfmandaji@gmail.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org
Subject: Re: [PATCH v4] media: vivid: Improve timestamping
Message-ID: <20181208131144.GA6645@gfm-ubuntu>
References: <20181202134538.GA18886@gfm-note>
 <abdac455-669f-de3d-729d-2c18d188046b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abdac455-669f-de3d-729d-2c18d188046b@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

> I decided to accept this patch. The only change I made was to replace the
> do_div(f_period, 2) by a bit shift.
> 
> Thanks for working on this!

OK, thanks for accepting the patch! I'll pay attention to those details
when working on the following patches.

> Can you look at adding the same support for the video output as well?
> And also SDR capture (in a separate patch).

Yes, for sure! I probably won't start working on those until next week,
but I'll start by the video output. It'll hopefully go a lot smoother
this time.

Regards,
Gabriel F. Mandaji
