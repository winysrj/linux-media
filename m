Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54386 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1ANMJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 07:09:06 -0500
Received: by ywl5 with SMTP id 5so835032ywl.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 04:09:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2EF36B.8050007@redhat.com>
References: <AANLkTin6g15UzWuN8XHRUwwGUPWpSnWwVAU1GxvXCcNz@mail.gmail.com>
	<4D2EF36B.8050007@redhat.com>
Date: Fri, 14 Jan 2011 23:09:04 +1100
Message-ID: <AANLkTikz=zss1KKBRmM=8mjg6va1NEwD-nD-01PBXzQG@mail.gmail.com>
Subject: Re: [patch] addition to v2.6.35_i2c_new_probed_device.patch (was: Re:
 Debug code in HG repositories)
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 1/13/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

>> This seems to be a relatively simple patch, inline below.
>> This is against the linux-media tree,  I could not figure out how
>> to turn it into a clean patch of
>> media_build/backports/v2.6.35_i2c_new_probed_device.patch
>> I did look for guidance on how to do this in
>> media_build/README.patches  but could not find anything that looked
>> relevant.
>
> Well, there are two ways for doing it:
>

Thanks for your explanation. I was quite puzzled for some time why I
could not find the commit id in the git log, now I understand why.


>> The code now compiles for me but I don't know if it will actually
>> work, I don't have the hardware.
>
> Ok, I did the above procedure, adding your patch to the diff. Please test.
>

That bit works now (from git, the tarball downloaded by build.sh
hasn't caught up).
Thanks for applying.

However the build now fails on a separate issue, which I'll put in a new thread.

Cheers
Vince
