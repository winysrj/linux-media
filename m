Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3AJR16 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 12:27:58 -0500
Date: Thu, 10 Jan 2013 15:27:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Goga777 <goga777@bk.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: dvb-apps - scan-s2 & szap-s2
Message-ID: <20130110152720.6e6a934a@redhat.com>
In-Reply-To: <20130110204041.116fd9a4@bk.ru>
References: <20130110204041.116fd9a4@bk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Jan 2013 20:40:41 +0400
Goga777 <goga777@bk.ru> escreveu:

> Hi
> 
> is there any plans to update dvb-apps repo and to add in it actual version of scan-s2 and szap-s2 ? 

Nobody is maintaining dvb-apps for a long time.

I wrote a few years ago a patch adding DVBv5 support there at dvb-apps,
but it was very complex, as, internally, it has an abstraction layer
that it is too bound to the way the DVBv3 API works, IMHO. 

It ends that rewriting from scratch were simpler than fixing dvb-apps for
every single new delivery system.

If you want to use scan/zap with a delivery system different than DVB-T/C/S
or ATSC, I suggest you to use dvbv5 tools at:
	http://git.linuxtv.org/v4l-utils.git

They were written to work with DVBv5 API (it also supports DVBv3 - of course
without S2/T2 support) and should work with DVB-S2, DVB-T2, etc.

Regards,
Mauro
