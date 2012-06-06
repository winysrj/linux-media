Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:46108 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab2FFHGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jun 2012 03:06:37 -0400
Date: Wed, 6 Jun 2012 09:06:23 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: mchehab@infradead.org, linux-media@vger.kernel.org
cc: joe@perches.com
Subject: question about bt8xx/bttv-audio-hook.c, tvaudio.c
Message-ID: <alpine.DEB.2.02.1206060852460.1777@hadrien>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The files drivers/media/video/bt8xx/bttv-audio-hook.c and 
drivers/media/video/tvaudio.c contain a number of occurrences of eg:

mode |= V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2;

and

if (mode & V4L2_TUNER_MODE_MONO)

(both from tvaudio.c)

V4L2_TUNER_MODE_LANG1 | V4L2_TUNER_MODE_LANG2 is suspicious because 
V4L2_TUNER_MODE_LANG1 is 3 and V4L2_TUNER_MODE_LANG2 is 2, so the result 
is just the same as V4L2_TUNER_MODE_LANG1.  Maybe 
V4L2_TUNER_MODE_LANG1_LANG2 was intended?

mode & V4L2_TUNER_MODE_MONO is suspicious because V4L2_TUNER_MODE_MONO is 
0.  Maybe & should be ==?

If & is to be changed to == everywhere, then some new code may need to be 
constructed to account for V4L2_TUNER_MODE_LANG1_LANG2.  For example, the 
function tda8425_setmode has ifs for the other values, but not for this 
one.  On the other hand, the function ta8874z_setmode already uses == (or 
rather switch), and does not take V4L2_TUNER_MODE_LANG1_LANG2 into 
account, so perhaps it is not appropriate in this context?

julia

