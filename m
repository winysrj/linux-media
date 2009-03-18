Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:45911 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZCRCpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 22:45:54 -0400
Received: by gxk4 with SMTP id 4so514218gxk.13
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 19:45:52 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 22:45:52 -0400
Message-ID: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
Subject: SNR status for demods
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have updated my compiled list of the various demods and how they
currently report SNR info (including feedback from people in the last
round).

http://www.devinheitmueller.com/snr.txt

Here's how you can help out:

If you are a maintainer for a device in this list, please let me know
so I can update the document.  If you are the maintainer and somebody
else's name is listed by the device, please do not take offense to
this (it's probably just an error on my part [please email and correct
me]).

If you have specs for a device in this list where the format is
currently "unknown", please let me know as this will be helpful in
identifying which demods we can get accurate information for.

If you know something about how SNR is currently reported by the
driver, and it is not reflected in this list, please let me know and I
will update the document.

All of the above information will be helpful once a format has been
decided on, so we can pull together and finally get a consistent
interface.

Thank you for your time,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
