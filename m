Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37797 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbcFOUZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 16:25:10 -0400
Received: by mail-wm0-f54.google.com with SMTP id a66so28779587wme.0
        for <linux-media@vger.kernel.org>; Wed, 15 Jun 2016 13:25:09 -0700 (PDT)
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
From: Gregor Jasny <gjasny@googlemail.com>
Subject: Need help with ir-keytable imon bug report
Message-ID: <ac402439-e317-9d83-6c70-df592cc3cf63@googlemail.com>
Date: Wed, 15 Jun 2016 22:25:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

could someone please help me triaging the following ir-keytable bug? The
reporter complains that the 'other' IR protocol results in double clicks
and we should set the device to RC6 instead:

https://bugs.launchpad.net/ubuntu/+source/v4l-utils/+bug/1579760

This is what we have in v4l-utils:
https://git.linuxtv.org/v4l-utils.git/tree/utils/keytable/rc_keymaps/imon_pad

Thanks for you help,
Gregor
