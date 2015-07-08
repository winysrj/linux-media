Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57690 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbbGHLQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2015 07:16:27 -0400
Date: Wed, 8 Jul 2015 08:16:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>, media-workshop@linuxtv.org
Subject: [ANNOUNCE] Media Controller workshop in Helsinki
Message-ID: <20150708081622.63e333bd@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As discussed on our IRC #v4l channel at Freenode, we'll be running a 3-day 
Media Controller workshop in Helsinki between July 29-31.

The main goal of this workshop is to fixup the problems with the Media
Controller API to properly represent device nodes and the control tree,
as this is a requirement for the Media Controller to be used by DVB, ALSA
and radio devices.

This is an invitation-only event, as we want to be sure that we'll have
there people that are actively working with the Media Controller, DVB
and/or ALSA. So, if you think this is for you, please send us an e-mail.

Also, even if you're not able to participate, feel free to submit relevant
topics related to the Media Controller, in order to help us to build
the workshop's agenda and take other needs into account when working on
the needed API changes.

As usual, we'll be using the media-workshop@linuxtv.org ML for the
specific discussions about that, so the ones interested on participate
on such discussions and/or be present there are requested to subscribe
it, and to submit themes of interest via the mailing lists.

For those interested on this theme, I'll add a list of the most relevant
past discussions about this theme.

Hope to see you there!

Regards,
Mauro

---

The DVB needs with regards to MC are mapped on those two blog entries:
	http://blogs.s-osg.org/media-controller-support-for-dvb-part-1/
	http://blogs.s-osg.org/the-role-of-dtv-network-interfaces-in-media-controller-support-for-dvb/

We had two discussions about MC on our last mini-summit, back on March, 26.
The discussions and slides can be found at:
	http://linuxtv.org/news.php?entry=2015-05-05.mchehab
	http://www.linuxtv.org/downloads/presentations/media_summit_2015_US/dtv_media_controller_discussion_v1.pdf

A summary of the issues can also be seen on the emails below:
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg85910.html
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg85979.html
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg83883.html
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg83884.html

Patches that minimally expose DVB via MC were merged on Kernel 4.1,
although it is currently marked as BROKEN, in order to tag those API
extensions as likely to change on future versions.

The initial patchset proposal for ALSA support on MC is there at:
	http://www.spinics.net/lists/linux-media/msg89574.html

The most recent proposal for such fixup can be seen at:
	http://www.spinics.net/lists/linux-media/msg91365.html
