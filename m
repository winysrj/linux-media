Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33563 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1CGOrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 09:47:47 -0500
Received: by vxi39 with SMTP id 39so3727841vxi.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 06:47:46 -0800 (PST)
References: <20110306115333.52f8825f@grobi>
In-Reply-To: <20110306115333.52f8825f@grobi>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <2A428DFF-0F94-4370-8078-A00FAB96378C@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: NCT 677x lirc driver for Asrock 330HT and others
Date: Mon, 7 Mar 2011 09:48:00 -0500
To: Steffen Barszus <steffenbpunkt@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 6, 2011, at 5:53 AM, Steffen Barszus wrote:

> Hi !
> 
> Note sure where exactly to put it. Here is an lirc driver provided by
> Nuovoton as it seems, which can be downloaded from the vendors site:
> 
> http://www.asrock.com/Nettop/download.asp?Model=ION%20330HT&o=Linux
> 
> It adds an lirc driver for the receiver as used in the Asrock 330HT and
> newer models from Asrock. 
> 
> Can this go into lirc, or better, can something be done to integrate it
> "somehow" ?

We've had a nuvoton-cir rc-core driver, based loosely on that driver,
in the kernel tree for a few months now. It was written using an Asrock
ION 330HT provided to me by Nuvoton, and it works fantastically well.

-- 
Jarod Wilson
jarod@wilsonet.com



