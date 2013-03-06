Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:57706 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab3CFO2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 09:28:31 -0500
Received: by mail-vc0-f169.google.com with SMTP id n10so4820865vcn.14
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 06:28:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+rnASsrDc57FkMi=nWzDThFNc9ktj2J60XcA7WCWisLyrxxgw@mail.gmail.com>
References: <CA+rnASviBDZVk9KJPYD1jLoHUbeyWwL+D5oSyvYVHKZFOSUAkw@mail.gmail.com>
 <50EC93B0.8030404@iki.fi> <CA+rnASsrDc57FkMi=nWzDThFNc9ktj2J60XcA7WCWisLyrxxgw@mail.gmail.com>
From: =?UTF-8?Q?C=C3=A9dric_Girard?= <girard.cedric@gmail.com>
Date: Wed, 6 Mar 2013 15:28:10 +0100
Message-ID: <CA+rnASvpVUn+0PSRW9E5BGf8UB44h-RUAft5_qA4rgYPQgJXOw@mail.gmail.com>
Subject: Re: No Signal with TerraTec Cinergy T PCIe dual
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 8, 2013 at 10:46 PM, Antti Palosaari wrote:
>
> Try to downgrade Kernels until you find working one.
>
> Guess it is probably the only way. I will try.


Seeing other message about a problem with the same card, made me think
I forgot to post my conclusion.

I downgraded to 3.6.5 which was a working one at the time I got the
card and the problem is the same. The problem is thus elsewhere (maybe
hardware related but it is difficult to me to test the card in another
computer).


--
Cédric Girard
