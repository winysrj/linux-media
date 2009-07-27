Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:36513 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZG0MwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 08:52:20 -0400
Received: by pzk42 with SMTP id 42so63632pzk.33
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2009 05:52:20 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 22:52:20 +1000
Message-ID: <abdeb1ba0907270552k482674bbv5b156a583490b157@mail.gmail.com>
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 gives "bulk message failed"
From: Anne Aileus <annealieus@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Further to Bob's email below, I confirm that this regression is
present in 2.6.30.2.

Once the problem occurs, I see the following message repeatedly in my logs:

Jul 27 21:49:21 f kernel: [ 2990.204264] dvb-usb: bulk message failed:
-110 (1/0)

>From what I can see, the problem can be remedied with a cold boot, at
least sometimes.
However, after running for a while, the problem reoccurs.   More
particularly, the card seems to work for a while when the device is
found in a 'cold' state.

With that in mind, I (naively) altered dvb-usb-init.c to try to load
firmware regardless of whether the device was cold or warm.   I also
tried increasing the timeout passed to usb_bulk_msg in dvb_usb_urb.c.
Neither approach made the card work reliably.

Would somebody more experienced than me please suggest a helpful
location for a printk or some other way to instrument this part of the
code to track down the problem?

Thanks!


-------------------------------------------------
Bob Hepple
Mon, 20 Jul 2009 16:25:29 -0700

On Mon, 20 Jul 2009 09:49:03 +1000
Bob Hepple <bhep...@promptu.com> wrote:

> I have been able to import the channels.conf file into mythtv and then
> all is well there. Hope that helps someone else struggling with this!!

Actually, that's not quite accurate - with the 2.6.27 drivers and
scandvb's channels.conf file, mythtv still can't tune the second tuner.
So as a nasty workaround, on every boot (in /etc/rc.local) I need to
use tzap to tune both tuners to _something_ for a few seconds and then
exit. Only then is mythtv happy - but it's very happy on both tuners! Weird.


Bob

-- 
Bob Hepple <bhep...@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majord...@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
