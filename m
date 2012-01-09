Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6ob108.obsmtp.com ([64.18.1.20]:50763 "HELO
	exprod6ob108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932429Ab2AIRIb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 12:08:31 -0500
Received: by mail-ey0-f174.google.com with SMTP id d14so2123621eaa.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 09:08:25 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 11:08:24 -0600
Message-ID: <CAPc4S2YPRWHhTJY0C5gMYtFgULHibfaqGuPOeU-fFxm9XfxYjg@mail.gmail.com>
Subject: No video on generic SAA7134 card
From: Christopher Peters <cpeters@ucmo.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have one of these cards: http://tinyurl.com/7kupvw7 and I'd like to
make it work on my Linux box.  It is seen by the kernel and detected
as a generic SAA7134-based card.  However, when I hook up video to the
card and attempt to view it in VLC, I don't see the video.  Instead I
see a number of alternating dark grey and white lines, and the image
flickers.  There's no change in the image if I disconnect the video
source from one of the inputs and connect it to another (there are
four in total) input).

Suggestions?  Should I expect to get video if the card is detected as
"generic", rather than a specific manufacturer / model?

KP

-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
