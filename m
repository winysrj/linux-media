Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40740 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2GNWiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 18:38:08 -0400
Received: by obbuo13 with SMTP id uo13so7039692obb.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2012 15:38:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c8d61d57-0582-455b-9e24-7f1c5e6049c7@email.android.com>
References: <CALzAhNVDnyjwNqcWDcgv2kgQ97Hr0gArk8=V_mL62J0cD0Ydag@mail.gmail.com>
	<c8d61d57-0582-455b-9e24-7f1c5e6049c7@email.android.com>
Date: Sat, 14 Jul 2012 18:38:07 -0400
Message-ID: <CALzAhNX9s9Hyqb9gX7fH2tkTwTqf8_Bs-doTT_Ro7EaiK3+pew@mail.gmail.com>
Subject: Re: staging/for_v3.6 is currently broken
From: Steven Toth <stoth@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Chehab <mchehab@infradead.org>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 14, 2012 at 6:36 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Steven Toth <stoth@kernellabs.com> wrote:
>
>>Looks like the new union in v4l2_ioctl_info breaks things.
>
> I think Hans fixed it another way:
>
> http://www.spinics.net/lists/linux-media/msg50234.html

Thanks Andy.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
