Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:52934 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZHEWtc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 18:49:32 -0400
Received: from [192.168.1.21] (151.59.219.5) by cp-out10.libero.it (8.5.107) (authenticated as efa@iol.it)
        id 4A7587E000520A69 for linux-media@vger.kernel.org; Thu, 6 Aug 2009 00:49:31 +0200
Message-ID: <4A7A0C7A.3010806@iol.it>
Date: Thu, 06 Aug 2009 00:49:30 +0200
From: Valerio Messina <efa@iol.it>
Reply-To: efa@iol.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
References: <4A6F8AA5.3040900@iol.it> <4A79320B.7090401@iol.it>	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>	 <4A79CEBD.1050909@iol.it>	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>	 <4A79E07F.1000301@iol.it>	 <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>	 <4A79E6B7.5090408@iol.it>	 <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>	 <4A79FC43.6000402@iol.it> <829197380908051451j6590db20l7268d34bd4b8342a@mail.gmail.com>
In-Reply-To: <829197380908051451j6590db20l7268d34bd4b8342a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller ha scritto:
> On Wed, Aug 5, 2009 at 5:40 PM, Valerio Messina<efa@iol.it> wrote:
>> 1 - On/off button on the IR as now, send a command to the desktop to start
>> the shutdown, reboot, suspend or hybernate window. To me should send
>> something to the active window only, like an ALT+F4 to close the windows
>> (for example Kaffeine).
> 
> This is typically controlled by your application or the desktop
> environment.  The on/off is mapped the same across all remote
> controls.

and seems mapped the same on all applications

> The map that I committed in does have all the keys mapped to input
> event codes.  You would need to reconfigure your input subsystem to
> point the event codes to some other function.

the channel up/down, EPG, Teletext and circled "i" on the remote does 
nothing.

Valerio
