Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48118 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab0BXP3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 10:29:09 -0500
Received: by bwz1 with SMTP id 1so1999930bwz.21
        for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 07:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8544B3.4060902@ip-minds.de>
References: <4B8544B3.4060902@ip-minds.de>
Date: Wed, 24 Feb 2010 10:29:07 -0500
Message-ID: <829197381002240729g7ae87931w6454accf075c6c59@mail.gmail.com>
Subject: Re: [linux-dvb] cx23885 / HVR 1200 - A/V Inputs?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 24, 2010 at 10:24 AM, Jean-Michel Bruenn
<jean.bruenn@ip-minds.de> wrote:
> Hello,
>
> i wanted to ask whether theres some progress or status on the cx23885
> driver. DVB-T is working fine,
> however - i'm currently interested into the A/V Inputs. Maybe there's some
> alpha/beta thing to test?
>
> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1200
>
> Talking about this card and would like to use the A/V Inputs.

Hi Jean,

No, there hasn't really been any progress in this area.  I've started
doing some work on the 23885 tree for the HVR-1800, all of which is
work applicable for the 1200/1250.  But frankly those cards are a
relatively low priority on my todo list and I'm only working on it in
the background.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
