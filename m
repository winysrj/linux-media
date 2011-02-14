Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1BNAoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 19:44:05 -0500
Message-ID: <4D587ACD.6000908@redhat.com>
Date: Sun, 13 Feb 2011 22:43:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: jamenson@bol.com.br
CC: linux-media@vger.kernel.org
Subject: Re: Siano SMS1140 DVB Receiver on Debian 5.0 (Lenny)
References: <4d554a2295c4b_de09815034196@a2-winter4.tmail>
In-Reply-To: <4d554a2295c4b_de09815034196@a2-winter4.tmail>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-02-2011 12:39, jamenson@bol.com.br escreveu:
> Hi everyone.
> 
> I'm sorry if my question is a newbie question. I have a DVB receiver (Siano SMS1140).
<snip/>
> using settings for BRAZIL

I'm assuming that what you're trying to do is to use it for ISDB-T, right?

You may find some useful info (in Portuguese) at:
http://br-linux.org/2010/tv-digital-brasileira-no-linux-mais-drivers-experimentais-disponiveis/

The tree indicated there is outdated (it was a test tree I've created some time ago). The latest
drivers are available at the main devel tree. You may use the media_build tree to download and
compile with your kernel version:
	http://git.linuxtv.org/media_build.git

Also, AFAIK, vdr doesn't work with ISDB-T. The only application that I know for sure that works
with h.264/aac isdb-t decoding is vlc.

Cheers,
Mauro.
