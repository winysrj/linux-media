Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61555 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0CSRH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 13:07:27 -0400
Received: by bwz1 with SMTP id 1so224181bwz.21
        for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 10:07:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100319180129.6fb65141@hermes>
References: <20100319180129.6fb65141@hermes>
Date: Fri, 19 Mar 2010 13:07:23 -0400
Message-ID: <829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint to
	be detected
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Pankratz <kratz00@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 19, 2010 at 1:01 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
> Hi,
>
> this USB stick is a Pinnacle Pctv Hybrid Pro 320e device
> (ID eb1a:2881 eMPIA Technology, Inc.).
>
> Is there anything else you need to know?
<snip>

This was fixed some time ago.  Just install the current v4l-dvb code
(instructions can be found at http://linuxtv.org/repo)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
