Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:7497 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZETKE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 06:04:28 -0400
Received: by mu-out-0910.google.com with SMTP id i2so138839mue.1
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 03:04:28 -0700 (PDT)
From: Luca Ingianni <luca.ingianni@gmail.com>
To: linux-media@vger.kernel.org
Subject: Addition to DVB reception testing instrumentarium
Date: Wed, 20 May 2009 12:02:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201202.57218.luca.ingianni@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've made a quick addition to the tzapfilter.py script that is proposed on
http://www.linuxtv.org/wiki/index.php/Testing_reception_quality

I was fed up with having to dash back and forth between the signal strength 
display on the monitor and the antenna while trying to adjust its position for 
decent reception.

So I added quick&dirty sound support.
Now I get beeps whose frequency varies with UNC, which I find very useful 
(though perhaps maddening after a while :) )
Since this is my first try at python ever (and it does still have a bug - I 
have to kill it with several Ctrl-Cs before I get returned to the shell), I 
present it to your collective wisdom first. If you decide it is good enough and 
useful, consider adding it to the wiki.

If you decide to comment, please CC me as I'm not on the list.

Have fun
Luca

--8<--------8<--------8<--------8<--------8<--------8<--

#!/usr/bin/env python

import sys
import math
import os

f = sys.stdin
while True:
       l = f.readline().strip()
       fields = l.split(" | ") 
       if len(fields) < 2:
               print l
       else:
               # Sig Strength
               sigStr = fields[1].split(" ")[1]
               sig = int(sigStr, 16) / float(int('ffff', 16))
               fields[1] = "signal %.1f%%" % (sig * 100.0)

               # BER 
               berStr = fields[3].split(" ")[1]
               ber = int(berStr, 16)
               fields[3] = "ber %08d" % (ber)
               print " | ".join(fields)

               # UNC 
               uncStr = fields[4].split(" ")[1]
               unc = int(uncStr, 16)
               uncTone = math.log((unc+1.0)/10)
               cmdString = "play -q -n -c1 synth sin %" + `uncTone` + " fade q 
0.01 0.3 0.01 &"
               os.system(cmdString)
               print " | ".join(fields)

