Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:46130 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbZBQQrU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 11:47:20 -0500
Message-ID: <499AEA15.7070800@linuxtv.org>
Date: Tue, 17 Feb 2009 17:47:17 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Trent Piepho <xyzzy@speakeasy.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
References: <4986507C.1050609@googlemail.com>	<200902151336.17202@orion.escape-edv.de>	<Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>	<20090216153148.6f2aa408@pedra.chehab.org>	<4999BADF.6070106@linuxtv.org>	<Pine.LNX.4.58.0902161611300.24268@shell2.speakeasy.net> <499AD4E7.1030306@linuxtv.org>
In-Reply-To: <499AD4E7.1030306@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steven Toth wrote:
> A general question to the group: Who wants to volunteer to retro fit 
> videobuf_dvb into the current drivers so we can avoid calls to sw_filter_...n() 
> directly?

Can videobuf_dvb be used by hardware with MPEG decoders, too? My
(probably not up-to-date) impression was that it's been designed
specifically for "budget" cards with no demux or decoder hardware. But
the sw_filter functions are useful for those devices, too, i.e. to
feed a PID to multiple userspace clients or to provide section filters
where some kind of hardware only provides basic PID filtering.

Regards,
Andreas
