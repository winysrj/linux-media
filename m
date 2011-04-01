Return-path: <mchehab@pedra>
Received: from mx.treblig.org ([80.68.94.177]:56829 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1DBA1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Apr 2011 20:27:43 -0400
Date: Sat, 2 Apr 2011 00:44:12 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: olivier.grenie@dibcom.fr, patrick.boettcher@dibcom.fr,
	mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: Typo in dib0700_devices.c
Message-ID: <20110401234412.GB28823@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
  sparse lead me to what looks like a typo in dib0700_devices.c:

drivers/media/dvb/dvb-usb/dib0700_devices.c:2160:18: warning: Initializer entry defined twice
drivers/media/dvb/dvb-usb/dib0700_devices.c:2165:18:   also defined here

2160            .agc1_pt1       = 0,      
                .agc1_pt2       = 0,
                .agc1_pt3       = 98,
                .agc1_slope1    = 0,
                .agc1_slope2    = 167,
2165            .agc1_pt1       = 98,
                .agc2_pt2       = 255,

Note the line 2165 says .agc1_pt1 - I believe that should be
agc*2*_pt1 (without knowing anything at all about your hardware!)

The last thing that changed that was Olivier's patch
b4d6046e841955be9cc49164b03b91c9524f9c2e

which was just a tidy up, but it had:

-               .agc1_pt1       = 98,     // agc2_pt1

....

+               .agc1_pt1       = 98,

Note the mismatch of the comment.

(I haven't got this hardware to test on - but if you've been having
some weird AGC issues on that card it might explain it!)

Dave 

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
