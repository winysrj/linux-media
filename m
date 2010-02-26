Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34745 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966084Ab0BZUnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 15:43:32 -0500
Received: by bwz1 with SMTP id 1so431064bwz.21
        for <linux-media@vger.kernel.org>; Fri, 26 Feb 2010 12:43:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B882E3A.8050604@bluecherry.net>
References: <4B882E3A.8050604@bluecherry.net>
Date: Fri, 26 Feb 2010 15:43:30 -0500
Message-ID: <829197381002261243if253f07k81baae7c6a2cafe@mail.gmail.com>
Subject: Re: [bttv] Auto detection for Provideo PV- series capture cards
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Curtis Hall <curt@bluecherry.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 26, 2010 at 3:25 PM, Curtis Hall <curt@bluecherry.net> wrote:
> I'm writing concerning the Provideo PV-149, PV-155, PV-981-* and PV-183-*.
> These cards, for the most part, are drop in and 'just work' with the bttv
> driver.
>
> However the PV-149 / PV-981 / PV-155 is auto detected as the Provideo
> PV-150, which is not a valid Provideo part number.  The PV-183-* is detected
> as 'Unknown / Generic' and requires setting card=98,98,98,98,98,98,98,98.

Did you see the reply from Andy Walls over in video4linux?  He
provided a patch, and asked for a bunch of additional information he
needs in order to get the boards working properly.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
