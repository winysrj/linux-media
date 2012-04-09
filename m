Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55181 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab2DIHd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 03:33:27 -0400
Received: by obbtb18 with SMTP id tb18so5508139obb.19
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2012 00:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO2_v5CZhs0QQcGMzsnA+wxsyLJ_OXhs++9L+HtscSeDc+_uTA@mail.gmail.com>
References: <1333900903-2585-1-git-send-email-hdegoede@redhat.com>
	<CAO2_v5CZhs0QQcGMzsnA+wxsyLJ_OXhs++9L+HtscSeDc+_uTA@mail.gmail.com>
Date: Mon, 9 Apr 2012 08:33:27 +0100
Message-ID: <CAO2_v5DNzSU0gyocbvuttmZbAHqnR8E5k1Y43uYgiwiD4CxgYw@mail.gmail.com>
Subject: Re: [PATCH] stk-webcam: Don't flip the image by default
From: Jaime Velasco <jsagarribay@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Gregor Jasny <gjasny@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, resending message. Hopefully it gets to the list now. I blame gmail...

2012/4/9 Jaime Velasco <jsagarribay@gmail.com>
>
>
> 2012/4/8 Hans de Goede <hdegoede@redhat.com>
>>
>> Prior to this patch the stk-webcam driver was enabling the vflip and
>> mirror
>> bits in the sensor by default. Which only is the right thing to do if the
>> sensor is actually mounted upside down, which it usually is not.
>>
>> Actually we've received upside down reports for both usb-ids which this
>> driver supports, one for an "ASUSTeK Computer Inc." "A3H" laptop with
>> a build in 174f:a311 webcam, and one for an "To Be Filled By O.E.M."
>> "Z96FM" laptop with a build in 05e1:0501 webcam.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
>
> Hi, I don't know hoy many users of stk-webcam could be, but this will
> surely cause a small regression for them. I agree it seems neater your way,
> but I don't think it makes sense to half-break the driver for a set of users
> in order to fix it for another.
>
> That said, if you feel this is the way to go I won't complain. My old
> laptop broke some years ago and I have not touch nor used this driver since.
>
> Regards,
> Jaime
