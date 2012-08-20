Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42332 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2HTKjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 06:39:35 -0400
Received: by bkwj10 with SMTP id j10so1806064bkw.19
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 03:39:33 -0700 (PDT)
Message-ID: <503213F8.6060101@googlemail.com>
Date: Mon, 20 Aug 2012 12:39:52 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: How to add new chip ids to v4l2-chip-ident.h ?
References: <502FA46E.3050500@googlemail.com> <201208181706.03257.hverkuil@xs4all.nl>
In-Reply-To: <201208181706.03257.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.08.2012 17:06, schrieb Hans Verkuil:
> On Sat August 18 2012 16:19:26 Frank Schäfer wrote:
>> Hi,
>>
>> I would like to know how to add new chip ids to v4l2-chip-ident.h. Ist
>> there a kind of policy for choosing numbers ?
> Using numbers that match the chip number is recommended, but if that can't
> be done due to clashes, then pick some other, related, number (e.g. 12700
> instead of 2700) or create a range of number for all possible models of that
> chip series.

Ok. And I guess a comment should be added that reserves a certain range
of values, if similar chips exist.

>
>> Which numbers would be approriate for the em25xx/em26xx/em27xx/em28xx
>> chips ?
>> Unfortunately 2700 is already used by V4L2_IDENT_VP27SMPX...
> Please note that adding an identifier to v4l2-chip-ident.h is only needed
> if the VIDIOC_DBG_* ioctls are implemented. If those are not implemented,
> then there is no need for an ID either.

Sure ;-) Thanks !

Regards,
Frank Schäfer

>
> Regards,
>
> 	Hans

