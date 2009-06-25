Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:37869 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZFYOAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 10:00:03 -0400
Received: by gxk22 with SMTP id 22so772392gxk.13
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 07:00:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
Date: Thu, 25 Jun 2009 10:00:05 -0400
Message-ID: <829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: George Adams <g_adams27@hotmail.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2009 at 9:43 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> Hmm, I have Hardy on my laptop at work so I can test this tomorrow with my
> USB stick. It's a Hauppauge HVR<something>, but it does have a tvp5150. So
> it should be close enough.
>
> Regards,
>
>       Hans

Hans,

Oh thank goodness.  I was really hoping you would volunteer since you
are clearly the best candidate for debugging subdev issues.  It took
me two days to debug my last issue with v4l2_subdev registration and
it required me to recompile the distro's kernel from source to debug
the i2c stack.

If you've got an em28xx device with the tvp5150, then it's probably an
HVR-950, which is almost identical to the Pinnacle 800e.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
