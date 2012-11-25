Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:40161 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2KYSmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 13:42:53 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so7514254iay.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 10:42:52 -0800 (PST)
Message-ID: <50B266AA.3090209@gmail.com>
Date: Sun, 25 Nov 2012 13:42:50 -0500
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Poor HVR-1600 Tuner Quality - Devin Heitmueller Feedback 2012-11-25
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear Devin:
     Using v4l2-ctl and mplayer I have the svideo working and the
Tuner is not.
     I find it interesting that the Frequency is not taking I suspect
your theory of subdev framework may hold water.
> [root@mythbox ~]# v4l2-ctl -d /dev/video2 --set-input=1 Video input
> set to 1 (S-Video 1: ok) [root@mythbox ~]# v4l2-ctl -d /dev/video2
> --set-standard=1 Standard set to 00001000 [root@mythbox ~]#
> v4l2-ctl -d /dev/video2 -f 67.250 Frequency set to 1076 (67.250000
> MHz) [root@mythbox ~]# v4l2-ctl -d /dev/video2 -F Frequency: 0
> (0.000000 MHz) [root@mythbox ~]#

     The above series responds differently when using
kernel-2.6.32-131.0.15.el6.x86_64 from the centos vault.  The mplayer
video still does not return correctly despite the -F returning a good
frequency.

     Right now I am struggling with getting mythtv to use the svideo
input.  But thats fodder for another mailing list / irc channel.

     If anyone knows how to debug the tuner further responses are welcome.

Bob Lightfoot
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJQsmaqAAoJEKqgpLIhfz3Xz98IALDDJaE5HT85kGcySrydz55o
EKV/tCDfRdVE85cRfG1YmePESkoXAEwd1T9UWfr2bdB+H2M1s00njq/QGBCnx5jF
fyFmcFZLzaDpybrY/0+sHTTYsKumyqKb0cPMQmmbIikeR0s/59qxp7SQwfP34lTs
u9Qh5MVp1XLNeBtGBNr1favmT5youmEk5VxSmPf4eIglmnXrjO0dpS5I8TnomAtU
MtRPFsDR7vFCbQaKYLMUJeiH86YaC+65FFbhufELo2/cRHoRgKQVtd52YHC//ush
TGA8Cm7ZRP6s4ZacXQXXfZucpPkWEDHIZCy7l8qwKGunuI4haZwqkC4z/1IhZzs=
=Phm1
-----END PGP SIGNATURE-----
