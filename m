Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33217 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbFIQPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 12:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <20150608201239.GA16736@kroah.com>
References: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
	<3768175.5Bdztn7jIp@wuerfel>
	<CAL7P5j+YfuysVeCyFQZ9DwN872Ke=PyE5fakBjdR-9h4VqN1pQ@mail.gmail.com>
	<20150608201239.GA16736@kroah.com>
Date: Tue, 9 Jun 2015 18:15:50 +0200
Message-ID: <CAL7P5j+ALaL62ymkr312PbOSPVPtgg3SzMgdrO=HQrc_T4+ugg@mail.gmail.com>
Subject: Re: [Y2038] [PATCH] Staging: media: lirc: Replace timeval with ktime_t
From: =?UTF-8?Q?Ksenija_Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
	devel@driverdev.osuosl.org, mchehab@osg.samsung.com,
	jarod@wilsonet.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2015 at 10:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 08, 2015 at 09:37:24PM +0200, Ksenija Stanojević wrote:
>> Hi Greg,
>>
>> It's been over two weeks that I've sent this patch.  Have you missed it?
>
> Not at all, please look at the output of
>         $ ./scripts/get_maintainer.pl --file drivers/staging/media/lirc/lirc_sir.c
>

Ok. I used:
 ./scripts/get_maintainer.pl --nokeywords --nogit --nogit-fallback
--norolestats --file

I'll use instead ./scripts/get_maintainer.pl --file and send a v2.

> To see why I ignored this.
>
> greg k-h
