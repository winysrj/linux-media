Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:55267 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab0AIXCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 18:02:04 -0500
Subject: Re: Leadtek Winfast TV2100
From: hermann pitton <hermann-pitton@arcor.de>
To: dz-tor <dz-tor@wp.pl>
Cc: Pavle Predic <pavle.predic@yahoo.co.uk>,
	video4linux-list@redhat.com, LMML <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <1263057295.3870.27.camel@pc07.localdom.local>
References: <4B40B9CC.1040108@wp.pl>
	 <1262979242.3246.10.camel@pc07.localdom.local> <4B47B836.3000108@wp.pl>
	 <279441.7775.qm@web28406.mail.ukl.yahoo.com>  <4B48AD64.1000505@wp.pl>
	 <1263057295.3870.27.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 09 Jan 2010 23:48:34 +0100
Message-Id: <1263077314.3870.41.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

sorry, there is a typo in the gpio mask on previously attached patch you
might use against current v4l-dvb with your further findings.

Mask 0x0d is sufficient and we don't need any 0xe0d :(

You might also consider to start with vmux = 3 for Composite1 and vmux =
0 for Composite2, that is expected to be over the S-Video connector and
should work too.

Does save some plugging around with two composite input devices, if
S-Video is not in use.

good night,
Hermann


