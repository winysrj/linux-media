Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52019 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZIJRY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 13:24:58 -0400
Received: by bwz19 with SMTP id 19so257175bwz.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:25:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909101912.22933.hverkuil@xs4all.nl>
References: <200909080837.31989.hverkuil@xs4all.nl>
	 <829197380909080641q3ff2cd15r6150d36f2a4ee809@mail.gmail.com>
	 <200909101912.22933.hverkuil@xs4all.nl>
Date: Thu, 10 Sep 2009 13:24:59 -0400
Message-ID: <829197380909101024v4a1955a1v3e64756e53e67216@mail.gmail.com>
Subject: Re: Volunteer for V4L2+Audio at Plumbers Conference?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 1:12 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> Devin,
>
> If we have a media controller framework, then we might be able to use that as
> an alternative way to get timestamps. See note 4 at the end of the RFC that
> I posted today. If it turns out that there is no decent way of handling this
> in alsa, then we have at least a way out.
>
> Regards,
>
>        Hans

Hello Hans,

I was starting to give such an idea some thought.  My concern with
such an approach would be the latency between the ioctl and the read()
operation.  Admittedly, I'm not sure though what alternative we have
if we cannot provide the data in-band.  One thought I had was to treat
the timestamp functionality as some sort of "advanced capability" not
available with the read/write interface, but that obviously doesn't
solve the ALSA problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
