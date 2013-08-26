Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:43919 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3HZIvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 04:51:07 -0400
Received: by mail-ob0-f194.google.com with SMTP id eh20so1358933obb.1
        for <linux-media@vger.kernel.org>; Mon, 26 Aug 2013 01:51:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130823T150508-871@post.gmane.org>
References: <loom.20130821T143312-331@post.gmane.org>
	<loom.20130823T150508-871@post.gmane.org>
Date: Mon, 26 Aug 2013 10:51:07 +0200
Message-ID: <CA+2YH7tXLgwFjN9S2mrVQ2rhu==GQ5=HPSyf8hpZP2_UA=7j2g@mail.gmail.com>
Subject: Re: media-ctl: line 1: syntax error: "(" unexpected
From: Enrico <ebutera@users.berlios.de>
To: Tom <Bassai_Dai@gmx.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 23, 2013 at 3:08 PM, Tom <Bassai_Dai@gmx.net> wrote:
> Tom <Bassai_Dai <at> gmx.net> writes:
>
>>
>> Hello,
>>
>> I got the media-ctl tool from http://git.ideasonboard.org/git/media-ctl.git
>> and compiled and build it successfully. But when try to run it I get this
> error:
>>
>> sudo ./media-ctl -r -l "ov3640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
>> CCDC":1->"OMAP3 ISP CCDC output":0[1]
>>
>> ./media-ctl: line 1: syntax error: "(" unexpected
>>
>> Does anyone know how I can solve that problem?

Looks like you are trying to execute a wrapper script instead of the
real binary, it's in src/.libs

Enrico
