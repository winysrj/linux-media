Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:37421 "EHLO
        homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbeELWqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 18:46:12 -0400
Subject: Re: [PATCH 5/7] Header location fix for 3.5.0 to 3.11.x
To: "Jasmin J." <jasmin@anw.at>, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-6-git-send-email-brad@nextdimension.cc>
 <4ae5be5c-167e-bf3b-4849-8958552f8d05@anw.at>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <16264dca-f0c2-a699-c7ff-f392ce8751f4@nextdimension.cc>
Date: Sat, 12 May 2018 17:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <4ae5be5c-167e-bf3b-4849-8958552f8d05@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 2018-05-12 14:42, Jasmin J. wrote:
> Hello Brad!
>
> This patch added the inclusion of "linux/of_i2c.h".
> This gave the warnings in the last nightly build for Kernel
> 3.6 - 3.9.
>
> I just pushed a fix for that, so we should have an OK build this
> night.
>
> BR,
>    Jasmin

Thanks for the fix Jasmin. Are the build logs public?

Cheers,

Brad
