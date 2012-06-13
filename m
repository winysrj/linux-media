Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40258 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2FMO4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 10:56:09 -0400
Received: by yhmm54 with SMTP id m54so593904yhm.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 07:56:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BE0BB692-35BF-42C3-B2F1-5AC9AB053321@dinkum.org.uk>
References: <CAPz3gmnaPdm1V6GyPB8wPv5WCcg_pJ4HctsQiqROLanbLA=amA@mail.gmail.com>
	<BE0BB692-35BF-42C3-B2F1-5AC9AB053321@dinkum.org.uk>
Date: Wed, 13 Jun 2012 16:56:08 +0200
Message-ID: <CAPz3gmke-ASEXzhcqn+9R-5f10hrux3cqS1NAQ6VYmH3JSjb-Q@mail.gmail.com>
Subject: Re: Hauppauge WinTV Nova S Plus Composite IN
From: shacky <shacky83@gmail.com>
To: Andre <linux-media@dinkum.org.uk>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> mencoder -oac lavc -ovc lavc -of mpeg -mpegopts format=dvd:tsaf   -vf scale=720:576,harddup -srate 48000 -af lavcresample=48000   -lavcopts vcodec=mpeg2video:vrc_buf_size=1835:vrc_maxrate=9800:vbitrate=8000:keyint=15:vstrict=0:acodec=ac3:abitrate=192:aspect=4/3 -ofps 25   -o johntest1.mpg tv:// -tv input=1:norm=PAL-BG:amode=1:alsa=1:adevice=hw.2,0:forceaudio:immediatemode=0:volume=100

Thank you very much Andre! It works!

I only have a problem with the audio quality: it is distorted
especially on the high frequencies.
Do you have any idea?
