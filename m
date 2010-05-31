Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55002 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0EaPr0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 11:47:26 -0400
Received: by gye5 with SMTP id 5so351192gye.19
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 08:47:25 -0700 (PDT)
MIME-Version: 1.0
From: Jonathan Isom <jeisom@gmail.com>
Date: Mon, 31 May 2010 10:47:03 -0500
Message-ID: <AANLkTilRkoWZnMKW7Yu6mjBPhkDyZxvKJokVilZWOjRr@mail.gmail.com>
Subject: nxt200x: Timeout waiting for nxt2004 to init.
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a quick question.  I have an Kworld atsc 110 and 115.
after 2 1/2 days I have 1624 dmesg "Timeout waiting for nxt2004 to init" lines.
My understanding is once something in inititialize you shouldn't need
to do it again.
is the a reason it needs to init  repeatedly?  The cards are
functioning fine with mythtv.

Thanks

Jonathan

Sample with timing
--------------->8--------------------------------------------------
[211844.717390] nxt200x: Timeout waiting for nxt2004 to init.
[211864.496286] nxt200x: Timeout waiting for nxt2004 to init.
[211890.602194] nxt200x: Timeout waiting for nxt2004 to init.
[211904.394297] nxt200x: Timeout waiting for nxt2004 to init.
[211924.747026] nxt200x: Timeout waiting for nxt2004 to init.
[212302.550277] nxt200x: Timeout waiting for nxt2004 to init.
[212314.356295] nxt200x: Timeout waiting for nxt2004 to init.
[212335.245278] nxt200x: Timeout waiting for nxt2004 to init.
[212351.161394] nxt200x: Timeout waiting for nxt2004 to init.
[212365.098031] nxt200x: Timeout waiting for nxt2004 to init.
[212399.819294] nxt200x: Timeout waiting for nxt2004 to init.
[212435.198162] nxt200x: Timeout waiting for nxt2004 to init.
[212442.446145] nxt200x: Timeout waiting for nxt2004 to init.
[212446.674303] nxt200x: Timeout waiting for nxt2004 to init.
[212460.008295] nxt200x: Timeout waiting for nxt2004 to init.
[212461.655279] nxt200x: Timeout waiting for nxt2004 to init.
[212465.454277] nxt200x: Timeout waiting for nxt2004 to init.
[212498.875026] nxt200x: Timeout waiting for nxt2004 to init.
[212514.791276] nxt200x: Timeout waiting for nxt2004 to init.
[212520.409467] nxt200x: Timeout waiting for nxt2004 to init.
[212533.584468] nxt200x: Timeout waiting for nxt2004 to init.
[212537.880279] nxt200x: Timeout waiting for nxt2004 to init.
[213510.585294] nxt200x: Timeout waiting for nxt2004 to init.
[213526.196301] nxt200x: Timeout waiting for nxt2004 to init.
[213549.076155] nxt200x: Timeout waiting for nxt2004 to init.
[213553.143013] nxt200x: Timeout waiting for nxt2004 to init.
[213561.282205] nxt200x: Timeout waiting for nxt2004 to init.
[213612.284277] nxt200x: Timeout waiting for nxt2004 to init.
[213617.087032] nxt200x: Timeout waiting for nxt2004 to init.
[213624.669319] nxt200x: Timeout waiting for nxt2004 to init.
[213626.324344] nxt200x: Timeout waiting for nxt2004 to init.
[213720.884172] nxt200x: Timeout waiting for nxt2004 to init.
[213731.081026] nxt200x: Timeout waiting for nxt2004 to init.
[213754.500280] nxt200x: Timeout waiting for nxt2004 to init.
[213761.917152] nxt200x: Timeout waiting for nxt2004 to init.
[214210.566403] nxt200x: Timeout waiting for nxt2004 to init.
[214218.086204] nxt200x: Timeout waiting for nxt2004 to init.
[214226.801295] nxt200x: Timeout waiting for nxt2004 to init.
[214227.838212] nxt200x: Timeout waiting for nxt2004 to init.
[214247.973356] nxt200x: Timeout waiting for nxt2004 to init.
[214250.661033] nxt200x: Timeout waiting for nxt2004 to init.
[214271.082031] nxt200x: Timeout waiting for nxt2004 to init.
[214273.469366] nxt200x: Timeout waiting for nxt2004 to init.
[214281.378038] nxt200x: Timeout waiting for nxt2004 to init.
[214363.528204] nxt200x: Timeout waiting for nxt2004 to init.
[214375.779286] nxt200x: Timeout waiting for nxt2004 to init.
[214410.896042] nxt200x: Timeout waiting for nxt2004 to init.
[214450.769296] nxt200x: Timeout waiting for nxt2004 to init.
[214454.652042] nxt200x: Timeout waiting for nxt2004 to init.
[214457.722314] nxt200x: Timeout waiting for nxt2004 to init.
[214518.751148] nxt200x: Timeout waiting for nxt2004 to init.
[215357.898211] nxt200x: Timeout waiting for nxt2004 to init.
[215364.899033] nxt200x: Timeout waiting for nxt2004 to init.
[215370.457203] nxt200x: Timeout waiting for nxt2004 to init.
[215386.914171] nxt200x: Timeout waiting for nxt2004 to init.
[215392.677279] nxt200x: Timeout waiting for nxt2004 to init.
[215410.894040] nxt200x: Timeout waiting for nxt2004 to init.
[215420.185278] nxt200x: Timeout waiting for nxt2004 to init.
[215449.908211] nxt200x: Timeout waiting for nxt2004 to init.
[215464.256277] nxt200x: Timeout waiting for nxt2004 to init.
[215479.878277] nxt200x: Timeout waiting for nxt2004 to init.
[215496.286193] nxt200x: Timeout waiting for nxt2004 to init.
[215503.028286] nxt200x: Timeout waiting for nxt2004 to init.
[215514.881166] nxt200x: Timeout waiting for nxt2004 to init.
[215543.269221] nxt200x: Timeout waiting for nxt2004 to init.
[215561.433213] nxt200x: Timeout waiting for nxt2004 to init.
[215596.010294] nxt200x: Timeout waiting for nxt2004 to init.
[215641.442934] nxt200x: Timeout waiting for nxt2004 to init.
[215642.540277] nxt200x: Timeout waiting for nxt2004 to init.
[215643.524211] nxt200x: Timeout waiting for nxt2004 to init.
[215650.046294] nxt200x: Timeout waiting for nxt2004 to init.
