Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:43853 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3AUCJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 21:09:24 -0500
Received: by mail-qa0-f45.google.com with SMTP id bv4so2600655qab.4
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2013 18:09:23 -0800 (PST)
Date: Sun, 20 Jan 2013 21:03:24 -0500
From: mrf <gc2majortom@gmail.com>
To: linux-media@vger.kernel.org
Subject: tuner-xc2028.c fix for EVGA inDtube tuner
Message-ID: <20130121020324.GB9028@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Let me begin with, I'm an end user, not a programmer...

I have noticed the EVGA inDtube tuner that I use (North American ATSC)
has been broken for quite a while. The Frequency offsets are wrong,
and up till now I have always had to fudge the frequency to account
for the incorrect offset. 
I found a fix that works for me, and waiting for a friend of mine,
another inDtube user, to try the same fix and get back to me.

Pending his report, would it be possible to get this fixed in the
kernel for good?

Thanks,

Bill

/ linux / drivers / media / common / tuners / tuner-xc2028.c

was commented out by someone somewhere along the way in development. Putting the
commented code back in, the inDtube tuner works correctly, no more having to
fudge the frequency offset in user land.

Would it be possible to get this fixed for good in the kernel?
I am using xc3028L-v36.fw firmware

here is a snippet adding two comments, to remove the comments.


/* #if 0 */
                /*
                 * Still need tests for XC3028L (firmware 3.2 or
                 * upper)
                 * So, for now, let's just comment the per-firmware
                 * version of this change. Reports with xc3028l
                 * working
                 * with and without the lines bellow are welcome
                 */

                if (priv->firm_version < 0x0302) {
                        if (priv->cur_fw.type & DTV7)
                                offset += 500000;
                } else {
                        if (priv->cur_fw.type & DTV7)
                                offset -= 300000;
                        else if (type != ATSC) /* DVB @6MHz, DTV 8 and
DTV 7/8 */
                                offset += 200000;
                }
/* #endif */



