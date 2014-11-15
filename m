Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:42115 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbaKOWM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 17:12:59 -0500
Received: by mail-vc0-f173.google.com with SMTP id id10so5636768vcb.4
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 14:12:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3wq6ww602.fsf@t19.piap.pl>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	<m3sihmf3mc.fsf@t19.piap.pl>
	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com>
	<CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
	<m3wq6ww602.fsf@t19.piap.pl>
Date: Sun, 16 Nov 2014 02:12:58 +0400
Message-ID: <CAM_ZknW95PMy7_FVs+bYmG6Z+1WTt0QXv2FkSqimAuxvGjRsVA@mail.gmail.com>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 16, 2014 at 12:42 AM, Krzysztof Hałasa <khalasa@piap.pl> wrote:
> Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:
>
>> In upstream there's no more module parameter for video standard
>> (NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it turns
>> out not to work correctly: the frame is offset, so that in the bottom
>> there's black horizontal bar.
>> The S_STD ioctl call actually makes difference, because without that
>> the frame "slides" vertically all the time. But after the call the
>> picture is not correct.
>
> Which kernel version are you using?

linux-next from Oct 31 with few my patches which are not in linux-next yet.


-- 
Bluecherry developer.
