Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47929 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2CWDQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 23:16:42 -0400
Received: by vbbff1 with SMTP id ff1so1319382vbb.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 20:16:41 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 22:16:41 -0500
Message-ID: <CACZk-UH8Th1m5iuW7c78d1re6=HRZR1Q0+qOy=v_L77Ri1R04A@mail.gmail.com>
Subject: atsc_epg issue
From: Christopher Harrington <ironiridis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After some amateur debugging and mucking around with the source code
since I was getting segfaults while running atsc_epg from the latest
hg tip, I discovered two things:

atsc_text_segment_decode() will segfault if its second parameter is an
empty string
parse_events() is (for some reason I don't understand) passing an
empty string to atsc_text_segment_decode for every EIT I'm receiving.

Is there a way I can dump some more raw-ish EPG data so you guys can
take a look at it?

--
-Chris Harrington
Phone: 612.326.4248
