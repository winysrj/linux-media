Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58754 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2BAAZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 19:25:40 -0500
Received: by wics10 with SMTP id s10so482290wic.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 16:25:39 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 19:25:39 -0500
Message-ID: <CAF_KOvcporDYXL1FL7E7XZ5V3qr4QyOq=YSgvGTSRv-vRm__Nw@mail.gmail.com>
Subject: Package name for lsdiff for Zorin OS 5 is....
From: David M <paroxy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy,

I Was compiling drivers for this card...
I ran this command....

user@computer:~/media_build$ ./build

And got this error:

Checking if the needed tools for Zorin OS 5 are available
ERROR: please install "lsdiff", otherwise, build won't work.
I don't know distro Zorin OS 5. So, I can't provide you a hint with the
package names.
Be welcome to contribute with a patch for media-build, by submitting a
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./build line 202.

The secret answer is.... the package "patchutils"

David M.
