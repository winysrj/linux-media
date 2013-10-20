Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38740 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3JTRrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Oct 2013 13:47:15 -0400
Received: by mail-lb0-f174.google.com with SMTP id w6so4679827lbh.19
        for <linux-media@vger.kernel.org>; Sun, 20 Oct 2013 10:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382202581.2405.5.camel@palomino.walls.org>
References: <CAFoaQoAK85BVE=eJG+JPrUT5wffnx4hD2N_xeG6cGbs-Vw6xOg@mail.gmail.com>
	<1381371651.1889.21.camel@palomino.walls.org>
	<CAFoaQoBiLUK=XeuW31RcSeaGaX3VB6LmAYdT9BoLsz9wxReYHQ@mail.gmail.com>
	<1381620192.22245.18.camel@palomino.walls.org>
	<1381668541.2209.14.camel@palomino.walls.org>
	<CAFoaQoAaGhDycKfGhD2m-OSsbhxtxjbbWfj5uidJ0zMpEWQNtw@mail.gmail.com>
	<1381707800.1875.63.camel@palomino.walls.org>
	<CAFoaQoAjjj=nxKwWET9a5oe1JeziOz40Uc54v4hg_QB-FU-7xw@mail.gmail.com>
	<1382202581.2405.5.camel@palomino.walls.org>
Date: Sun, 20 Oct 2013 18:47:13 +0100
Message-ID: <CAFoaQoCL_W6oAuf3at5qWB5uZmW93w1H9bAdFs-h0LoPQOiuvw@mail.gmail.com>
Subject: Re: ivtv 1.4.2/1.4.3 broken in recent kernels?
From: Rajil Saraswat <rajil.s@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 October 2013 18:09, Andy Walls <awalls@md.metrocast.net> wrote:
> On Wed, 2013-10-16 at 01:10 +0100, Rajil Saraswat wrote:
>> I was finally able to carry out a git bisect. Had to do a git pull on
>> a fast internet hooked machine and ftp the files over to the remote
>> machine.
>>
>> I started with 'git bisect bad v2.6.36.4' and 'git bisect good v2.6.35.10'.
>>
>> And the result was:
>>
>> 5aa9ae5ed5d449a85fbf7aac3d1fdc241c542a79 is the first bad commit
>> commit 5aa9ae5ed5d449a85fbf7aac3d1fdc241c542a79
>> Author: Hans Verkuil <hverkuil@xs4all.nl>
>> Date:   Sat Apr 24 08:23:53 2010 -0300
>>
>>     V4L/DVB: wm8775: convert to the new control framework
>>
>>     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> :040000 040000 37847ffe592f255c6a9d9daedaf7bbfd3cd7b055
>> 2f094df6f65d7fb296657619c1ad6f93fe085a75 M    drivers
>>
>> I then removed the patch from linux-2.6.36-gentoo-r8 which are gentoo
>> sources, and confirmed that video/audio now works fine on v4l2-ctl -d
>> /dev/video1 --set-input 4
>>
>> I wasnt able to remove the patch in 3.10.7 which is gentoo stable
>> kernel. Any idea how can i do that?
>
> Try applying the following (untested) patch that is made against the
> bleeding edge Linux kernel.  The test on the mute control state in
> wm8775_s_routing() appears to have been inverted in the bad commit you
> isolated.
>
> Along with '--set-input', you may also want to use v4l2-ctl to exercise
> the mute control as well, to see if it works as expected, once this
> patch is applied.
>
> Regards,
> Andy
>
> file: wm8775_s_route_mute_test_inverted.patch
>
> diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
> index 3f584a7..bee7946 100644
> --- a/drivers/media/i2c/wm8775.c
> +++ b/drivers/media/i2c/wm8775.c
> @@ -130,12 +130,10 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
>                 return -EINVAL;
>         }
>         state->input = input;
> -       if (!v4l2_ctrl_g_ctrl(state->mute))
> +       if (v4l2_ctrl_g_ctrl(state->mute))
>                 return 0;
>         if (!v4l2_ctrl_g_ctrl(state->vol))
>                 return 0;
> -       if (!v4l2_ctrl_g_ctrl(state->bal))
> -               return 0;
>         wm8775_set_audio(sd, 1);
>         return 0;
>  }
>
>

Thanks for the patch. Unfortunately, my htpc has been kicked off the
network when the attached TV died. It will take me few weeks to get it
up again. But I will try this patch when things are back normal and
report back.

-Rajil
