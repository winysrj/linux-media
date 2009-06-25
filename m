Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55082 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZFYSiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 14:38:10 -0400
Received: by ewy6 with SMTP id 6so2573772ewy.37
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 11:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	 <829197380906251125t56fe49ccqee97eab659be9974@mail.gmail.com>
Date: Thu, 25 Jun 2009 14:38:12 -0400
Message-ID: <37219a840906251138n4f101500o6c3833272a6b92@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2009 at 2:25 PM, Devin
Heitmueller<dheitmueller@kernellabs.com> wrote:
> Hans,
>
> I just spoke with mkrufky, and he confirmed the issue does occur with
> the HVR-950.  However, the em28xx driver does not do a printk() when
> the subdev registration fails (I will submit a patch to fix that).
>
> Please let me know if you have any further question.
>
> Thanks for your assistance,

I'd like to add:

Testing against 2.6.24.7: v4l subdev registration fails.
Testing against 2.6.25.20: v4l subdev registration fails.
...
Testing against 2.6.26.8: success!
Testing against 2.6.27.25: success!
Testing against 2.6.28.10: success!
... (I didn't bother testing 2.6.29.y)
Testing against 2.6.30: success!

Regards,

Mike
