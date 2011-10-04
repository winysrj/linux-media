Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmsout02.mbox.net ([165.212.64.32]:47113 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1JDL5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 07:57:01 -0400
Date: Tue, 04 Oct 2011 13:56:56 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <o.endriss@gmx.de>, <sr@coexsi.fr>
Subject: RE: [DVB] CXD2099 - Question about the CAM clock
CC: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <198PJDL451344S01.1317729416@web01.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> I managed to find a series of values that are working correctly for MCLKI:
> 
> MCLKI = 0x5554 - i * 0x0c
> 
> In my case I can go down to 0x5338 before having TS errors.
> 

>From CXD2099 specs
--
It is a requirement for the frequency of MCLKI to be set higher than the input
data rate. ie 8
times TICLK. If this condition is not met then the internal buffer will
overflow and the register
TSIN_FIFO_OVFL is set to 1. This register should be read at regular intervals
to ensure reliable
operation.
--

Watch out that you're not slowly overflowing the internal buffer if MCLKI is
not fast enough...

Are you working with the ddbridge ?

--
Issa

