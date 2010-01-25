Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:25715 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0AYQ0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 11:26:38 -0500
Received: by gv-out-0910.google.com with SMTP id n8so164216gve.37
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 08:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1001251041510.14128@banach.math.auburn.edu>
References: <4B5DB387.70707@redhat.com>
	 <alpine.LNX.2.00.1001251041510.14128@banach.math.auburn.edu>
Date: Mon, 25 Jan 2010 11:26:36 -0500
Message-ID: <829197381001250826t50e11fdbu7007e82aeaa129c9@mail.gmail.com>
Subject: Re: Problems with cx18
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 11:45 AM, Theodore Kilgore
<kilgota@banach.math.auburn.edu> wrote:
>
>
> On Mon, 25 Jan 2010, Mauro Carvalho Chehab wrote:
>
>> Hi Devin/Andy/Jean,
>
> <snip>
>
>> The sq905c has a warning.
>
> <snip>
>
>> drivers/media/video/gspca/sq905c.c: In function ?sd_config?:
>> drivers/media/video/gspca/sq905c.c:207: warning: unused variable ?i?
>
> <snip>
>
>> Please fix.
>>
>> Cheers,
>> Mauro.
>
> This one has been fixed, already. A more recent version of sq905c.c is in
> the pipeline somewhere.
>
> Theodore Kilgore

Not intending to hijack this thread, but maybe it would be a good idea
for Hans's nightly rig to do a build with module support disabled on
at least one platform.  I'm not saying we should do it on all
platforms, but if we at least run it on x86 then we would spot this
class of issue earlier.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
