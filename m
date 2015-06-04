Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35268 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbFDOD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 10:03:29 -0400
Received: by qgh73 with SMTP id 73so3282262qgh.2
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 07:03:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAZRmGy_AwJfGzfDorx_=43xNQ3cB915GFnck-YJ0gu0W64xKw@mail.gmail.com>
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
	<557048EF.3040703@iki.fi>
	<CAAZRmGw7NcDo8YJtYN5gC6DM23jtgqmGhhJUAa6VaEovX+qNdA@mail.gmail.com>
	<CAAZRmGy_AwJfGzfDorx_=43xNQ3cB915GFnck-YJ0gu0W64xKw@mail.gmail.com>
Date: Thu, 4 Jun 2015 10:03:28 -0400
Message-ID: <CALzAhNXWsv6O23yzRAx9L6TrKRvm9o7SdApsHjMgE3dpqUYpWA@mail.gmail.com>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Steven Toth <stoth@kernellabs.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 4, 2015 at 9:22 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
> I compiled an old HVR-2205 driver from my git tree:
> https://github.com/trsqr/media_tree/tree/hvr2205

https://github.com/trsqr/media_tree/commit/61c2ef874b8a9620f498c9a4ab4138e97119462b

That's the difference perhaps.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
