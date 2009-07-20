Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:2023 "EHLO
	surfers.oz.promptu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753769AbZGTXZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 19:25:24 -0400
Received: from pacific.oz.agile.tv (pacific.oz.promptu.com [192.168.16.16])
	by surfers.oz.promptu.com (Postfix) with SMTP id 59078A65E6
	for <linux-media@vger.kernel.org>; Tue, 21 Jul 2009 09:25:17 +1000 (EST)
Date: Tue, 21 Jul 2009 09:25:17 +1000
From: Bob Hepple <bhepple@promptu.com>
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV DVB-T Dual Digital 4 gives
 "bulk message failed"
Message-Id: <20090721092517.f78bb46c.bhepple@promptu.com>
In-Reply-To: <20090720094903.7a6a849c.bhepple@promptu.com>
References: <20090615113315.0fdfbe62.bhepple@promptu.com>
	<20090720094903.7a6a849c.bhepple@promptu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Jul 2009 09:49:03 +1000
Bob Hepple <bhepple@promptu.com> wrote:

> I have been able to import the channels.conf file into mythtv and then
> all is well there. Hope that helps someone else struggling with this!!

Actually, that's not quite accurate - with the 2.6.27 drivers and
scandvb's channels.conf file, mythtv still can't tune the second tuner.
So as a nasty workaround, on every boot (in /etc/rc.local) I need to
use tzap to tune both tuners to _something_ for a few seconds and then
exit. Only then is mythtv happy - but it's very happy on both tuners! Weird.


Bob

-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
