Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34605 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdBOQ2g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 11:28:36 -0500
Received: by mail-oi0-f45.google.com with SMTP id s203so89082353oie.1
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2017 08:28:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL+psHz-rC5xTj-N0ZTv-hTke3OaZx-Cd=nnSMOv6XUuXbj0Zg@mail.gmail.com>
References: <CAL+psHz-rC5xTj-N0ZTv-hTke3OaZx-Cd=nnSMOv6XUuXbj0Zg@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 15 Feb 2017 11:28:35 -0500
Message-ID: <CAGoCfiyLiiew1kGmmo72_7ABvVKrmH8h4jt72zqshmk3FG+AHA@mail.gmail.com>
Subject: Re: [xawtv3] Request: Support for FM RDS
To: George Pojar <geoubuntu@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi George,

The big problem is that almost none of the hardware tuners out there
which support FM have support for RDS.  You generally need an extra
chip, and very few devices have it (IIRC, none of the ones that are
supported in Linux have been available in retail for a number of
years).

Don't get me wrong - I would like to see RDS supported as well - but I
couldn't find a single tuner product shipping in retail that supports
it.

In short, it's a hardware limitation, not a problem with the
linux-media driver stack.

Devin

On Wed, Feb 15, 2017 at 11:07 AM, George Pojar <geoubuntu@gmail.com> wrote:
> FM RDS would be a great feature in radio console application. It would
> be nice to see what the name of the song is that is playing (that is,
> if the station supports RDS).



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
