Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53879 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1ACUWC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 15:22:02 -0500
Received: by eye27 with SMTP id 27so6052654eye.19
        for <linux-media@vger.kernel.org>; Mon, 03 Jan 2011 12:22:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com>
References: <AANLkTinPEYyLrTWqt1r0QgoYmsv2Xg16qGKo5yTqu9FO@mail.gmail.com>
	<AANLkTinimPHSRXfWtu+eiv3Y4WZ6PGrbB3sZKBvw2Muy@mail.gmail.com>
	<AANLkTi=AVjhEbsqZOWJbwkYRo+HLoHfdWxuFO7Bs_a7H@mail.gmail.com>
Date: Mon, 3 Jan 2011 15:22:00 -0500
Message-ID: <AANLkTiknspxdjZNZW=h7NWTffzCZ4uEJmADU=tYPZSNe@mail.gmail.com>
Subject: Re: Problem with em28xx driver in Gumstix Overo
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcos Alejandro Saldivia Delgado <marcos.saldivia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Jan 3, 2011 at 3:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> // if (!dev->progressive)
>> // height >>= norm_maxh(dev);

This would suggest that the device is providing progressive video and
there is a mismatch between the board profile and the actual hardware,
which is certainly possible but I know absolutely nothing about the
product in question.

It would be helpful if we could get the output of dmesg for starters,
so we can see which board profile is being used.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
