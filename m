Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38376 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbcCPMxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:53:13 -0400
Received: by mail-ig0-f171.google.com with SMTP id ig19so43374797igb.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 05:53:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Date: Wed, 16 Mar 2016 09:53:12 -0300
Message-ID: <CABxcv=k+MQE7Q+d_g=NgKqgwVqyg9J4LhXhjVyF9kartMt_PJw@mail.gmail.com>
Subject: Re: [PATCH 1/5] [media] media-device: get rid of the spinlock
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Right now, the lock schema for media_device struct is messy,
> since sometimes, it is protected via a spin lock, while, for
> media graph traversal, it is protected by a mutex.
>
> Solve this conflict by always using a mutex.
>
> As a side effect, this prevents a bug where the media notifiers
> were called at atomic context.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---

I agree with the patch.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
