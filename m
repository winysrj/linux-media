Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48500 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaG3PV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 11:21:58 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so1061564oag.30
        for <linux-media@vger.kernel.org>; Wed, 30 Jul 2014 08:21:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D90786.9090809@InUnum.com>
References: <53D12786.5050906@InUnum.com>
	<1915586.ZFV4ecW0Zg@avalon>
	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>
	<2300187.SbcZEE0rv0@avalon>
	<53D90786.9090809@InUnum.com>
Date: Wed, 30 Jul 2014 17:21:57 +0200
Message-ID: <CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>
Subject: Re: omap3isp with DM3730 not working?!
From: Enrico <ebutera@users.sourceforge.net>
To: Michael Dietschi <michael.dietschi@inunum.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 30, 2014 at 4:56 PM, Michael Dietschi
<michael.dietschi@inunum.com> wrote:
> Am 29.07.2014 02:53, schrieb Laurent Pinchart:
>>
>> You're right. Maybe that's the first problem to be fixed though ;-)
>> Michael, could you try using the "official" (and under development) BT.656
>> support code for the OMAP3 ISP driver ? I've just pushed the branch to
>> git://linuxtv.org/pinchartl/media.git omap3isp/bt656
>
>
> Laurent,
>
> I did try this kernel and it does not work either - but with a different
> error.
> Any Idea?
>
> Michael
>
>
> These are the commands and their output:

Standard question: are you using media-ctl from
git://linuxtv.org/pinchartl/v4l-utils.git field branch and latest
yavta from git://git.ideasonboard.org/yavta.git ?

Enrico
