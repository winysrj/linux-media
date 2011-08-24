Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56603 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1HXUfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 16:35:42 -0400
Received: by bke11 with SMTP id 11so1189346bke.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 13:35:40 -0700 (PDT)
Message-ID: <4E556095.7070503@googlemail.com>
Date: Wed, 24 Aug 2011 22:35:33 +0200
From: Michael Abel <michael.abel84@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: installing git://linuxtv.org/media_build.git with basci approach
 on Gentoo
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

while installing git://linuxtv.org/media_build.git i got the error:

"ERROR: please install "lsdiff", otherwise, build won't work.
I don't know distro Gentoo Base System release 2.0.1-r1. So, I can't 
provide you a hint with the package names.
Be welcome to contribute with a patch for media-build, by submitting a 
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./build line 172."

If this error occurs on a Gentoo system  "emerge dev-util/patchutils" helps.

best regards

Michael Abel


