Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65094 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZIUWhv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 18:37:51 -0400
Received: by bwz6 with SMTP id 6so2270124bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 15:37:53 -0700 (PDT)
Date: Tue, 22 Sep 2009 01:37:51 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: xc2028 sound carrier detection
Message-ID: <20090921223751.GA1303@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is xc2028 tuner able to autodetect/handle different sound carrier standards
without being spoon-fed precise input system information using module param
or ioctl?

Got an ivtv board here (AverTV MCE 116) with xc2028 and cx25843.

When I specify a generic standard using 'v4l2-ctl -s pal', xc2028 loads
firmware specific to PAL-BG, so if there is an PAL-DK or PAL-I signal on RF
input... nice picture but no sound. Setting a more precise standard like
'v4l2-ctl -s pal-dk' fixes the issue, but other PAL-BG or PAL-I channels
loose sound.

Bttv board with a tin-can tuner sitting on the same RF source autodetects
PAL-BG, PAL-DK and PAL-I without any manual intervention.

So any voodoo tricks to get the autodetection running?
