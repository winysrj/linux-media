Return-path: <mchehab@pedra>
Received: from hamster.davidecavalca.it ([166.84.6.52]:40311 "EHLO
	hamster.davidecavalca.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1AGKrN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 05:47:13 -0500
Received: from hamster.davidecavalca.it (localhost [127.0.0.1])
	by hamster.davidecavalca.it (Postfix) with ESMTP id 543EA1660D2
	for <linux-media@vger.kernel.org>; Fri,  7 Jan 2011 11:40:42 +0100 (CET)
Received: from [192.168.1.2] (dynamic-adsl-94-36-18-82.clienti.tiscali.it [94.36.18.82])
	by hamster.davidecavalca.it (Postfix) with ESMTPSA id D3E2C16604F
	for <linux-media@vger.kernel.org>; Fri,  7 Jan 2011 11:40:41 +0100 (CET)
Subject: pctv452e driver status
From: Davide Cavalca <davide@geexbox.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 11:40:38 +0100
Message-ID: <1294396838.2967.11.camel@sfera.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've managed to make my TechnoTrend TT-connect S2-3650 CI work using the
pctv452e driver from s2-lipianin on 2.6.35.10. It runs fine (both
regular and HD channels), but there are some minor issues:
- vdr-femon always reports a very low signal strenght (between 0 and
2%), I guess the driver is reporting an incorrect value
- about 1 out of 3 remote control key press is reported twice (I'm using
vdr-remote for it)
I haven't managed to test the CI part yet as I don't have any CI module
handy.

Are there any plans to merge this driver in the media tree and/or
eventually push it to the kernel?

Thanks,
Davide
