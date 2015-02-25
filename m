Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34822 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbbBYVtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 16:49:10 -0500
Received: by mail-oi0-f53.google.com with SMTP id u20so5863452oif.12
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 13:49:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EE422A.8050408@gmail.com>
References: <CAL8zT=g2uUDQYgfNW5017YCKjfxBz7Oj+9FSvdo4PXZgiOAKWQ@mail.gmail.com>
 <54EE086B.9020904@gmail.com> <54EE0C55.2020501@gmail.com> <CAL8zT=jNnHp-ngX01Se8cc+LUtRmr4+-NwVbFAY4hZpuKuB4Rg@mail.gmail.com>
 <54EE422A.8050408@gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 25 Feb 2015 22:48:54 +0100
Message-ID: <CAL8zT=jC=8vx=ZY9AuoNu_V-cvQRoJB--ui-0702+LAth4kFWw@mail.gmail.com>
Subject: Re: i.MX6 Video combiner
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-02-25 22:44 GMT+01:00 Steve Longerbeam <slongerbeam@gmail.com>:
> On 02/25/2015 11:40 AM, Jean-Michel Hautbois wrote:
>> Hi Steve,
>>
>> 2015-02-25 18:54 GMT+01:00 Steve Longerbeam <slongerbeam@gmail.com>:
>>> On 02/25/2015 09:37 AM, Steve Longerbeam wrote:
>>>> On 02/25/2015 02:57 AM, Jean-Michel Hautbois wrote:
>>>>> Hi all,
>>>>>
>>>>> I read in the i.MX6 TRM that it can do combining or deinterlacing with VDIC.
>>>>> Has it been tested by anyone ?
>>>>> Could it be a driver, which would allow to do some simple compositing
>>>>> of souces ?
>>>>>
>>>>> Thanks,
>>>>> JM
>>>> I've added VDIC support (deinterlace with motion compensation) to the
>>>> capture driver, it's in the my media tree clone:
>>>>
>>>> git@github.com:slongerbeam/mediatree.git, mx6-media-staging
>>> it is activated if user sets the motion compensation control to
>>> 1 (low motion), 2 (medium motion), or 3 (high motion), for
>>> example:
>>>
>>> # v4l2-ctl --set-ctrl=motion_compensation=2
>> Thx for the tip :).
>> And in fact, it is "only" deinterlacing, not combining two planes with
>> background as specified in the TRM (or did I miss something ?).
>
> Hi JM, yes it is deinterlace only, the combiner in the VDIC is not
> being used.

Well, I don't really know if it would be possible to have it too, and
how difficult it is. Maybe as a m2m device, as it could be driven by
gstreamer for instance and would replace pure software composition
element...
I may need to take some time and look further into this, but if anyone
has tested it, or can give me advices on how it should be done, it can
help (a lot)... :).

Thanks,
JM
