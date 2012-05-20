Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48636 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2ETXKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 19:10:50 -0400
Received: by obbtb18 with SMTP id tb18so7259679obb.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 16:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com>
References: <4FB95A3B.9070800@iki.fi>
	<CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com>
Date: Sun, 20 May 2012 19:10:49 -0400
Message-ID: <CAGoCfiz_LpOet3qDpW1H6M=1oEdzKGuXVd6zD_ZprNKkZQgs+g@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: VDR User <user.vdr@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 20, 2012 at 6:30 PM, VDR User <user.vdr@gmail.com> wrote:
> On Sun, May 20, 2012 at 1:55 PM, Antti Palosaari <crope@iki.fi> wrote:
>> I did some more planning and made alternative RFC.
>> As the earlier alternative was more like changing old functionality that new
>> one goes much more deeper.
>
>> Functionality enhancement mentioned earlier RFC are valid too:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg46352.html
>
> One thing I didn't see mentioned in your post or the one your linked
> is the rc dependency for _all_ usb devices, whether they even have rc
> capability or not. It makes sense that is dvb usb is going to get
> overhauled, that rc functionality be at the very least optional rather
> than forced it on all usb devices.

If you think this is important, then you should feel free to submit
patches to Antti's tree.  Otherwise, this is the sort of optimization
that brings so little value as to not really be worth the engineering
effort.  The time is better spent working on problems that *actually*
have a visible effect to users (and a few extra modules being loaded
does not fall into this category).

I think you'll find after spending a few hours trying to abstract out
the logic and the ugly solution that results that it *really* isn't
worth it.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
