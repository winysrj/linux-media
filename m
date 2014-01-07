Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:47888 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaAGQdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 11:33:15 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so402921obc.28
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 08:33:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CC275B.5030907@gmx.de>
References: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
	<52CC275B.5030907@gmx.de>
Date: Tue, 7 Jan 2014 16:33:14 +0000
Message-ID: <CAGj5WxDuZadCm+Hwp=BDPwPf1fb4nuFXLotK8ePR7Q14-zvkMg@mail.gmail.com>
Subject: Re: Upstreaming SAA716x driver to the media_tree
From: Luis Alves <ljalvs@gmail.com>
To: Andreas Regel <andreas.regel@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Chris Lee <updatelee@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>, crazycat69@narod.ru,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Andreas,

My initial commit is based on:
http://powarman.dyndns.org/hgwebdir.cgi/v4l-dvb-saa716x/
(I think it's your repo with some commits from Soeren Moch)

The difference to my working area is that I have the driver placed in
"drivers/media/pci/saa716x" (instead of
"drivers/media/common/saa716x") and everything is rebased on the
latest media_tree.
On top of that I just have 2 commits: one to be able to build FF cards
and another to fix some i2c issues.

You can check my repo here:
https://github.com/ljalves/linux_media/commits/saa716x

Regards,
Luis


On Tue, Jan 7, 2014 at 4:12 PM, Andreas Regel <andreas.regel@gmx.de> wrote:
> Hi Luis,
>
> Am 07.01.2014 12:58, schrieb Luis Alves:
>> Hi,
>>
>> I'm finishing a new frontend driver for one of my dvb cards, but the
>> pcie bridge uses the (cursed) saa716x.
>> As far as I know the progress to upstream Manu's driver to the
>> media_tree has stalled.
>>
>> In CC I've placed some of the people that I found working on it
>> lately, supporting a few dvb cards.
>>
>> It would be good if we could gather everything in one place and send a
>> few patchs to get this upstreamed for once...
>>
>> Manu, do you see any inconvenience in sending your driver to the
>> linux_media tree?
>> I'm available to place some effort on this task.
>
> which repository of the saa761x is your work based on?
>
> Regards,
> Andreas
>
