Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64244 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0KOJQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 04:16:12 -0500
Received: by eye27 with SMTP id 27so2793592eye.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 01:16:11 -0800 (PST)
Date: Mon, 15 Nov 2010 10:15:44 +0100
From: Richard Zidlicky <rz@linux-m68k.org>
To: Massis Sirapian <msirapian@free.fr>
Cc: Stefan Ringel <stefan.ringel@arcor.de>, linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
Message-ID: <20101115091544.GA23490@linux-m68k.org>
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE03704.4070300@free.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Nov 14, 2010 at 08:22:44PM +0100, Massis Sirapian wrote:

> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the kernel  
> source directory, but nothing seems to fit my remote, which is a  
> DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.

FYI, this remote is identical to that shipped with (most?) Haupauge Ministicks
and the codes reportedly match the rc-dib0700-rc5.c keymap. However I have not figured
out how to make the userspace work with the new ir-code yet.

Richard
