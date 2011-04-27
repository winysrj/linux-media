Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1D0POB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 11:14:01 -0400
Message-ID: <4DB832B4.1060608@infradead.org>
Date: Wed, 27 Apr 2011 12:13:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: a b <mjnhbg1@gmail.com>
CC: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Some major problems of em28xx chip base TV devices in linux
References: <BANLkTim8fuuOC-56nPY=sJrCaY7kKOydYA@mail.gmail.com>
In-Reply-To: <BANLkTim8fuuOC-56nPY=sJrCaY7kKOydYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-04-2011 11:06, a b escreveu:
> Hello all
> 
>   Before anythings, i beg pardon of whom the matter of this e-mail is not related to; please excuse me.
> ------------------------------------------------------------------
>   Unfortunately i could not until now, use any DVB hardware on any version of linux; i tested many of them but none of them can be correctly used. :-(
>   I tired from testing and testing all things about combination of my linuxes and DVBs.
>   Please help me with all things that you know, and please do not tell the repeated things that i already tested, and please only think about the exact problem.

Please, don't mix Kernel driver issues with userspace ones. Different groups of
developers (and different mailing lists) are used for each userspace tool.
I won't comment about userspace DVB tools, as I don't maintain them.

>   i myself is familiar with unix and linux from about 19 years ago, and have done many low level programming on linux and unix in kernel and user spaces, till now. Thus please don't explain the inexact things and some non important things like options of /etc/syslog.conf or hardware testing of computer main memory!!
>   Please focuse your mind, only on the problems, thanks.

As you're a developer, the better way to improve is to make patches fixing the 
issues you noticed and submit them to the mailing lists. You're the only one
capable of reproducing your environment, in terms of channels, board configuration,
etc, as almost all work done here are made by volunteer people.

>   I tested this DVB-Stick with 2 linux versions, Debian and Ubuntu. Debian was lenny-i686 with kernel: 2.6.35.10 (that this kernel was compiled by myself from is complete source downloaded from www.kernel.org <http://www.kernel.org> with complete activation of all device drivers as kernel module) and Ubuntu was 10.10-amd64 (with 2 versions of kernel: 2.6.35.22 and 2.6.38.8, both of them was installed from the main ubuntu repository "archive.ubuntu.com <http://archive.ubuntu.com>" )
>   Both of linuxes were running on one computer, with a brief hardware of 2.8-GHz Intel Core2due E7400 CPU & 1 Giga-Ram & 2 Sata Hard disk & PK5PL Asus motherboard & Nvidia-G9500-GT graphic card.

If you think you have a driver issue, just use the latest development tree, available
at linuxtv.org. It contains the latest version of the drivers. the media-build.git is
the best way to get it. If you want to submit patches, you should get also the media-tree.git,
and generate patches against it.

>   i will explain my testings after this brief writing about my main (big) 7 problems:
>     1- The only software that could show me some of TV programs, was kaffeine, and no other softwares ( included mythtv & VLC & mplayer & w_scan & scan of dvb-utils ) could show any things.

Clearly, an userspace issue.

>     2- No any software could find any digital (DVB) channels during the scanning ( including even kaffeine).

Had you try w_scan and dvb-apps (from linuxtv.org)? What happens with dvb-apps with -v enabled?

>     3- Some of violations from standard encoding of DVB packets is done in my 25 digital channels, but experienced programmers of Win-Xp softwares find them and make some work around for them and thus we (linux programmers) must do the same things.

If the transmissions in your Country is violating the standard DVB, you'll need to fix the source
code of the applications. This may explain the problems you're having. No one else at the community 
can do anything to help you on it, because they don't have access to the same streamings as you have.

Mauro.
