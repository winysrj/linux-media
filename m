Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFCEC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 06:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A03420883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 06:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="BuiG6kNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfAIGsG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 01:48:06 -0500
Received: from mail-it1-f174.google.com ([209.85.166.174]:40839 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728661AbfAIGsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 01:48:06 -0500
Received: by mail-it1-f174.google.com with SMTP id h193so9531421ita.5
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 22:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oERoLlFMZkjVgjgm3NfUjVN8pEGdi3f5UyNgrr2HBts=;
        b=BuiG6kNKh/+SmGf/amkH7fH6yviVV0RW7uMfGXLKMpqDSUncCgWcwiRyTKH5tsb6P/
         FsV376ylCBXSVo3lxF6MYrwSqgpZ8aX7ntWC/gggny2Sgt9ml9uOSrtbAbJkMgfIDkwT
         eRbX1Ldi3zIYRGmI7NkB6Wk4jwO8VB3xDocQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oERoLlFMZkjVgjgm3NfUjVN8pEGdi3f5UyNgrr2HBts=;
        b=IGqm0D+GO9BgKXB31VpGl/e9/t+AqmFIJRuA1DAx2qXhgQo4CbUdkqphSQ5c6n7KkR
         dgl75PLUe1kLt/8OfXPTyDhvAKMhWp8YPeJDbQgFlSye6JFjG4O+98FVVo91/7kmwxWF
         Ahx0a8P3lUgx3rssH1+VsOCk2EUY3qGLxnE9TGRhosDDkpTNrNV9MXB7KDeGwiIXeWIr
         NYLDsQFEJtwfANxchLyFH9ph4BIcAnIA1UsuViNdfxFrFlklMO3JHb7kETKAUu7CQmkf
         xUJJDkOIOcGku4Ga9eylq3dQ2MEovZm/P7x5SQ1gfvkL+xDUJAgk76psMMq8+ftu1Aoj
         B7BA==
X-Gm-Message-State: AJcUukedajSaX0YURP5Ow4T3MyZkBPtXq5mIv4gX2m8LxqGXDj61n2jV
        BcZEuLcoOOQGS/aoMwO0J21TyWYMZHIzbnJoml78TIPqWUY=
X-Google-Smtp-Source: ALg8bN7F2OLPljZsDsow+zAAareZlnxg93/qPZHTpwtRmQnJfaKXBpBqQgM9QKu+XW7Z0xhFQaHwz+x1jQUgyj3SSCg=
X-Received: by 2002:a24:a141:: with SMTP id n1mr3452402iti.31.1547016485701;
 Tue, 08 Jan 2019 22:48:05 -0800 (PST)
MIME-Version: 1.0
References: <SN6PR12MB28138BF9EDDB2256E2889B68B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
 <SN6PR12MB2813CB952B0F063DBC057528B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
In-Reply-To: <SN6PR12MB2813CB952B0F063DBC057528B38B0@SN6PR12MB2813.namprd12.prod.outlook.com>
From:   Matt Ranostay <matt.ranostay@konsulko.com>
Date:   Tue, 8 Jan 2019 22:47:54 -0800
Message-ID: <CAJCx=gkjDL4O39m8yiodLrJoeOwjQEftk1-TEECVvNGVvd8zQw@mail.gmail.com>
Subject: Re: unsubscribe linux-media
To:     Bhanu Murthy V <bmurthyv@nvidia.com>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

You should direct this message to majordomo@vger.kernel.org  :)

On Tue, Jan 8, 2019 at 4:36 PM Bhanu Murthy V <bmurthyv@nvidia.com> wrote:
>
> unsubscribe linux-media
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------
