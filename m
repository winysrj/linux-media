Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45555 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934978Ab2JYJqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 05:46:50 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1204529lag.19
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 02:46:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Oct 2012 10:46:49 +0100
Message-ID: <CAOQWjw3ONK7FmQ+vMnWeMRpN-ED3jyMTUd++Enk+25Z2e2QL2A@mail.gmail.com>
Subject: Problems with checksum files for driver tarballs
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've recently had cause to download recent driver tarballs from:

http://www.linuxtv.org/downloads/drivers/

A tarball and MD5 checksum is provided for each driver release. I've
noticed the following issues when using the checksum files to validate
a downloaded file:


1. Use of absolute paths in checksum file

Each entry in a checksum file includes an absolute path to the
tarball. E.g. http://www.linuxtv.org/downloads/drivers/linux-media-2012-10-19.tar.bz2.md5
includes:

  $ cat linux-media-2012-10-19.tar.bz2.md5
  a1754d21e4bf943460a3ca75334a1c63
/home/mchehab/tmp/new_build/linux-media-2012-10-19.tar.bz2

Running `md5sum --check` with a checksum file will therefore fail as
the tarball will not be found (unless you happen to be Mauro).

Removing any path information that a user is unlikely to have on their
system will allow md5sum to work if the tarball and checksum are
located in any common directory.


2. Validating the 'LATEST' driver tarball

The latest driver tarball is made available at the above address with filename:

  http://www.linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2

A checksum for this file is also made available

  http://www.linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5

However, the contents of the checksum file reference an 'actual'
tarball release, and not this 'symlinked' LATEST filename:

  $ cat linux-media-LATEST.tar.bz2.md5
  a1754d21e4bf943460a3ca75334a1c63
/home/mchehab/tmp/new_build/linux-media-2012-10-19.tar.bz2

Separate to the path problem discussed above, the filename the
checksum references will not exist if a user downloads the
linux-media-LATEST.tar.bz2 file. This will stop md5sum in its tracks
from validating the download.

In this case, the LATEST checksum needs to reference the LATEST
tarball in order for md5sum to be able to make use of it.


Thanks,
Nick
