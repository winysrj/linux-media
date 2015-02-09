Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:60046 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079AbbBICHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2015 21:07:46 -0500
Received: by mail-ig0-f182.google.com with SMTP id h15so13506199igd.3
        for <linux-media@vger.kernel.org>; Sun, 08 Feb 2015 18:07:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D7E0B8.30503@reflexion.tv>
References: <54D7E0B8.30503@reflexion.tv>
Date: Sun, 8 Feb 2015 18:07:45 -0800
Message-ID: <CA+55aFxB4Wq-Bob_+q0c3oS1hUf_BLGqqyoepGRDvm9-X2Y+og@mail.gmail.com>
Subject: Fwd: divide error: 0000 in the gspca_topro
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I got this, and it certainly seems relevant,.

It would seem that that whole 'quality' thing needs some range
checking, it should presumably be in the range [1..100] in order to
avoid negative 'sc' values or the divide-by-zero.

Hans, Mauro?

                      Linus

---------- Forwarded message ----------
From: Peter Kovář <peter.kovar@reflexion.tv>
Date: Sun, Feb 8, 2015 at 2:18 PM
Subject: divide error: 0000 in the gspca_topro
To: Linus Torvalds <torvalds@linux-foundation.org>


Hi++ Linus!

There is a trivial bug in the gspca_topro webcam driver.

/* set the JPEG quality for sensor soi763a */
static void jpeg_set_qual(u8 *jpeg_hdr,
                          int quality)
{
        int i, sc;

        if (quality < 50)
                sc = 5000 / quality;
        else
                sc = 200 - quality * 2;



Crash can be reproduced by setting JPEG quality to zero in the guvcview
application.

Cheers,

Peter Kovář
50 65 74 65 72 20 4B 6F 76 C3 A1 C5 99
