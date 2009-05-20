Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45192 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZETT5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 15:57:15 -0400
Received: by ewy24 with SMTP id 24so777496ewy.37
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 12:57:16 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2009 15:57:15 -0400
Message-ID: <37219a840905201257l4673ac7fkc035f3d6656ed26f@mail.gmail.com>
Subject: [SAA713X TESTERS WANTED] Fix i2c quirk, may affect saa713x + mt352
	combo
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have discovered a bug in the saa7134 driver inside the function,
"saa7134_i2c_xfer"

In order to communicate with certain i2c clients on the saa713x i2c
bus, a quirk was implemented to prevent failures during read
transactions.

The quirk forces an i2c write/read to a bogus address that is unlikely
to be used by any i2c client.

However, this quirk is not functioning properly.  The reason for the
malfunction is that the i2c address chosen to use as the quirk address
was 0xfd.

The address 0xfd is indeed an i2c address unlikely to be used by any
real i2c client, however, the address itself is invalid!  The address,
0xfd, has the read bit set -- this is problematic for the hardware,
and causes the quirk workaround to fail.

It's a wonder that nobody else has complained up to this point.

I am asking for testers, just to make sure that this doesn't cause any
other strange errors to occur as a side effect.  I don't expect any
new problems, but its always better to be safe than sorry :-)

This change should not fix any of the other issues currently being
discussed with the saa7134 driver -- all I am asking is for people to
test and indicate that the change does not incur any NEW bugs or
unwanted behavior.

Please test the following repository, and send in your feedback as a
reply to this thread.  Please remember to keep the mailing list in cc.

http://kernellabs.com/hg/~mk/saa7134

Thanks,

Mike Krufky
