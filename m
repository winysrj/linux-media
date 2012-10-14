Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52579 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2JNKS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Oct 2012 06:18:57 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2060495bkc.19
        for <linux-media@vger.kernel.org>; Sun, 14 Oct 2012 03:18:56 -0700 (PDT)
Message-ID: <507A918D.8010307@googlemail.com>
Date: Sun, 14 Oct 2012 12:18:53 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm happy to announce the release of v4l-utils-0.8.9. It contains purely
backports from the development branch. The most interesting additions
are the improvements for the Pixart based webcams and the updated
v4l2-compliance, v4l-ctl, and qv4l2 utilities.

ChangeLog:
* libv4l changes (0.9.x backports)
  * libv4lconvert: Various Pixart JPEG fixes
  * libv4lconvert: Add more notebooks to the upside down device table
* Utils changes (0.9.x backports)
  * keytable: Add support for Sanyo IR and RC-5-SZ protocol
  * keytable: Add missing buttons in shipped keytables
  * v4l2-compliance, v4l-ctl, qv4l2: Sync with development branch

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.9.tar.bz2

You can always find the latest developments and the stable branch here:
http://git.linuxtv.org/v4l-utils.git

Thanks,
Gregor
