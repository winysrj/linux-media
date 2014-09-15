Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52566 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaIORHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 13:07:39 -0400
Received: by mail-ie0-f182.google.com with SMTP id tr6so5028201ieb.13
        for <linux-media@vger.kernel.org>; Mon, 15 Sep 2014 10:07:39 -0700 (PDT)
Received: from [10.9.9.111] (c-73-45-178-107.hsd1.il.comcast.net. [73.45.178.107])
        by mx.google.com with ESMTPSA id ro6sm10586055igb.3.2014.09.15.10.07.38
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2014 10:07:38 -0700 (PDT)
Message-ID: <54171CD9.4070801@gmail.com>
Date: Mon, 15 Sep 2014 12:07:37 -0500
From: Pavel <psem47@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Patch for media-build for Raspbian 7
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


pi@rasbein ~/media_build $ ./build
Checking if the needed tools for Raspbian GNU/Linux 7 \n \l are available
ERROR: please install "lsdiff", otherwise, build won't work.
ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
I don't know distro Raspbian GNU/Linux 7 \n \l. So, I can't provide you 
a hint with the package names.
Be welcome to contribute with a patch for media-build, by submitting a 
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 2 dependencies are missing at ./build line 267.

For  "lsdiff" dependency
sudo apt-get install patchutils

For "Proc::ProcessTable" dependency
sudo apt-get install libproc-processtable-perl

Pavel
