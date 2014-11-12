Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44470 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaKLNDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Nov 2014 08:03:05 -0500
Received: from recife.lan (unknown [187.57.175.207])
	by lists.s-osg.org (Postfix) with ESMTPSA id 98EF3462EC
	for <linux-media@vger.kernel.org>; Wed, 12 Nov 2014 05:03:03 -0800 (PST)
Date: Wed, 12 Nov 2014 11:02:59 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] avatar icons on cgit
Message-ID: <20141112110259.2466a416@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Today I updated cgit to support icons. For those that have patches merged on
the git trees hosted at LinuxTV that want to add its own customized avatar,
all that it is need is to create/add an avatar associated to the email used
at the patches on:

	https://www.libravatar.org

The icon will be displayed the next time the cgit cache gets refreshed
(typically, it may take up to 5 mins for dynamic pages, and 30 mins for
static ones).

Regards,
Mauro
