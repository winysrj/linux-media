Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:32998 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757065AbdDQI6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 04:58:02 -0400
Received: by mail-pg0-f65.google.com with SMTP id 63so12621275pgh.0
        for <linux-media@vger.kernel.org>; Mon, 17 Apr 2017 01:58:02 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg KH <greg@kroah.com>
Cc: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: uvcvideo logging kernel warnings on device disconnect
In-Reply-To: <8113252.R6OEHK1FMB@avalon>
References: <ab3241e7-c525-d855-ecb6-ba04dbdb030f@destevenson.freeserve.co.uk> <01726e81-bbc2-b9a0-b2f0-045e3208f7b2@destevenson.freeserve.co.uk> <20161221095954.GG27395@kroah.com> <8113252.R6OEHK1FMB@avalon>
Date: Mon, 17 Apr 2017 18:57:57 +1000
Message-ID: <87r30rv2ay.fsf@possimpible.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>> > I hate to pester, but wondered if you had found anything obvious.
>> > I really do appreciate you taking the time to look.
>> 
>> Sorry, I haven't had the chance and now will not be able to until
>> January....
>
> Did you mean January 2017 or 2018 ? :-)

I stumbled across this problem independently, and with the help of some
of the info on this thread (especially yavta), I have what I think is a
solution: https://patchwork.kernel.org/patch/9683663/

Regards,
Daniel
