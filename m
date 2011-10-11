Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36364 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1JKSR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 14:17:58 -0400
Received: by wwn22 with SMTP id 22so5574227wwn.1
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 11:17:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110101752.11536.liplianin@me.by>
References: <201110101752.11536.liplianin@me.by>
Date: Tue, 11 Oct 2011 14:17:57 -0400
Message-ID: <CALzAhNUOrg38VkNLq1Nbm+Wbv8OD0wXKK3TSuXez1n1q_uMLDw@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 3.2] cx23885 alsa cleaned and prepaired
From: Steven Toth <stoth@kernellabs.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
	Steven Toth <stoth@linuxtv.org>,
	Mijhail Moreyra <mijhail.moreyra@gmail.com>,
	Abylai Ospan <aospan@netup.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> It's been a long time since cx23885-alsa pull was requested.
> To speed things up I created a git branch where I put the patches.
> are available in the git repository at:

...

>  git://linuxtv.org/liplianin/media_tree.git cx23885-alsa-clean-2

Thank you for working on this Igor.

I most certainly have some additional patches that will probably no
longer apply cleanly. However, given that you've gone to the trouble
of building a new tree, assuming we can get these merged, then I'll
rebase and regenerate any patches I have to match the current cx23885
driver.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
