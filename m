Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:39743 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3ECLVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 07:21:12 -0400
Date: Fri, 3 May 2013 08:20:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
Message-ID: <20130503112052.GB2291@localhost>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
 <1367268069-11429-2-git-send-email-jonarne@jonarne.no>
 <20130503020913.GB5722@localhost>
 <20130503065846.GD1232@dell.arpanet.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130503065846.GD1232@dell.arpanet.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On Fri, May 03, 2013 at 08:58:46AM +0200, Jon Arne Jørgensen wrote:
[...]
> > You can read more about this in Documentation/SubmittingPatches.
> 
> I just re-read SubmittingPatches.
> I couldn't see that there is anything wrong with multiple sign-off's.
> 

Indeed there isn't anything wrong with multiple SOBs tags, but they're
used a bit differently than this.

> Quote:
>   The Signed-off-by: tag indicates that the signer was involved in the
>   development of the patch, or that he/she was in the patch's delivery
>   path.
> 
>

Ah, I see your point.

@Mauro, perhaps you can explain this better then me?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
