Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35715 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZFUVhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 17:37:07 -0400
Received: by gxk10 with SMTP id 10so4708830gxk.13
        for <linux-media@vger.kernel.org>; Sun, 21 Jun 2009 14:37:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
Date: Sun, 21 Jun 2009 17:29:27 -0400
Message-ID: <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
Subject: Re: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: George Adams <g_adams27@hotmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 21, 2009 at 3:51 PM, George Adams<g_adams27@hotmail.com> wrote:
>
> Thank you so much, everyone who has replied to my question!  It's nice to find a community of people willing to help.  Here is the dmesg output that appears when the Pinnacle device gets plugged in, along with a few "ls" commands:
<snip>

George,

It will definitely be interesting to see if the device works under
Windows.  It is very interesting that the tvp5150 driver isn't being
loaded at all, nor the xc3028 during analog initialization (and as a
result the DVB won't work because the analog initialization sets the
firmware to be used).

We've got the exact same USB device ids and last night I confirmed the
board is working fine here with the latest tree, suggesting no
regression in the driver code.

Did you happen to configure for only a subset of drivers to be
compiled?  Or did you just do a checkout and "cd v4l-dvb", "make",
"make install", reboot?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
