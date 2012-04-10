Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41296 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab2DJPYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 11:24:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SHcvl-0006oV-HY
	for linux-media@vger.kernel.org; Tue, 10 Apr 2012 17:24:29 +0200
Received: from lechon.iro.umontreal.ca ([132.204.27.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 17:24:29 +0200
Received: from monnier by lechon.iro.umontreal.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 17:24:29 +0200
To: linux-media@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: Unknown eMPIA tuner
Date: Tue, 10 Apr 2012 11:24:14 -0400
Message-ID: <jwv1unvwrtn.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
References: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfiwKU1doqvdcHFpVoc2xuRQKdQirWze0oB2QQyXSQcYrKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I just got a USB tuner ("HD TV ATSC USB stick") which lsusb describes as
>> "ID eb1a:1111 eMPIA Technology, Inc." and was wondering how to try to
>> get it working.
>> Would the em28xx driver be able to handle it?  If so, how should I modify
>> it to try it out?
> You would probably have to start by taking it apart and seeing which
> demodulator and tuner chips it contained.

Hmm... how would I go about taking it apart without destroying it?
...hhmmm... apparently, a bit of brute force did the trick (at least
for the "taking it apart" bit, not sure about the "without destroying
it" yet).

On one side I see a small IC that says something like "Trident \n DRX
3933J B2".

On the other side I see 2 ICs that say respectively "eMPIA \n ?M2874B"
and "NXP \n TDA182?1HDC2 \n P3KNR" (the ? might be a slash or a 7) plus
a third tiny "24C??? \n FTG..." but I don't think that one
is significant.


        Stefan

