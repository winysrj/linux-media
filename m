Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:38312 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0AXJNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 04:13:13 -0500
Received: by fxm7 with SMTP id 7so906231fxm.28
        for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 01:13:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264275944.21574.103.camel@slash.doma>
References: <1264193852.21574.84.camel@slash.doma>
	 <1264275944.21574.103.camel@slash.doma>
Date: Sun, 24 Jan 2010 13:13:11 +0400
Message-ID: <1a297b361001240113j1572ceb1m63bce9696fa21eb9@mail.gmail.com>
Subject: Re: technisat cablestar hd2, 2.6.33-rc5, no remote (VP2040)
From: Manu Abraham <abraham.manu@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, Jan 23, 2010 at 11:45 PM, Aljaž Prusnik <prusnik@gmail.com> wrote:
> Hi Manu,
>
> I'm sorry to bother you with this one, but I'd really like to know if
> there's something I'm doing wrong or is there something more I can
> provide on this one. Below are some results from the newest kernel RC,
> while sometime back I also posted some more debug info.
>
> I just noticed that someone else also reported the same problem:
> http://www.spinics.net/lists/linux-media/msg14332.html

There's nothing wrong with what you are doing in there.

While the driver was pushed in the IR interface related stuff itself
was very much in flux and caused some issues and hence support for the
same was not added in at that time.

I will push out the support as I get free time into the mantis-v4l-dvb tree.

Regards,
Manu
