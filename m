Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59150 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab3JOKuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 06:50:23 -0400
Received: by mail-ie0-f180.google.com with SMTP id e14so9641057iej.39
        for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 03:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKnK8-T-Ac1-bWL_0Sr4bvg7wWErrTXP-mb7RH-DvftWZ41CAA@mail.gmail.com>
References: <CAKnK8-T-Ac1-bWL_0Sr4bvg7wWErrTXP-mb7RH-DvftWZ41CAA@mail.gmail.com>
Date: Tue, 15 Oct 2013 12:50:22 +0200
Message-ID: <CA+MoWDoEBZr9TYWypSDj4ObOdWR902p1ehAabjRCBzTDJQyDkw@mail.gmail.com>
Subject: Re: Submitting kernel module device driver
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: =?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4=?= <bud@are.ma>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 15, 2013 at 4:56 AM, Буди Романто <bud@are.ma> wrote:
> Hello
> I've developed a DVB device driver for Earthsoft PT3 (PCIE) card
>
> & want to ask where/how to submit it.
Usually drivers are sent in a list of incremental patches, but this is
not a rule. After sending the first version, there should be reviews
and comments on the patches.

There are some general information at:
http://linuxtv.org/wiki/index.php/Development:_Submitting_Drivers

And one example:
http://lwn.net/Articles/500201/


> Thanks for your help
> -Bud
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Peter
