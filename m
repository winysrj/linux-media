Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:59422 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0CGMIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 07:08:01 -0500
Message-ID: <4B93971A.8040207@freemail.hu>
Date: Sun, 07 Mar 2010 13:07:54 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
CC: linux-media@vger.kernel.org
Subject: Re: problem compiling modoule mt9t031 in current v4l-dvb-hg
References: <20100307113227.GA8089@gentoo.local>
In-Reply-To: <20100307113227.GA8089@gentoo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Halim Sahin wrote:
> Hi Folks,
> I was not able to build v4l-dvb from hg (checked out today).
> 
> 
> /root/work/v4l-dvb/v4l/mt9t031.c:729: error: unknown field 'runtime_suspend' specified in initializer
> /root/work/v4l-dvb/v4l/mt9t031.c:730: error: unknown field 'runtime_resume' specified in initializer
> /root/work/v4l-dvb/v4l/mt9t031.c:730: warning: initialization from incompatible pointer type
> make[3]: *** [/root/work/v4l-dvb/v4l/mt9t031.o] Error 1
> make[2]: *** [_module_/root/work/v4l-dvb/v4l] Error 2
> make[1]: *** [default] Fehler 2
> make: *** [all] Fehler 2
> Kernel 2.6.31 (x86_64)

What is the CONFIG_PM setting in your environment?

Regards,

	Márton Németh
