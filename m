Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.osadl.at ([92.243.35.153]:47852 "EHLO mail.osadl.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756866AbcJHOFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Oct 2016 10:05:03 -0400
Date: Sat, 8 Oct 2016 13:57:14 +0000
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Olivier Grenie <olivier.grenie@dibcom.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RFC - unclear change in "[media] DiBxxxx: Codingstype updates"
Message-ID: <20161008135714.GA1239@osadl.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Olivier !

 in your commit 28fafca78797b ("[media] DiB0090: misc improvements")

 with commit message:
      This patch adds several performance improvements and prepares the
      usage of firmware-based devices.

 it seems you changed the logic of an if/else in dib0090_tune() in a way
 that I do not understand:

-                 lo6 |= (1 << 2) | 2;
-         else
-                 lo6 |= (1 << 2) | 1;
+                 lo6 |= (1 << 2) | 2;    //SigmaDelta and Dither
+         else {
+                 if (state->identity.in_soc)
+                         lo6 |= (1 << 2) | 2;    //SigmaDelta and Dither
+                 else
+                         lo6 |= (1 << 2) | 2;    //SigmaDelta and Dither
+         }

 resulting in the current code-base of:

       if (Rest > 0) {
               if (state->config->analog_output)
                       lo6 |= (1 << 2) | 2;
               else {
                       if (state->identity.in_soc)
                               lo6 |= (1 << 2) | 2;
                       else
                               lo6 |= (1 << 2) | 2;
               }
               Den = 255;
       }

 The problem now is that the if and the else(if/else) are
 all the same and thus the conditions have no effect. Further
 the origninal code actually had different if/else - so I 
 wonder if this is a cut&past bug here ?

 With no knowlege of the device providing a patch makes
 no sense as it would just be guessing - in any case this looks 
 wrong (or atleast should have a comment if it actually is correct)

 What am I missing ?

thx!
hofrat


