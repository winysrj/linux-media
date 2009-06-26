Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f192.google.com ([209.85.210.192]:49071 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZFZR7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 13:59:03 -0400
Received: by yxe30 with SMTP id 30so4068773yxe.4
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:59:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906261950.27065.hverkuil@xs4all.nl>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	 <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
	 <200906261950.27065.hverkuil@xs4all.nl>
Date: Fri, 26 Jun 2009 13:59:04 -0400
Message-ID: <829197380906261059g68023af3k712c1e135b40edca@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: George Adams <g_adams27@hotmail.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 1:50 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Thursday 25 June 2009 20:25:31 Devin Heitmueller wrote:
>> Hans,
>>
>> I just spoke with mkrufky, and he confirmed the issue does occur with
>> the HVR-950.  However, the em28xx driver does not do a printk() when
>> the subdev registration fails (I will submit a patch to fix that).
>>
>> Please let me know if you have any further question.
>>
>> Thanks for your assistance,
>>
>> Devin
>>
>
> Fixed in my http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-misc tree.
>
> A pull request for this has already been posted, so it should be merged soon
> I hope.
>
> It was a trivial change: originally the new i2c API would be used for kernels
> 2.6.22 and up, until it was discovered that there was a serious bug in the i2c
> core that wasn't fixed until 2.6.26. So I changed it to kernel 2.6.26.
>
> Unfortunately, the em28xx driver was still using 2.6.22 as the cut-off point,
> preventing i2c drivers from being initialized. So em28xx was broken for
> kernels 2.6.22-2.6.25.

Ok, I will submit a comparable fix for au0828.  I guess maybe it makes
sense also to audit all the bridges where we set the .class field to
ensure they all are for 2.6.26.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
