Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38555 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3DYUhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 16:37:23 -0400
Received: by mail-ea0-f174.google.com with SMTP id g14so11794eak.33
        for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 13:37:22 -0700 (PDT)
Message-ID: <517993FE.8050608@gmail.com>
Date: Thu, 25 Apr 2013 22:37:18 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com> <1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com> <51688A85.8080206@gmail.com> <CAHG8p1B2meHySHWnQ6JAhDA+2Cgfyc=JHcAG8eY9GhcpN7B5iA@mail.gmail.com>
In-Reply-To: <CAHG8p1B2meHySHWnQ6JAhDA+2Cgfyc=JHcAG8eY9GhcpN7B5iA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On 04/24/2013 11:26 AM, Scott Jiang wrote:
>>
>>> +       struct v4l2_device v4l2_dev;
>>> +       /* v4l2 control handler */
>>> +       struct v4l2_ctrl_handler ctrl_handler;
>>
>>
>> This handler seems to be unused, I couldn't find any code adding controls
>> to it. Any initialization of this handler is a dead code now. You probably
>> want to move that bits to a patch actually adding any controls.
>>
>
> This host driver doesn't support any control but without it subdev
> controls can't be accessed.
> v4l2_ctrl_add_handler should just return 0 if v4l2_dev->ctrl_handler is NULL.

You're right, I missed the point that a video device could expose just 
controls
inherited from subdevs. And for that its control handler need to be 
initialized.
So I didn't help you too much with that comment, please just ignore it.

Regards,
Sylwester
