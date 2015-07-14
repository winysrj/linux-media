Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:36365 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbGNXyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 19:54:39 -0400
Received: by ykay190 with SMTP id y190so22458653yka.3
        for <linux-media@vger.kernel.org>; Tue, 14 Jul 2015 16:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFP0Ok97sA5bOVczsy_zmr5v+rqxKKMzRX8Ed8yK1U3MQVyRNg@mail.gmail.com>
References: <CAFP0Ok97sA5bOVczsy_zmr5v+rqxKKMzRX8Ed8yK1U3MQVyRNg@mail.gmail.com>
Date: Tue, 14 Jul 2015 16:54:38 -0700
Message-ID: <CAFP0Ok9xsXwyok+40vDh7Ps8P5DzCZxQ2jGyW6GJkgdY-RwZeg@mail.gmail.com>
Subject: Re: file permissions for a video device
From: karthik poduval <karthik.poduval@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Never mind, it worked after adding the following entry into ueventd.rc.

#camera
/dev/video*               0660   system     camera

On Mon, Jul 13, 2015 at 8:51 PM, karthik poduval
<karthik.poduval@gmail.com> wrote:
> Hi All,
>
> I was working with a USB camera. As soon as I plug it into the host,
> it probes and video device node gets created with the following
> permission.
> # ll /dev/video0
> crw------- root     root      81,   0 2015-07-13 20:39 video0
>
>
> However it grants permissions to only a root user. I need to be able
> to access this device node from a daemon (running in a non root user
> account).
>
> I can ofcourse chmod the devnode, but was wondering if there is a way
> this can be done from the kernel itself ? Is there some place in the
> uvc code which sets the created the devnode file permissions ?
>
> --
> Regards,
> Karthik Poduval



-- 
Regards,
Karthik Poduval
