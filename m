Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D85EC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 00:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F047B20811
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 00:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uhUFL6GH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfCTAOs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:14:48 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:46199 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfCTAOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 20:14:48 -0400
Received: by mail-qt1-f170.google.com with SMTP id z25so513350qti.13
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 17:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=zeCkJfUhaa4x/l9s47kCngYxggrbouOezn/88lJe4P8=;
        b=uhUFL6GHkEBRPXBZgIPjbEe6Zb37q05QdCBi4NYQnMSbaHmLOjpTE0svO1phTVBejU
         cnkg8L6eJmu0ASlOJZcGVhKye/0soBo21fQuAKPuxIvHN8mVkaclrDzAqNET/0pawDcI
         Otd/Sstbj3h6by4zSPEMMQhQKZ63HjA5TFc74H48dnP5dakNhdL+IRGRYPoIyl17yTEg
         Y0NNtBfTfoacUDT/9Qczc2mgdD5VBFeE9ZZ46yv1oD2HnPrda1gxuTz0jNHEwVaY2ARU
         OtqN5zZfq3GDAD2fP9dGer2Qcg28LZvQQdswnqP9veAcpVkk5VKtMw5ZWdR/J98xiKNx
         wEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=zeCkJfUhaa4x/l9s47kCngYxggrbouOezn/88lJe4P8=;
        b=gp+32AikxOji0UZ4Daoow7x4Qty4KZc9xOO+UukXFsWSHGUbDEdKAGTtlAGEikYZh/
         VDi59o0M8TWkSUK3RHGfS4aadRGCgC+W+nVH53Pqo50HWQTuS/10p5ySlQDbYZd84A3R
         iqHi+jBsP6yLS/oZGe7XfseLrf532tTuegMkRYFWySRSmDyWIC8FI095vG1y/0fS0quJ
         uNunW+A/fp2n1Uuy4NWreH7RtL+ikLI0MGIayuK5Am4X5m78jf8Olk4k5T4KRTOzYlWO
         ph/CLnoj1tu++dojOXFGETlBMQ738rkDFeK6NNBcZgoB7IILSeZF07kiUawQr3wppET/
         a7QQ==
X-Gm-Message-State: APjAAAWjLGjXRqBAFjpDVea4MdzJh/JOJqq5XCNem+H93iaD7q+MpCIl
        p1TQXHwIL3GU96mxvKRZtjzz9CRI
X-Google-Smtp-Source: APXvYqwWwSCRMf/N4rR0ZHo394Dbh9KYHUIxST5W7EF9fvYbp0hZ5N7uW/t6gJio0HFV6g7ruQNzAA==
X-Received: by 2002:a0c:9b85:: with SMTP id o5mr4197816qve.62.1553040887049;
        Tue, 19 Mar 2019 17:14:47 -0700 (PDT)
Received: from adicarlo.nyc (cpe-67-250-43-8.nyc.res.rr.com. [67.250.43.8])
        by smtp.gmail.com with ESMTPSA id m52sm267850qtc.23.2019.03.19.17.14.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 17:14:46 -0700 (PDT)
Received: from gw.coo (localhost [127.0.0.1])
        by adicarlo.nyc (Postfix) with ESMTP id 8F337A980C3;
        Tue, 19 Mar 2019 20:14:45 -0400 (EDT)
From:   Adam Di Carlo <a.p.dicarlo@gmail.com>
To:     Sean Young <sean@mess.org>
Cc:     linux-media@vger.kernel.org
Subject: Re: ir-keytable known bug -- fails to work when device specified
References: <8736njzpep.fsf@gw.coo>
        <20190319101217.6uictrbyhyednzxj@gofer.mess.org>
Date:   Tue, 19 Mar 2019 20:14:45 -0400
In-Reply-To: <20190319101217.6uictrbyhyednzxj@gofer.mess.org> (Sean Young's
        message of "Tue, 19 Mar 2019 10:12:17 +0000")
Message-ID: <87imwexuyy.fsf@gw.coo>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Sean Young <sean@mess.org> writes:
> Adam wrote:
>> Rather than document all this, isn't better to clean it up in the
>> source?  I can probably come up with a patch for this issue in fairly
>> short order, if that's welcome.
>
> You're right, this is broken. For this to work it would have to get all
> the details for the all the rc devices and find the one that has an
> input device with that name.
>
> That command line above implies that the protocol is a property of the
> input device which it is not. Actually I think the whole -d option is
> misleading and not really useful. I think the right solution is to just
> remove it completely.

Ok, the patch looks good, I definately think this is a step in the right
direction.

In cases where there is multiple devices, one would select it with, for
instance, '-s rc1' -- is that the intent?

-- 
...Adam Di Carlo...<a.p.dicarlo@gmail.com>............................
