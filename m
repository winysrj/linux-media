Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56413 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0CKOQ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 09:16:56 -0500
Received: by gwb15 with SMTP id 15so37351gwb.19
        for <linux-media@vger.kernel.org>; Thu, 11 Mar 2010 06:16:55 -0800 (PST)
Message-ID: <4B98FB51.8030209@gmail.com>
Date: Thu, 11 Mar 2010 11:16:49 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Halim Sahin <halim.sahin@t-online.de>
CC: linux-media@vger.kernel.org
Subject: Re: problem compiling modoule mt9t031 in current v4l-dvb-hg
References: <20100307113227.GA8089@gentoo.local>
In-Reply-To: <20100307113227.GA8089@gentoo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/07/2010 08:32 AM, Halim Sahin wrote:
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
> regards
> Halim
> 

Thanks for your report. 
This issue was resolved, refresh your branch.

Cheers
Douglas
