Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36640 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab0ARQUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 11:20:18 -0500
Received: by fxm25 with SMTP id 25so619162fxm.21
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 08:20:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6dcfbe31001180811h21a38381jec0ebb1a991f859d@mail.gmail.com>
References: <6dcfbe31001180811h21a38381jec0ebb1a991f859d@mail.gmail.com>
Date: Mon, 18 Jan 2010 11:20:16 -0500
Message-ID: <829197381001180820w72c5558clfff14e91525752a8@mail.gmail.com>
Subject: Re: [linux-dvb] Asking
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 18, 2010 at 11:11 AM, Ismo Kuhmonen <ismokuh@gmail.com> wrote:
> Hi
> Why my Pinnacle  DVB-T 73€ USB not working?

Are you running the current v4l-dvb tree?  Support for the 73e was
introduced into the v4l-dvb tree on September 2nd, so the changes
probably haven't gotten into whatever distribution you are using yet.

See http://linuxtv.org/repo for instructions on installing the latest
v4l-dvb code.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
