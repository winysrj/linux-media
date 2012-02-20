Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57184 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 04:40:50 -0500
Received: by vcge1 with SMTP id e1so3491639vcg.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 01:40:49 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 20 Feb 2012 22:40:49 +1300
Message-ID: <CADPG+0vLYJycDjn9kFyeLPaaz6F=-dWOUWhFbsxZd0-On_v=Sw@mail.gmail.com>
Subject: Hauppauge USB-Live2 - Apparent audio regression from
 linux-media-2012-01-11.tar.bz2 onwards.
From: ". ." <thunderbirduser0001@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Hauppauge USB-Live2 ( lsusb -> Bus 001 Device 003: ID
2040:c200 Hauppauge ). Up to and including kernel 3.0.0-16 generic,
video capture does not work with the drivers built into the kernel.
However, since July 2011, when Devin Heitmueller posted this message
http://www.mail-archive.com/linux-media@vger.kernel.org/msg34771.html,
the device has been working fine if the media_build procedure is done
(i.e. git clone git://linuxtv.org/media_build.git; cd media_build;
./build; make install). The problem that I have now is that audio
capture has stopped working if I build and install the current
media_build tree. The output from dmesg looks normal, the ALSA device
Cx231xxAudio [Cx231xx Audio] is present, everything looks in order,
but if I try to use the device I get one loud click then silence.
Building the dated tarballs that I find at
http://linuxtv.org/downloads/drivers/, I find that audio works fine up
to the tarball labelled linux-media-2012-01-08.tar.bz2, but
linux-media-2012-01-11.tar.bz2 seems to introduce the audio problem
which as of last week remained in the latest code. Video capture still
works fine, only audio is affected. It looks like here:
http://git.linuxtv.org/media_tree.git/shortlog is where I should be
able to see logs of what changed between version 2012-01-08 and
2012-01-11, however there appear to be no updates since end of October
2011. Have these logs been moved elsewhere?

Thanks,

Mark
