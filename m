Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34359 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2JNKqR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Oct 2012 06:46:17 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2063332bkc.19
        for <linux-media@vger.kernel.org>; Sun, 14 Oct 2012 03:46:15 -0700 (PDT)
Message-ID: <507A97F4.7090302@googlemail.com>
Date: Sun, 14 Oct 2012 12:46:12 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils development snapshot 0.9.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'd like to announce the first development snapshot of the upcoming
0.10.x release. Compared to the latest stable version the biggest
changes are the introduction of the libv4l plugin API, the new RDS
library and utility and the DVBv5 library and tools. Additionally the
build system has been converted to autotools.

So please give it a try. It has been compile tested on Debian Sid,
Ubuntu Quantal, RHEL5 and RHEL6. The Ubuntu libv4l/development PPA will
be updated shortly.

The preliminary ChangeLog is the following:

* libv4l changes
  * Various Pixart JPEG fixes
  * Add more notebooks to the upside down device table
  * Use bytesperline instead of width (Robert Abel)
  * Better luminance quantization table for Pixart JPEG (Jean-Francois
Moine)
  * Fix out of bounds array usage
  * Prevent GCC 4.7 inlining error
  * Add support for libjpeg >= v7
  * Add new matching algorithm for upside down table
  * Retry with another frame on JPEG header decode errors
  * Improved JL2005BCD support (Theodore Kilgore)
  * Set errno to EIO if getting 4 consecutive EAGAIN convert errors
  * Make software autowhitebalance converge faster
  * Add quirk support for forced tinyjpeg fallback

* ir-keytable changes
  * Fixed file parsing errors
  * Add support for Sanyo IR and RC-5-SZ protocol
  * Add missing mouse buttons in shipped keytables

* libdvbv5 changes
  * Initial release

* qv4l2 changes
  * Fix segfault when there are no inputs or outputs
  * Fix endianess issues
  * Add support for new timing ioctls
  * Improve frequency and radio support
  * Add VBI support
  * Add ability to make a snapshot
  * Add support to stream raw frames into a file

* libv4l2rds and rds-ctl
  * Initial release (Konke Radlow)

* buildsystem changes
  * Converted buildsystem to autotools
  * Made buildsystem cross compiling friendly
  * Support out of tree builds

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.9.1.tar.bz2

You can always find the latest development branch here:
http://git.linuxtv.org/v4l-utils.git

Thanks,
Gregor
