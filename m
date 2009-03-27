Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:34364 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZC0Jjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 05:39:35 -0400
Received: by bwz17 with SMTP id 17so907390bwz.37
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 02:39:31 -0700 (PDT)
Message-ID: <49CC9E53.9070805@gmail.com>
Date: Fri, 27 Mar 2009 11:37:23 +0200
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
References: <49C89F00.1020402@gmail.com>	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>	<49CBD53C.6060700@gmail.com> <20090326170910.6926d8de@pedra.chehab.org>
In-Reply-To: <20090326170910.6926d8de@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Hi Darius,
> 
> Please always base your patches against the last v4l-dvb tree or linux-next.
> This is specially important those days, where v4l core is suffering several
> changes.

Hi,

could you please advice which v4l-dvb Git repository I should pull from?
Because git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git does not have any new stuff now.
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git is marked as "unstable" for testing purposes.
What is better to base my patches on?

Darius.
