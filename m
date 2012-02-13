Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35204 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2BMQLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 11:11:40 -0500
Received: by wics10 with SMTP id s10so3559648wic.19
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2012 08:11:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <jh3ep3$bm8$1@dough.gmane.org>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com>
 <CAJ_iqtY2y5+jo2rirm1LbfDHVytcnaXE5x+KuA_MD-H5N4pnwA@mail.gmail.com>
 <CAJ_iqtauqw0KPO19q4cc527tKv-0PW-SLoQGfb_dob4Nwv8g6A@mail.gmail.com> <jh3ep3$bm8$1@dough.gmane.org>
From: Eddi De Pieri <eddi@depieri.net>
Date: Mon, 13 Feb 2012 17:11:19 +0100
Message-ID: <CAKdnbx6z-Z63RxtHTEE4AtiOV08a6886qO03D+dGoX=LDN_JMw@mail.gmail.com>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
To: Jason Krolo <jasonjvk@aol.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

> I didn't test dvb-t terrestrial, but under /dev/dvb i have only one adapter.
> Is there no need for two, one for cable, another for terrestrial?

Try using dvb-fe-tool from following git:

"http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvbv5-0.0.1"

This tool allow switching the delivery system from DVB-C to DVB-T (and
other if supported)

Eddi
