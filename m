Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZJST37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 15:29:59 -0400
Date: Tue, 20 Oct 2009 04:29:13 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Romont Sylvain <psgman24@yahoo.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: ISDB-T tuner
Message-ID: <20091020042913.1d3609d7@caramujo.chehab.org>
In-Reply-To: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
References: <340263.68846.qm@web25604.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Romont,

Em Mon, 19 Oct 2009 12:16:30 +0000 (GMT)
Romont Sylvain <psgman24@yahoo.fr> escreveu:

> Hello!
> 
> I actually live in Japan, I try to make working a tuner card ISDB-T with
> linux. I searched a lot in internet but I find nothing....
> How can I make it working?
> My tuner card is a Pixela PIXDT090-PE0
> in picture here:  http://bbsimg01.kakaku.com/images/bbs/000/208/208340_m.jpg
> 
> Thank you for your help!!!

Unfortunately, only the Earthsoft PC1 board and the boards with dibcom 80xx USB
boards are currently supported. In the case of Dibcom, it can support several
different devices, but we may need to add the proper USB ID for the board at the driver.

I'm in Japan during this week for the Kernel Summit and Japan Linux Symposium.

One of objectives I'm expecting from this trip is to get more people involved on
creating more drivers for ISDB and other Asian digital video standards.



Cheers,
Mauro
