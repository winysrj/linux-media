Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38190 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbcKVHd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 02:33:56 -0500
Received: by mail-wm0-f41.google.com with SMTP id f82so9500800wmf.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2016 23:33:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161120132948.GA23247@gofer.mess.org>
References: <20161116105256.GA9998@shambles.local> <20161117134526.GA8485@gofer.mess.org>
 <20161118121422.GA1986@shambles.local> <20161118174034.GA6167@gofer.mess.org>
 <20161118220107.GA3510@shambles.local> <20161120132948.GA23247@gofer.mess.org>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Tue, 22 Nov 2016 18:25:59 +1100
Message-ID: <CAEsFdVNAGexZJSQb6dABq1uXs3wLP+kKsKw-XEUXd4nb_3yf=A@mail.gmail.com>
Subject: Re: ir-keytable: infinite loops, segfaults
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/16, Sean Young <sean@mess.org> wrote:
>>
>> Ah. Here we have a problem. The device (/dev/input/event15)
>> doesn't have a corresponding rcX node, see ir-keytable output below.
>> I had it explained to me like this:
>
> As I said you would need to use a raw IR receiver which has rc-core support
> to determine the protocol, so never mind. Please can you try this patch:
>
> I don't have the hardware to test this so your input would be appreciated.
>

Thanks for this. I have got it to build within the media_build setup
but will need to find some windows in the schedule for testing. More
in a couple of days. Are there specific things you would like me to
test?

Vince
