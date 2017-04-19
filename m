Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33236 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936709AbdDSWPb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 18:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <e0cdbe4a-740d-70b4-6d98-5f72467a937b@xs4all.nl>
References: <20170419171543.3274995-1-arnd@arndb.de> <e0cdbe4a-740d-70b4-6d98-5f72467a937b@xs4all.nl>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 20 Apr 2017 00:15:30 +0200
Message-ID: <CAK8P3a1utR98zYa2a_FVaCDZMR6MAySLFDPBj7i8FziCoQ+6xA@mail.gmail.com>
Subject: Re: [PATCH] [media] rainshadow-cec: use strlcat instead of strncat
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 19, 2017 at 11:14 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 19/04/17 19:15, Arnd Bergmann wrote:
>> gcc warns about an obviously incorrect use of strncat():
>>
>> drivers/media/usb/rainshadow-cec/rainshadow-cec.c: In function 'rain_cec_adap_transmit':
>> drivers/media/usb/rainshadow-cec/rainshadow-cec.c:299:4: error: specified bound 48 equals the size of the destination [-Werror=stringop-overflow=]
>>
>> It seems that strlcat was intended here, and using that makes the
>> code correct.
>
> Oops! You're right, it should be strlcat.
>
> Which gcc version do you use? Mine (6.3.0) didn't give an error (or warning, for that matter).

I think the warning was only added in gcc-7.0.1.

     Arnd
