Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36049 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbHaSHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 14:07:31 -0400
Received: by qkbp67 with SMTP id p67so9196032qkb.3
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2015 11:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55E492B8.4020207@gmail.com>
References: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
	<55E488FF.3040608@a1.net>
	<55E492B8.4020207@gmail.com>
Date: Mon, 31 Aug 2015 14:07:30 -0400
Message-ID: <CAGoCfiyar01CJxgUqoqz6Kix_4V=-jX58r9XTrKd=eE9qDc28A@mail.gmail.com>
Subject: Re: [PATCH] media: dvb-core: Don't force CAN_INVERSION_AUTO in
 oneshot mode.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Johann Klammer <klammerj@a1.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malcolm,

>> The capabilities call interacting with the oneshot setting is rather weird
>> and maybe unexpected.
>>
>>
>
> No, because in normal mode it can do auto inversion.

This isn't my area of expertise, but I suspect this is going to cause
some pretty confusing behavior.  Generally speaking device
capabilities are queried right after the frontend is opened, and the
frontend capabilities typically don't ever change.  In this case, an
application would have to know to check the capabilities a second time
after calling FE_SET_FRONTEND_TUNE_MODE in order to determine whether
auto inversion *really* is available.

If the goal was for the software-emulated auto inversion to be
transparent to userland, perhaps it makes more sense for the oneshot
mode to toggle the inversion if needed.  The oneshot mode would
continue to disable zigzag and the stats monitoring.  I realize that
this is a bit messy since it won't really be "oneshot", but I don't
know what else can be done without breaking the ABI.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
