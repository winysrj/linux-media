Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57454 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab2DFKkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 06:40:15 -0400
Received: by eekc41 with SMTP id c41so661216eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2012 03:40:14 -0700 (PDT)
Message-ID: <4F7EC80A.4010906@gmail.com>
Date: Fri, 06 Apr 2012 12:40:10 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH 3/5] tda18218: fix IF frequency for 7MHz bandwidth channels
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com> <1333401917-27203-4-git-send-email-gennarone@gmail.com> <4F7A2AC9.8040407@iki.fi> <4F7A47E5.8040604@gmail.com> <4F7ACEB6.9020108@iki.fi> <4F7C4963.2060100@gmail.com> <4F7C4C3D.1090702@iki.fi>
In-Reply-To: <4F7C4C3D.1090702@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 04/04/2012 15:27, Antti Palosaari ha scritto:
> IF frequency is frequency used between tuner and demodulator. Thus it
> should be same for the tuner, it is sender Tx, and for demodulator which
> receives it. As you can guess it is like radio channel, it will work if
> it is a little bit wrong but performance will be reduced.
> 
> IF frequency is generally more tuner characteristic than demodulator. I
> mean it is likely tuner decides which is optimal IF for signal tuner is
> transferring to demod. Earlier we used configuration option for both
> tuner and demod to set IF. But as the fact is tuner must know it always
> we added new tuner callback .get_if_frequency() demodulator can ask used
> IF from the tuner.
> 
> Recently I converted AF9013 driver to use that .get_if_frequency(). I
> think at that point I may have introduced some bug.
> 
> And one point to mention, it is sometimes used a little bit different
> IFs that are tuner defaults. It is somehow device design specific, for
> maximum performance device engineers will ran some test to find out
> optimal IF which gives best performance. One reason could be example
> there is RF noise peak (RF spurs) just in used IF which reduces
> performance => lets shift default IF a little bit for maximum performance.

I found out the origin of the problem: in the old "hacked" driver the
demodulator IF frequency was erroneously hard-coded to 4.57 MHz (like
with the mxl5007t tuner) so there was a mismatch between the tuner and
the demodulator IF setting.

In UHF band, the difference was only 0.57 MHz, so it still worked
(probably with reduced performance). Instead, in VHF band the difference
was over 1 MHz so it was not working. Hacking the tuner IF frequency to
4 MHz in VHF band was enough to get it working, but of course it was not
optimal.

In the end, there is no bug in the current code. Sorry for all the
unnecessary noise about this issue.

Regards,
Gianluca
