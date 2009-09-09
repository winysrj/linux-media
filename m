Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39947 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZIITkN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 15:40:13 -0400
Received: by ewy2 with SMTP id 2so4030823ewy.17
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 12:40:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380909091209x382089beqe805bf2b0895a67f@mail.gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
	 <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
	 <d9def9db0909091202x64b54600s4c499f0f4042a8e6@mail.gmail.com>
	 <829197380909091209x382089beqe805bf2b0895a67f@mail.gmail.com>
Date: Wed, 9 Sep 2009 21:40:15 +0200
Message-ID: <d9def9db0909091240l43c71dccke6877648d5076950@mail.gmail.com>
Subject: Re: Invalid module format
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Edouard Marquez <animatrix30@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 9:09 PM, Devin
Heitmueller<dheitmueller@kernellabs.com> wrote:
> On Wed, Sep 9, 2009 at 3:02 PM, Markus Rechberger<mrechberger@gmail.com> wrote:
>> this is not true my old driver which is not available anymore did not
>> ship any other modules aside the em28xx driver itself.
>> This is a video4linux issue and has nothing to do with it.
>>
>> Best Regards,
>> Markus
>>
>
> Hello Marks,
>
> While it is true that your driver did not include anything other than
> em28xx, I assume it is compiled against a certain set of v4l2 headers,
> and if those headers change (such as changes to data structures), then
> the em28xx modules you distributed would not work with that version of
> the v4l2 modules.

I stopped the work at around Oct last year, 2.6.27 is the latest
kernel which is supposed to be supported with it.
Although since there are some bad bugs in it which I've been told by
the manufacturer afterwards I do not recommend
to use it either it shortens the lifetime of most devices... Best is
to stick with windows unless the manufacturer and
chipdesigners support a driver.

WARNING: Error inserting videobuf_core (/lib/modules/2.6.30-tuxonice-
r5/kernel/drivers/media/video/videobuf-core.ko): Invalid module format

this is something that cannot be caused by the em28xx work, it's any
other messy issue
with the v4l2 kernel API.

Markus

> If he wants to use your driver, I would assume he would need to
> reinstall the stock kernel (overwriting whatever locally built version
> of v4l-dvb he previously installed).
>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
