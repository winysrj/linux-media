Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54656 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760370AbZDIIlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 04:41:44 -0400
Received: by fxm2 with SMTP id 2so474932fxm.37
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2009 01:41:43 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 10:41:42 +0200
Message-ID: <e9a4f5af0904090141h462c2909q65dded8cde1632a2@mail.gmail.com>
Subject: firedtv and ca-module
From: Johannes Tang Kristensen <linuxmedia@tangkristensen.dk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm having trouble using the firedtv driver to watch scrambled
channels using a ca-module. Here's my setup: I have a firedtv c/ci
tuner with an irdeto cam, and am running Fedora 10 with a 2.6.29.1
kernel. In general I have no problems with FTA channels, but scrambled
channels do not always work. I've tested my setup on a macbook in mac
osx using eyetv, and here I can watch scrambled channels without any
problems, so I doubt my problems are hardware related.

I have tried to track down the problem using various dvb-apps, and the
app I've had the best results with is gnutv from dvb-apps. If I try to
tune to a scrambled channel I get the following:

[root@hp-laptop gnutv]# ./gnutv -channels ./channels.conf -out file
test.mpg "3+"
CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Irdeto Access
CAM supports the following ca system ids:
Using frontend "FireDTV C/CI", type DVB-C
status SCVYL | signal ff00 | snr 2525 | ber 000000be | unc 00000000 |
FE_HAS_LOCK

and then it hangs. But if I kill the process and try again it works and I get:

[root@hp-laptop gnutv]# ./gnutv -channels ./channels.conf -out file
test.mpg "3+"
CAM Application type: 01
CAM Application manufacturer: cafe
CAM Manufacturer code: babe
CAM Menu string: Irdeto Access
CAM supports the following ca system ids:
Using frontend "FireDTV C/CI", type DVB-C
status SCVYL | signal ff00 | snr 2525 | ber 00000082 | unc 00000000 |
FE_HAS_LOCK
Received new PMT - sending to CAM...

So I need to "tune" the channel twice for it to work. After this first
time it keeps working even if I stop gnutv and start it again, as long
as I want to watch the same channel. As soon as try to watch a
different channel I again need to "tune" it twice before it works.

Well that's not completely true. Because after playing around with
several different channels it appears there might be a pattern. If I
have been able to successfully watch a scrambled channel by tuning it
twice as described above then I can watch all channels in the mux
without having to tune twice again. The problem only appears again
when I try to watch a channel in a different mux.

I hope that some of you can make some sense of my problem. Please let
me know if I can provide any additional information.

/Johs
