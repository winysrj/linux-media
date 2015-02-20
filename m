Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:40716 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbBTAKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 19:10:39 -0500
Received: by mail-qg0-f44.google.com with SMTP id j5so10767235qga.3
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 16:10:39 -0800 (PST)
Received: from [192.168.1.107] ([72.35.233.54])
        by mx.google.com with ESMTPSA id t16sm20872417qac.23.2015.02.19.16.10.37
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Feb 2015 16:10:38 -0800 (PST)
Message-ID: <54E67B77.5040208@gmail.com>
Date: Thu, 19 Feb 2015 19:10:31 -0500
From: Jeffrey O'Hara <oharajeffrey@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to get my Hauppauge USB-Live2 to capture VHS recordings 
using VLC Player. My computer will recognize the USB-Live2 but nothing 
shows on the screen when using VLC Player. Any suggestions?
Thank You


jeffrey@jeffrey-HP-2000-Notebook-PC:~$ git clone 
git://linuxtv.org/media_build.git
Cloning into 'media_build'...
remote: Counting objects: 2699, done.
remote: Compressing objects: 100% (1082/1082), done.
remote: Total 2699 (delta 1895), reused 2258 (delta 1577)
Receiving objects: 100% (2699/2699), 526.94 KiB | 38.00 KiB/s, done.
Resolving deltas: 100% (1895/1895), done.
Checking connectivity... done.
jeffrey@jeffrey-HP-2000-Notebook-PC:~$ cd media_build
jeffrey@jeffrey-HP-2000-Notebook-PC:~/media_build$ ./build
Checking if the needed tools for Zorin OS 9 are available
ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
I don't know distro Zorin OS 9. So, I can't provide you a hint with the 
package names.
Be welcome to contribute with a patch for media-build, by submitting a 
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./build line 266.
jeffrey@jeffrey-HP-2000-Notebook-PC:~/media_build$

