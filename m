Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54916 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBJAbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 19:31:45 -0500
Subject: Re: cx18, HVR-1600 Clear qam tuning
From: Andy Walls <awalls@radix.net>
To: "Williams, Phil A" <phil.a.williams@lmco.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <CCB65A8C741893429D41536D8B5F6D921CCFF080@emss01m15.us.lmco.com>
References: <CCB65A8C741893429D41536D8B5F6D921CCFF080@emss01m15.us.lmco.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 19:32:30 -0500
Message-Id: <1234225950.3094.22.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-02-09 at 16:14 -0800, Williams, Phil A wrote:
> I'm using an HVR-1600, having a heck of a time, and wanted to give this
> patch a try. Can someone point me to a good wiki or howto on how to
> incorporate this patch?
> 
> >Devin just commited a patch to improve the lock time of the
> >cx24227/s5h1409 demodulator:
> >
> >http://linuxtv.org/hg/~dheitmueller/v4l-dvb-s5h1409/rev/6bb4e117a614


It's already in the latest v4l-dvb repo.

Here's a wiki link on setting up the latest cx18 driver from the v4l-dvb
repo:

http://www.ivtvdriver.org/index.php/Cx18

Regards,
Andy

