Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18322 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab0IPW7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 18:59:30 -0400
Subject: RFC: Move ivtv utilities and ivtv X video extension to v4l-utils
From: Andy Walls <awalls@md.metrocast.net>
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 18:58:45 -0400
Message-ID: <1284677925.2056.27.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans and Hans,

I'd like to move the source code maintained here:

http://ivtvdriver.org/svn/

to someplace where it may be less likely to suffer bit rot.
I was hoping the v4l-utils git repo would be an appropriate place.

Do either of you have any opinions on this?

If you think it would be acceptable, do you have a preference on where
they would be placed in the v4l-utils directory structure?

Thanks.

Regards,
Andy

