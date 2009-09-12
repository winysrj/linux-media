Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38228 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZILNl4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 09:41:56 -0400
Received: by bwz19 with SMTP id 19so1288799bwz.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 06:41:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090912103111.7afffb2d@caramujo.chehab.org>
References: <200909120021.48353.hverkuil@xs4all.nl>
	 <20090912103111.7afffb2d@caramujo.chehab.org>
Date: Sat, 12 Sep 2009 09:41:58 -0400
Message-ID: <829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com>
Subject: Re: Media controller: sysfs vs ioctl
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 12, 2009 at 9:31 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> True. Choosing the better approach is very important since, once merged, we'll
> need to stick it for a very long time.
>
> I saw your proposal of a ioctl-only implementation for the media control. It is
> important to have a sysfs implementation also to compare. I can do it.
>
> However, we are currently in the middle of a merge window, and this one will
> require even more time than usual, since we have 2 series of patches for
> soc_camera and for DaVinci/OMAP that depends on arm and omap architecture merge.
>
> Also, there are some pending merges that requires some time to analyze, like
> the ISDB-T/ISDB-S patches and API changes that were proposed for 2.6.32, that
> requiring the analysis of both Japanese and Brazilian specs and do some
> tests, and the tuner changes for better handling the i2c gates, and the V4L and
> DVB specs that we can now merge upstream, as both got converted to DocBook XML
> 4.1.2 (the same version used upstream).
>
> So, during the next two weeks, we'll have enough fun to handle, in order to get
> our patches merged for 2.6.32. So, unfortunately, I'm afraid that we'll need to
> give a break on those discussions until the end of the merge window, focusing
> on merging the patches we have for 2.6.32.
>
>
> Cheers,
> Mauro

Mauro,

I respectfully disagree.  The original version of this RFC has been
pending for almost a year now.  Hans has written a prototype
implementation.  We should strive to get this locked down by the LPC
conference.

I think we all know that you are busy, but this conversation needs to
continue even if you personally do not have the cycles to give it your
full attention.

There is finally some real momentum behind this initiative, and the
lack of this functionality is crippling usability for many, many
users.  "Hi I a new user to tvtime.  I can see analog tv with tvtime,
but how do I make audio work?"

Let's finally put this issue to rest.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
