Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1143 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZFYNoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 09:44:18 -0400
Message-ID: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
Date: Thu, 25 Jun 2009 15:43:59 +0200 (CEST)
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick -
     what  am I doing wrong?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "George Adams" <g_adams27@hotmail.com>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, Jun 25, 2009 at 1:17 AM, George Adams<g_adams27@hotmail.com>
> wrote:
>>
>> Hello!  In a last ditch effort, I decided to try downloading a v4l
>> driver snapshot from February back when I had my Pinnacle HD Pro Stick
>> device working.  To my amazement, the old drivers worked!
>>
>> By process of elimination (trying newer and newer drivers until my
>> Pinnacle device was once again not recognized), it appears that
>> changeset 11331 (http://linuxtv.org/hg/v4l-dvb/rev/00525b115901), from
>> Mar. 31 2009, is the first one that causes my device to not be
>> recognized.  This is the changeset that updated the em28xx driver from
>> 0.1.1 to 0.1.2.  Here, again, is the dmesg output from a newer driver
>> that does NOT work (this one from a driver set one day later, on Apr. 1,
>> 2009):
>
> Interesting.  What distro and version of the kernel are you running?
>
> Yesterday Michael Krufky pointed out to me that the v4l subdev
> registration is broken for the au0828 driver when using the current
> tip against Ubuntu Hardy (2.6.24), so it now seems likely that it's
> the exact same issue.
>
> Thanks for taking the time to narrow down the actual change that
> caused the issue.
>
> I guess somebody is going to have to build a box with Hardy and debug
> this issue.  :-/

Hmm, I have Hardy on my laptop at work so I can test this tomorrow with my
USB stick. It's a Hauppauge HVR<something>, but it does have a tvp5150. So
it should be close enough.

Regards,

       Hans

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

