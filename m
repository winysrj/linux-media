Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1LZCAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 21:00:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1Rezrq-0000Bl-BW
	for linux-media@vger.kernel.org; Mon, 26 Dec 2011 02:00:46 +0000
Received: by dajs34 with SMTP id s34so6710315daj.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 18:00:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF23455.10002@gmail.com>
References: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>
	<20111214153407.GN1967@valkosipuli.localdomain>
	<CACVXFVNrEamdXq6qS98U-T6JiPMVNMHMW9j9prD1wz=SOfOyyA@mail.gmail.com>
	<4EF23455.10002@gmail.com>
Date: Mon, 26 Dec 2011 10:00:44 +0800
Message-ID: <CACVXFVNAsQ7BmkzE1t2bUHz6WJeZeKnwJOhj+GQAH0rbyFCKyA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
From: Ming Lei <ming.lei@canonical.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thu, Dec 22, 2011 at 3:32 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:

>>> How is face detection enabled or disabled?
>>
>> Currently, streaming on will trigger detection enabling, and streaming off
>> will trigger detection disabling.
>
> We would need to develop a boolean control for this I think, this seems one of
> the basic features for the configuration interface.

Yes, it is another way to do it, but considered that for the current two use
cases(detect objects on user space image or video, detect objects on
video stream from internal SoC bus), it is implicit that the video device
should have stream capability, so I think it is still OK to do it via
streaming on
and streaming off interface.

>>
>> Could you let me know how to do it?
>
> You would have to use multi-planar interface for that, which would introduce
> additional complexity at user interface. Moreover variable plane count is not
> supported in vb2. Relatively significant effort is required to add this IMHO.

So the the introduced two IOCTLs are good to do it, right?

Sylwester, could you help to review the v2 patches if you are available?

thanks,
--
Ming Lei
