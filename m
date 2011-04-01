Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1DAAKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 20:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110227095154.2741d051.randy.dunlap@oracle.com>
References: <20110227095154.2741d051.randy.dunlap@oracle.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 31 Mar 2011 20:09:57 -0400
Message-ID: <AANLkTikQ3k_E1-7Hnxdgm1xRo4Q+Skw_-Yn_T4K35D2V@mail.gmail.com>
Subject: Re: [PATCH] media/radio/wl1273: fix build errors
To: Randy Dunlap <randy.dunlap@oracle.com>, stable@kernel.org
Cc: linux-media@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Mauro <mchehab@infradead.org>,
	Matti Aaltonen <matti.j.aaltonen@nokia.com>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 27, 2011 at 12:51, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> RADIO_WL1273 needs to make sure that the mfd core is built to avoid
> build errors:
>
> ERROR: "mfd_add_devices" [drivers/mfd/wl1273-core.ko] undefined!
> ERROR: "mfd_remove_devices" [drivers/mfd/wl1273-core.ko] undefined!

2.6.38 stable worthy ?

now in mainline as 1b149bbe9156d2eb2afd5a072bd61ad0d4bfaca7 ...
-mike
