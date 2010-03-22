Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40278 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0CVRyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 13:54:18 -0400
Received: by bwz1 with SMTP id 1so2167757bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Mar 2010 10:54:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100322184553.0433ae24@hermes>
References: <20100319180129.6fb65141@hermes>
	 <829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
	 <20100319181333.3352a029@hermes>
	 <829197381003191017k5adab45ejee5179bc66880cac@mail.gmail.com>
	 <20100322184553.0433ae24@hermes>
Date: Mon, 22 Mar 2010 13:54:16 -0400
Message-ID: <829197381003221054h6624f4d6x648f844c54e51b37@mail.gmail.com>
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint to
	be detected
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steffen Pankratz <kratz00@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 22, 2010 at 1:45 PM, Steffen Pankratz <kratz00@gmx.de> wrote:
> Hi Devin,
>
> I don't want to push you but are there any news?

I've been too buried in other projects to work on it.  In the
meantime, you can add "card=53" as a modprobe option to em28xx, and it
should start working for you.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
