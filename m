Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbaEHTl3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 15:41:29 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s48JfThu001144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 8 May 2014 15:41:29 -0400
Received: from shalem.localdomain.com (vpn1-5-220.ams2.redhat.com [10.36.5.220])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s48JfS2G029599
	for <linux-media@vger.kernel.org>; Thu, 8 May 2014 15:41:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] rc_keymaps: Add 3 keymaps for various allwinner android tv
Date: Thu,  8 May 2014 21:41:24 +0200
Message-Id: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

These patches add keymaps for the remotes found with various allwinner android
tv boxes. I've checked that these are not duplicate with existing configs.

These tv-boxes can run regular Linux, and that is what these keymaps are
intended for.

If there are no objections I'm going to push these in a couple of days.

Regards,

Hans
