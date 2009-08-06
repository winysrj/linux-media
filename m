Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:56823 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZHFBnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 21:43:51 -0400
Received: by ywh13 with SMTP id 13so700900ywh.15
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 18:43:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7A0C7A.3010806@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A79CEBD.1050909@iol.it>
	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
	 <4A79E07F.1000301@iol.it>
	 <829197380908051251x6996414ek951d259373401dd7@mail.gmail.com>
	 <4A79E6B7.5090408@iol.it>
	 <829197380908051322r1382d97dtd5e7a78f99438cc9@mail.gmail.com>
	 <4A79FC43.6000402@iol.it>
	 <829197380908051451j6590db20l7268d34bd4b8342a@mail.gmail.com>
	 <4A7A0C7A.3010806@iol.it>
Date: Wed, 5 Aug 2009 21:43:51 -0400
Message-ID: <829197380908051843w20ee2953qa638e01cdf8729a3@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 6:49 PM, Valerio Messina<efa@iol.it> wrote:
>> The map that I committed in does have all the keys mapped to input
>> event codes.  You would need to reconfigure your input subsystem to
>> point the event codes to some other function.
>
> the channel up/down, EPG, Teletext and circled "i" on the remote does
> nothing.

They do "nothing", but that is the application's fault and not the
driver's.  When pressing the channel up key, the driver generates a
keyboard event called KEY_CHANNELUP, and the application has to have
that mapped to the correct shortcut.  Likewise, channel down, epg, and
the "i" generate KEY_CHANNELDOWN, KEY_EPG, and KEY_INFO.

Kaffeine 1.0pre1 appears to have some new infrastructure for assigning
events to shortcuts (see the menu item "Settings->Configure
Shortcuts"), however it doesn't appear to work correctly in all cases.
 Not that this is surprising for a prerelease.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
