Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34123 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbFENkg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 09:40:36 -0400
Received: by igbhj9 with SMTP id hj9so15591845igb.1
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2015 06:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNXWsv6O23yzRAx9L6TrKRvm9o7SdApsHjMgE3dpqUYpWA@mail.gmail.com>
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
	<557048EF.3040703@iki.fi>
	<CAAZRmGw7NcDo8YJtYN5gC6DM23jtgqmGhhJUAa6VaEovX+qNdA@mail.gmail.com>
	<CAAZRmGy_AwJfGzfDorx_=43xNQ3cB915GFnck-YJ0gu0W64xKw@mail.gmail.com>
	<CALzAhNXWsv6O23yzRAx9L6TrKRvm9o7SdApsHjMgE3dpqUYpWA@mail.gmail.com>
Date: Fri, 5 Jun 2015 15:40:35 +0200
Message-ID: <CAAZRmGxtzq1qX=JKusF_A+_0od8sY8LO_kN-6ZWge2E7GMoweA@mail.gmail.com>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Olli Salonen <olli.salonen@iki.fi>
To: Steven Toth <stoth@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

It seems to me that that part of the code is identical to your driver, no?

The media_tree driver:

retval = saa7164_api_i2c_read(bus,
                     msgs[i].addr,
                     0 /* reglen */,
                     NULL /* reg */, msgs[i].len, msgs[i].buf);

It's exactly the same with a little bit different formatting.

Cheers,
-olli


On 4 June 2015 at 16:03, Steven Toth <stoth@kernellabs.com> wrote:
> On Thu, Jun 4, 2015 at 9:22 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
>> I compiled an old HVR-2205 driver from my git tree:
>> https://github.com/trsqr/media_tree/tree/hvr2205
>
> https://github.com/trsqr/media_tree/commit/61c2ef874b8a9620f498c9a4ab4138e97119462b
>
> That's the difference perhaps.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
