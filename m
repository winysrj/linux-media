Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43379 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0GKODo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jul 2010 10:03:44 -0400
Received: by eya25 with SMTP id 25so438835eya.19
        for <linux-media@vger.kernel.org>; Sun, 11 Jul 2010 07:03:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278854614.2283.8.camel@localhost>
References: <AANLkTikYq6w4ELQntkKMF-PuB1JkO7Eu6kx5XqxSAnU6@mail.gmail.com>
	<1278854614.2283.8.camel@localhost>
Date: Sun, 11 Jul 2010 10:03:42 -0400
Message-ID: <AANLkTimLiBLh2Z3TsfozzxLMVc_zxyzQdEGhR-Ct57Nw@mail.gmail.com>
Subject: Re: RFC: Use of s_std calling s_freq when tuner powered down
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, Jul 11, 2010 at 9:23 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> At the risk of missing something obvious:
>
> In your bridge driver's VIDIOC_S_STD ioctl()
>
> a. power up the analog tuner if it is not already
> b. call s_std for the subdevices (including the tuner),
> c. power down that analog tuner if not using the tuner input.
>
> No I2C errors in the log and the tuner is powered down when not in use,
>
> IMO, VIDIOC_S_STD is not a timing critical operation from userspace and
> it doesn't happen that often.  You can also filter the cases when
> VIDIOC_S_STD is called on the same input, but the standard is not being
> changed.

Thanks for taking the time to provide feedback.

It's not timing critical, but on some tuners initialization can take
several seconds (e.g. tda18271, xc5000).  I'm not thrilled about it
taking 3-5 seconds to change the standard (something which some
applications may very well do on every channel change).

I'm tempted to just jam a zero into the tuner->tv_freq when powering
down the tuner, but that's not a very clean solution obviously.

The tuner core makes decisions based on tuner->tv_freq not being zero,
so I believe tuner_core should provide some way to reset it back to
zero as needed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
