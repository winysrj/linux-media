Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:36922 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935473Ab3DHMDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 08:03:06 -0400
Received: by mail-vc0-f182.google.com with SMTP id ht11so4834598vcb.13
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 05:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 08:03:05 -0400
Message-ID: <CAC-25o9A3e2j+cwADcYb19rG3-2pMC5uj7JaBkQ6dCnF+trLJQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 0/7] radio-si4713: driver overhaul
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,



On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This patch series makes radio-si4713 compliant with v4l2-compliance.
>

Thanks for your patches.

> Eduardo, thanks for testing the previous code. I hope this version resolves
> all the issues we found. Can you test again?
>

Of course, I will take some time to review and test them for you.

> This code is also available here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713b
>
> Make sure you also update v4l2-compliance: I found a bug in the way RDS
> capabilities were tested.

OK. sure.

>
> Regards,
>
>         Hans
>



-- 
Eduardo Bezerra Valentin
