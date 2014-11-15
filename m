Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38855 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaKOOX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 09:23:29 -0500
Received: by mail-vc0-f181.google.com with SMTP id le20so3150861vcb.40
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 06:23:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54675E45.8020603@xs4all.nl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
	<CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
	<54675E45.8020603@xs4all.nl>
Date: Sat, 15 Nov 2014 18:23:28 +0400
Message-ID: <CAM_ZknWufACKXhe=zimSxZ62y41J6W6GLH8XGVNN3c0HyTi+ig@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	=?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 15, 2014 at 6:08 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Andrey,
>
> On 11/15/2014 02:48 PM, Andrey Utkin wrote:
>> Thanks to all for the great help so far, but I've got another issue
>> with upstream driver.
>>
>> In upstream there's no more module parameter for video standard
>> (NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it turns
>> out not to work correctly: the frame is offset, so that in the bottom
>> there's black horizontal bar.
>> The S_STD ioctl call actually makes difference, because without that
>> the frame "slides" vertically all the time. But after the call the
>> picture is not correct.
>
> That's strange. I know I tested it at the time. I assume it is the PAL
> standard that isn't working (as opposed to NTSC)? Or does it just always
> fail when you switch between the two standards?

Switching to PAL is not working (NTSC is default).
Not sure if it fails to make _any_ switching, or whether it fails to
switch between (hardcoded or switched) PAL to NTSC. I can test it a
bit later.

>>
>> Such change didn't help:
>> https://github.com/krieger-od/linux/commit/55b796c010b622430cb85f5b8d7d14fef6f04fb4
>> So, temporarily, I've hardcoded this for exact customer who uses PAL:
>> https://github.com/krieger-od/linux/commit/2c26302dfa6d7aa74cf17a89793daecbb89ae93a
>> rmmod/modprobe cycle works fine and doesn't make any difference from
>> reboot, but still it works correctly only with PAL hardcoded for the
>> first-time initialization.
>>
>> Any ideas why wouldn't it work to change the mode after the driver load?
>
> Not really. I will have to test this next week (either Monday or Friday) with
> my solo board.

Thanks in advance.

>> Would it be allowed to add back that kernel module parameter (the one
>> passed at module load time)?
>
> No. That's a hack, the S_STD call should just work and we need to figure out
> why it fails.

Ok.

-- 
Bluecherry developer.
