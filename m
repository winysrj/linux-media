Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48310 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZF2OAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 10:00:14 -0400
Received: by gxk26 with SMTP id 26so3896496gxk.13
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2009 07:00:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 10:00:15 -0400
Message-ID: <829197380906290700n16a0f4faxd29caa12587222f7@mail.gmail.com>
Subject: Call for testers: Terratec Cinergy T XS USB support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

A few weeks ago, I did some work on support for the Terratec Cinergy T
XS USB product.  I successfully got the zl10353 version working and
issued a PULL request last week
(http://www.kernellabs.com/hg/~dheitmueller/em28xx-terratec-zl10353)

However, the other version of the product, which contains a mt352 is
not yet working.

I am looking for people who own the device and would be willing to do
testing of a tree to help debug the issue.  Ideal candidates should
have the experience using DVB devices under Linux in addition to some
other known-working tuner product so we can be sure that certain
frequencies are available and that the antenna/location work properly.
 If you are willing to provide remote SSH access for short periods of
time if necessary, also indicate that in your email.

Please email me if you are interested in helping out getting the device working.

Thank you,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
