Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:48716 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZEUGog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 02:44:36 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [SAA713X TESTERS WANTED] Fix i2c quirk, may affect saa713x + mt352 combo
Date: Thu, 21 May 2009 08:44:30 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
In-Reply-To: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905210844.31053.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Wednesday 20 of May 2009 at 21:57:15, Michael Krufky wrote:
> I have discovered a bug in the saa7134 driver inside the function,
> "saa7134_i2c_xfer"
>
> In order to communicate with certain i2c clients on the saa713x i2c
> bus, a quirk was implemented to prevent failures during read
> transactions.
>
> The quirk forces an i2c write/read to a bogus address that is unlikely
> to be used by any i2c client.
>
> However, this quirk is not functioning properly.  The reason for the
> malfunction is that the i2c address chosen to use as the quirk address
> was 0xfd.
>
> The address 0xfd is indeed an i2c address unlikely to be used by any
> real i2c client, however, the address itself is invalid!  The address,
> 0xfd, has the read bit set -- this is problematic for the hardware,
> and causes the quirk workaround to fail.
>
> It's a wonder that nobody else has complained up to this point.

I had a problem with 0xfd quirk already (the presence caused the device not to 
respond), this is why there is an exception

	msgs[i].addr != 0x40

I can check if it works with your version (0xfe), but the device behind the 
address 0x40 (remote control) is very stupid, so I don't think so.

I think that better approach would be to use the quirk only for devices 
(addresses) that really need it, not for all.

Cheers,
Oldrich.

> I am asking for testers, just to make sure that this doesn't cause any
> other strange errors to occur as a side effect.  I don't expect any
> new problems, but its always better to be safe than sorry :-)
>
> This change should not fix any of the other issues currently being
> discussed with the saa7134 driver -- all I am asking is for people to
> test and indicate that the change does not incur any NEW bugs or
> unwanted behavior.
>
> Please test the following repository, and send in your feedback as a
> reply to this thread.  Please remember to keep the mailing list in cc.
>
> http://kernellabs.com/hg/~mk/saa7134
>
> Thanks,
>
> Mike Krufky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


