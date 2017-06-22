Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58627
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753259AbdFVPoD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:44:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by osg.samsung.com (Postfix) with ESMTP id C8268A14A3
        for <linux-media@vger.kernel.org>; Thu, 22 Jun 2017 15:44:30 +0000 (UTC)
Received: from osg.samsung.com ([127.0.0.1])
        by localhost (s-opensource.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EwLcL2Lsdkai for <linux-media@vger.kernel.org>;
        Thu, 22 Jun 2017 15:44:28 +0000 (UTC)
Received: from vento.lan (unknown [189.61.54.254])
        by osg.samsung.com (Postfix) with ESMTPSA id D9023A14A2
        for <linux-media@vger.kernel.org>; Thu, 22 Jun 2017 15:44:27 +0000 (UTC)
Date: Thu, 22 Jun 2017 12:43:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Subject: [ANN] Subsystem maintainership
Message-ID: <20170622124355.163a0b86@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We're in the process of better organizing the subsystem maintainership.

The whole idea is to setup an environment that will speedup patch
reviewing, while ensuring good quality of the patches applied upstream.

As result, the subsystem maintainers/sub-maintainers are now doing
regular meetings on Thursdays at 12AM UTC time, at #media-maint
channel. We will be keeping the logs at:
	https://linuxtv.org/irc/irclogger_log/media-maint

You'll see the results of the today's meeting there.

The goal of this channel is to discuss only patch handling related
issues. All technical discussions will happen via the usual channels:

	#linuxtv - for DVB related discussions
	#v4l - for all other parts of the subsystem

We're also reactivating the media-submaintainers@linuxtv.org mailing
list. We'll keep that list private, in order to allow us to handle
e-mails with a more private nature like vacations, travels, and other
matters that may require some sort of confidentiality in order to
not spread personal info to the world.

Feel free to use it, if you require some special attention from
media maintainers, but don't use it for technical discussions.

All technical discussions should happen at the media ML
(linux-media@vger.kernel.org).

We'll be soon discussing other matters related to media ML,
as we improve our maintainership process.

Thanks,
Mauro
