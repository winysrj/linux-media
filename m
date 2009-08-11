Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2031 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHKTGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 15:06:50 -0400
Received: from webmail.xs4all.nl (dovemail4.xs4all.nl [194.109.26.6])
	by smtp-vbr17.xs4all.nl (8.13.8/8.13.8) with ESMTP id n7BJ6kcS001715
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 21:06:50 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <f554f7485cc95254484c951ed52cb7ba.squirrel@webmail.xs4all.nl>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5
 icHrgBAAAAAA==@coolrose.fsnet.co.uk>
References: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk>
Date: Tue, 11 Aug 2009 21:06:50 +0200
Subject: Re: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-media@vger.kernel.org
Reply-To: n.wagenaar@xs4all.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op Di, 11 augustus, 2009 20:32, schreef Christopher Thornley:
> -- SNIP --
>
> I probably would like to get both the S2API and Multiprot methods
> working.
>
> Many Thanks
> Chris

That won't be possible. It's S2API or Multiproto. And since S2API is the
official standard - besides the fact that Multiproto is old and absolete -
you should forget about Multiproto.

So in short, your DVB devices should be used using the S2API drivers. You
can use v4l or s2-liplianin (I use s2-liplianin myself) which are both
S2API. Only v4l is the official tree while s2-liplianin is more
experimental. After fetching v4l or s2-liplianin you can easily install
them for your kernel using: make ; make install ; reboot.

Then check if your cards were detected using dmesg (it should tell you
information if the DVB devices were detected) and you can check /dev/dvb.
You should have two folders containing adapter0 and adapter1.

Normally, a simple check would be to use a DVB application like Kaffeine.
Alternatively you can use MythTV 0.22 (which supports S2API), VDR 1.7.0
with my S2API patch or VDR 1.7.4 or higher (latest version is 1.7.8).

Regards,

Niels Wagenaar


