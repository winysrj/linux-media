Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42023 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3FHIEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jun 2013 04:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <201306071040.35174.hverkuil@xs4all.nl>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
 <2855590.yx9zfYZLis@avalon> <CA+V-a8vh-ttz1QQmV59fP5c3vK=1zC5QfmkHc9Du0ZAcY712Dg@mail.gmail.com>
 <201306071040.35174.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 8 Jun 2013 13:34:10 +0530
Message-ID: <CA+V-a8vhnri3Wusk7ZrDq6M9JAKHi+hs1qJ8ru8Mdgt7bTPD0w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] media: i2c: ths7303 cleanup
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jun 7, 2013 at 2:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu June 6 2013 12:05:38 Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Sun, May 26, 2013 at 6:50 AM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>> > On Saturday 25 May 2013 23:09:32 Prabhakar Lad wrote:
>> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >>
>> >> Trivial cleanup of the driver.
>> >>
>> >> Changes for v2:
>> >> 1: Dropped the asynchronous probing and, OF
>> >>    support patches will be handling them independently because of
>> >> dependencies. 2: Arranged the patches logically so that git bisect
>> >>    succeeds.
>> >>
>> >> Lad, Prabhakar (4):
>> >>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
>> >>   media: i2c: ths7303: remove init_enable option from pdata
>> >>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
>> >>   media: i2c: ths7303: make the pdata as a constant pointer
>> >>
>> Can you pick up this series or do you want me to issue a pull for it ?
>
> I've picked it up. I kept the dm365 patch separate, but I did improve the
> commit log a bit.
>
Thanks for fixing it.

Regards,
--Prabhakar Lad
