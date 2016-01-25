Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34287 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbcAYSiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 13:38:18 -0500
Received: by mail-yk0-f174.google.com with SMTP id a85so171523745ykb.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2016 10:38:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A6680B.9050200@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
	<56818B7B.8040801@users.sourceforge.net>
	<20160125150654.7ada12ac@recife.lan>
	<56A6680B.9050200@users.sourceforge.net>
Date: Mon, 25 Jan 2016 13:38:17 -0500
Message-ID: <CAGoCfix7eRYMiFRaoWn03rEt1bdQYz5YtaFyxLUAs=WZ9q9jwQ@mail.gmail.com>
Subject: Re: [PATCH] [media] xc5000: Faster result reporting in xc_load_fw_and_init_tuner()
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Are you interested in a bit of software optimisation for the implementation
> of the function "xc_load_fw_and_init_tuner"?

To be clear, absolutely none of the code in question is performance
sensitive (i.e. saving a couple of extra CPU cycles has no value in
this case).  Hence given that I'm assuming you have no intention to
actually test any of these patches with a real device I would
recommend you do the bare minimum to prevent Coccinelle from
complaining and not restructure any of the core business logic unless
you plan to also do actual testing.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
