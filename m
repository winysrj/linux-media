Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51531 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2EBPhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 11:37:51 -0400
Received: by qabj40 with SMTP id j40so869910qab.1
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 08:37:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com>
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com>
 <20120502114430.GA4608@kipc2.localdomain> <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
 <20120502133108.GA19522@kipc2.localdomain> <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 2 May 2012 16:37:30 +0100
Message-ID: <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com>
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, so UVCIOC_CTRL_ADD is no longer available, now we have:

UVCIOC_CTRL_MAP and UVCIOC_CTRL_QUERY, so I guess some changes are
needed, I'll try to fix this ASAP.

Regards,
Paulo

2012/5/2 Paulo Assis <pj.assis@gmail.com>:
> Hi,
> yes, libwebcam depends on uvcvideo.h, I've only added this as a patch
> since it was missing from debian kernel headers at the time. I think
> you should be able to get it from there now, not sure if the new
> header breaks anything, I'll have to run some tests.
> The other patches are not needed, but they do increase functionality
> to some extent.
>
> Anyway if this was just a libwebcam issue, guvcview should still be
> able to add the controls, and apparently that's failing also.
>
> Best regards,
> Paulo
>
> 2012/5/2 Karl Kiniger <karl.kiniger@med.ge.com>:
>> On Wed 120502, Paulo Assis wrote:
>>> karl,
>>> I've run some tests under ubuntu 12.04 with kernel 3.2.0 and
>>> everything seems to be working fine.
>>> I know some changes were made to the uvcvideo module regarding XU
>>> controls, but I was under the impression that they wouldn't break
>>> userspace.
>>>
>>> Logitech shutdown the quickcamteam site, so you won't be able to
>>> download libwebcam from there.
>>> I'm currently the debian mantainer of that package, so I'll try to
>>> test it on a newer kernel and patch it as necessary.
>>> I'll also fix guvcview if needed.
>>
>> Very much appreciated, Paulo!
>>
>> In the meantime I poked  around at Ubuntu and found
>> libwebcam_0.2.1.orig.tar.gz - will try to compiled it but they
>> have a couple of kernel patches to 3.2.x as well and perhaps there
>> is a depency.
>>
>> Karl
>>
>>>
>>> Regards,
>>> Paulo
>>
