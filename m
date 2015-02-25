Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34502 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbbBYVoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 16:44:12 -0500
Received: by pabrd3 with SMTP id rd3so8413127pab.1
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 13:44:12 -0800 (PST)
Message-ID: <54EE422A.8050408@gmail.com>
Date: Wed, 25 Feb 2015 13:44:10 -0800
From: Steve Longerbeam <slongerbeam@gmail.com>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 Video combiner
References: <CAL8zT=g2uUDQYgfNW5017YCKjfxBz7Oj+9FSvdo4PXZgiOAKWQ@mail.gmail.com> <54EE086B.9020904@gmail.com> <54EE0C55.2020501@gmail.com> <CAL8zT=jNnHp-ngX01Se8cc+LUtRmr4+-NwVbFAY4hZpuKuB4Rg@mail.gmail.com>
In-Reply-To: <CAL8zT=jNnHp-ngX01Se8cc+LUtRmr4+-NwVbFAY4hZpuKuB4Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/2015 11:40 AM, Jean-Michel Hautbois wrote:
> Hi Steve,
>
> 2015-02-25 18:54 GMT+01:00 Steve Longerbeam <slongerbeam@gmail.com>:
>> On 02/25/2015 09:37 AM, Steve Longerbeam wrote:
>>> On 02/25/2015 02:57 AM, Jean-Michel Hautbois wrote:
>>>> Hi all,
>>>>
>>>> I read in the i.MX6 TRM that it can do combining or deinterlacing with VDIC.
>>>> Has it been tested by anyone ?
>>>> Could it be a driver, which would allow to do some simple compositing
>>>> of souces ?
>>>>
>>>> Thanks,
>>>> JM
>>> I've added VDIC support (deinterlace with motion compensation) to the
>>> capture driver, it's in the my media tree clone:
>>>
>>> git@github.com:slongerbeam/mediatree.git, mx6-media-staging
>> it is activated if user sets the motion compensation control to
>> 1 (low motion), 2 (medium motion), or 3 (high motion), for
>> example:
>>
>> # v4l2-ctl --set-ctrl=motion_compensation=2
> Thx for the tip :).
> And in fact, it is "only" deinterlacing, not combining two planes with
> background as specified in the TRM (or did I miss something ?).

Hi JM, yes it is deinterlace only, the combiner in the VDIC is not
being used.

Steve

