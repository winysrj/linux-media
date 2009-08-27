Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZH0Tf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 15:35:57 -0400
Received: from localhost ([127.0.0.1] ident=martin)
	by egon.zuhause with esmtp (Exim 4.69)
	(envelope-from <linux@martin-kittel.de>)
	id 1MgkY7-00044Z-1M
	for linux-media@vger.kernel.org; Thu, 27 Aug 2009 21:22:19 +0200
Message-ID: <4A96DCEA.1060803@martin-kittel.de>
Date: Thu, 27 Aug 2009 21:22:18 +0200
From: Martin Kittel <linux@martin-kittel.de>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: HVR 1300: DVB channel lock problems since 2.6.28
References: <loom.20090825T192551-363@post.gmane.org> <4A944ACA.5010800@hubstar.net> <4A958A40.8010001@martin-kittel.de> <4A9599B6.7050803@hubstar.net>
In-Reply-To: <4A9599B6.7050803@hubstar.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ldone@hubstar.net wrote:
> Another suggestion, in mythtv, try increasing the signal something
> timeout - I think the default is 1500ms.
> 
> Or scan  has an option -5 (I think -- sorry its been a while and my box
> is recording) that increases the time wait before giving up.
> 

I stand corrected. scan seems to find all channels while mythTV doesn't
find any with 2.6.31-rc7. I have tried all various (very) high time
waits with no success.
I think I have to head over to the mythTV list...

Thanks for your help!

Martin.

