Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40023 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab2BXS6j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 13:58:39 -0500
Received: by obcva7 with SMTP id va7so3176361obc.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 10:58:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120224183950.GC3649@mwanda>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
	<1330097062-31663-5-git-send-email-elezegarcia@gmail.com>
	<20120224183950.GC3649@mwanda>
Date: Fri, 24 Feb 2012 15:58:39 -0300
Message-ID: <CALF0-+WyT_+GGFhGkB0M9xbUYQjGz6E1PzzykYBj_wRG=hFc1Q@mail.gmail.com>
Subject: Re: [PATCH 5/9] staging: easycap: Push video registration to easycap_register_video()
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, tomas.winkler@intel.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Fri, Feb 24, 2012 at 3:39 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Feb 24, 2012 at 12:24:18PM -0300, Ezequiel Garcia wrote:
>> +             rc = easycap_register_video(peasycap);
>> +             if (rc < 0)
>>                       return -ENODEV;
>
> Don't resend.  These are beautiful patches you are sending and I
> wouldn't want to slow you down.  But it would have been better to
> return rc here.

Ok, I'll do that in the future. Thanks for the feedback, and feel free
to keep it coming :)
Thanks for taking the time to review.

I have to say I'm thrilled with having time (and knowledge) to work on
the linux kernel.
It was 12 years ago when I first installed a linux distro and I had no
idea what to do with it
back then! ;)
