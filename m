Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f186.google.com ([209.85.210.186]:55022 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZFYNOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 09:14:44 -0400
Received: by yxe16 with SMTP id 16so507991yxe.33
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 06:14:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W1055421B0E48007A57D79988340@phx.gbl>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
	 <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
	 <COL103-W308B321250A646D788B25188390@phx.gbl>
	 <829197380906221453pa0738b4j6fb7c4b045f6aa1@mail.gmail.com>
	 <COL103-W1055421B0E48007A57D79988340@phx.gbl>
Date: Thu, 25 Jun 2009 09:14:42 -0400
Message-ID: <829197380906250614x30c118f1w1896811776ef998d@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: George Adams <g_adams27@hotmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2009 at 1:17 AM, George Adams<g_adams27@hotmail.com> wrote:
>
> Hello!  In a last ditch effort, I decided to try downloading a v4l driver snapshot from February back when I had my Pinnacle HD Pro Stick device working.  To my amazement, the old drivers worked!
>
> By process of elimination (trying newer and newer drivers until my Pinnacle device was once again not recognized), it appears that changeset 11331 (http://linuxtv.org/hg/v4l-dvb/rev/00525b115901), from Mar. 31 2009, is the first one that causes my device to not be recognized.  This is the changeset that updated the em28xx driver from 0.1.1 to 0.1.2.  Here, again, is the dmesg output from a newer driver that does NOT work (this one from a driver set one day later, on Apr. 1, 2009):

Interesting.  What distro and version of the kernel are you running?

Yesterday Michael Krufky pointed out to me that the v4l subdev
registration is broken for the au0828 driver when using the current
tip against Ubuntu Hardy (2.6.24), so it now seems likely that it's
the exact same issue.

Thanks for taking the time to narrow down the actual change that
caused the issue.

I guess somebody is going to have to build a box with Hardy and debug
this issue.  :-/

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
