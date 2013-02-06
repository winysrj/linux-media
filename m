Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62306 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab3BFVbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 16:31:47 -0500
Received: by mail-ve0-f172.google.com with SMTP id cz11so1737423veb.3
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 13:31:44 -0800 (PST)
MIME-Version: 1.0
From: Eddi De Pieri <eddi@depieri.net>
Date: Wed, 6 Feb 2013 22:31:23 +0100
Message-ID: <CAKdnbx4rpTMHuuztTSHzpKwU_nJCNKuZH3uUz+MR8WKUSsBJAg@mail.gmail.com>
Subject: IS_ENABLED media_build issue
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm backporting media_tree drivers to linux 3.3.6.

For a strange reason, IS_ENABLED macro fails.

I had to force definition of NEED_IS_ENABLED to make drivers to build.

Any idea?


Regards, Eddi
