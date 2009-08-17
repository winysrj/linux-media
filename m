Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:48503 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZHQEu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 00:50:58 -0400
Received: from localhost.localdomain ([76.94.241.155])
          by cdptpa-omta04.mail.rr.com with ESMTP
          id <20090817045059583.EUVE6077@cdptpa-omta04.mail.rr.com>
          for <linux-media@vger.kernel.org>;
          Mon, 17 Aug 2009 04:50:59 +0000
Message-ID: <4A88E131.2000600@ca.rr.com>
Date: Sun, 16 Aug 2009 21:48:49 -0700
From: Dan Taylor <dan.taylor2@ca.rr.com>
Reply-To: danieltaylor@acm.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: re: xc2028 reloads firmware every time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'm not sure quite when this happened, since I haven't done updates in the past year.
> 
> With the older pull, I was able to load the tuner firmware for an Avermedia A16D
> (SAA7134 and xc3028, using the xc2028 module) once at system start (using mplayer
> to grab a few frames to ao and vo null), then it never needed to be loaded again,
> which reduced to startup times to match a pcHDTV 5500 that has no firmware to load.
> 
> Have anyone changed to code to require a firmware load on each open, or is this
> likely to be a side-effect of some other change?
> 
> Everything appears to be working, once the firmware is loaded, but this behavior
> (several seconds of blank screen while the firmware loads) is really obnoxious
> on an embedded system.

Sorry.  Puller the "ask" trigger too soon.

I found the module parameter no_poweroff.

Initial tests seem to be working.  I'll have to build the
module parameter option file into the embedded system now
to see that it that it works there, too.
