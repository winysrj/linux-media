Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42561 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbBYRyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 12:54:31 -0500
Received: by pablj1 with SMTP id lj1so4508117pab.9
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 09:54:31 -0800 (PST)
Message-ID: <54EE0C55.2020501@gmail.com>
Date: Wed, 25 Feb 2015 09:54:29 -0800
From: Steve Longerbeam <slongerbeam@gmail.com>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 Video combiner
References: <CAL8zT=g2uUDQYgfNW5017YCKjfxBz7Oj+9FSvdo4PXZgiOAKWQ@mail.gmail.com> <54EE086B.9020904@gmail.com>
In-Reply-To: <54EE086B.9020904@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/2015 09:37 AM, Steve Longerbeam wrote:
> On 02/25/2015 02:57 AM, Jean-Michel Hautbois wrote:
>> Hi all,
>>
>> I read in the i.MX6 TRM that it can do combining or deinterlacing with VDIC.
>> Has it been tested by anyone ?
>> Could it be a driver, which would allow to do some simple compositing
>> of souces ?
>>
>> Thanks,
>> JM
> I've added VDIC support (deinterlace with motion compensation) to the
> capture driver, it's in the my media tree clone:
>
> git@github.com:slongerbeam/mediatree.git, mx6-media-staging

it is activated if user sets the motion compensation control to
1 (low motion), 2 (medium motion), or 3 (high motion), for
example:

# v4l2-ctl --set-ctrl=motion_compensation=2

Steve

