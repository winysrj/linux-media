Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55720 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370AbZLKBjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 20:39:14 -0500
Received: by bwz27 with SMTP id 27so323188bwz.21
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 17:39:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912072020s79199b84g20dbc341e4d231e1@mail.gmail.com>
References: <44c6f3de0912041415r54d8ab6fq486f2a82edb91a68@mail.gmail.com>
	<829197380912041526r764a0deeyb64910a22e92d75d@mail.gmail.com>
	<829197380912072020s79199b84g20dbc341e4d231e1@mail.gmail.com>
From: John S Gruber <johnsgruber@gmail.com>
Date: Thu, 10 Dec 2009 20:38:59 -0500
Message-ID: <44c6f3de0912101738h7f102929i54fbcceceb616edf@mail.gmail.com>
Subject: Re: [PATCH] sound/usb: Relax urb data alignment restriciton for
	HVR-950Q only
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> After reviewing the patch as well as the spec, your change looks
> pretty reasonable (aside from the fact that you need the other USB
> IDs).  It seems pretty clear that the au0828 violates the spec, but
> the spec does indicate how to handle that case, which is what your
> code addresses.
>

I think you found something in the specification I haven't found. What did you
see that indicated how to deal with equipment misbehaving in this way?

I found the following list of USB ID's. Just double checking, but is
the 850 enough like the
950 line for me to include it?

        case 72000: /* WinTV-HVR950q (Retail, IR, ATSC/QAM */
        case 72001: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
        case 72211: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
        case 72221: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
        case 72231: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
        case 72241: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
        case 72251: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
-->   case 72301: /* WinTV-HVR850 (Retail, IR, ATSC and analog video */
        case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */


Thanks again, not only for your help with my change, but with all you did to
provide support for the Hauppage equipment.

I'd add that being the beginner at making kernel changes your review
is particularly
helpful to me (and to my confidence).

John
