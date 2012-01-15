Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61689 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2AOWUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 17:20:32 -0500
Received: by bkas6 with SMTP id s6so199747bka.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 14:20:30 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Jan 2012 23:20:29 +0100
Message-ID: <CAEN_-SBJyvyFptZWPk4dKXnTsU3-HLMnx8zWaL6RudSDAF2heg@mail.gmail.com>
Subject: cx25840: improve audio for cx2388x drivers
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modified RegSpy.exe with patch, i used it to spot register changes in
cx23885 and cx25840 chipsets.

http://www.speedyshare.com/file/sVqSY/RegSpy.zip
http://www.2shared.com/file/E_Gdj0ic/RegSpy.html

Extra info: This RegSpy.exe is not enough, because some changes are
fast, so if someone wants to use it it will be better to modify and
remove unneded registers and change update time. I used this to
display only 5 main values while recording window frame after frame to
spot exact order of changes in registers.

M.
