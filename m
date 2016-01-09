Return-path: <linux-media-owner@vger.kernel.org>
Received: from gromit.nocabal.de ([78.46.53.8]:40359 "EHLO gromit.nocabal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbcAIVtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 16:49:55 -0500
Date: Sat, 9 Jan 2016 22:42:37 +0100
From: Ernst Martin Witte <emw@nocabal.de>
To: Martin Witte <emw-linux-media-2016@nocabal.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REGRESSION/bisected] kernel panic after "rmmod cx23885" by
 "si2157: implement signal strength stats"
Message-ID: <20160109214237.GA25076@titiwu.nocabal.de>
Reply-To: emw@nocabal.de
References: <20160108121852.GA29971@[192.168.115.1]>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160108121852.GA29971@[192.168.115.1]>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

seems  that the  cause  for the  kernel  panic is  a  missing call  to
cancel_delayed_work_sync in  si2157_remove before  the call  to kfree.
After adding cancel_delayed_work_sync(&dev->stat_work), rmmod does not
trigger the kernel panic any more.

However, very similar issues could be identified also in other modules:

   ts2020
   af9013
   af9033
   rtl2830

when looking in drivers/media/tuners and drivers/media/dvb-frontends.

Therefore,  the submitted  patch  set contains  fixes  also for  those
modules. The submitted patch set is:

   [PATCH 0/5] [media] cancel_delayed_work_sync before device removal / kfree

I hope these patches completely fix the issue and are ok for inclusion
in the kernel.

BR and thx,
   Martin
