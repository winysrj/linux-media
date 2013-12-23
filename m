Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:60618 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab3LWME0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 07:04:26 -0500
Message-ID: <52B826C8.2020103@imgtec.com>
Date: Mon, 23 Dec 2013 12:04:24 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/11] media: rc: img-ir: add Sharp decoder module
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com> <1386947579-26703-11-git-send-email-james.hogan@imgtec.com> <20131222120114.7aecbf9e@samsung.com>
In-Reply-To: <20131222120114.7aecbf9e@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/12/13 14:01, Mauro Carvalho Chehab wrote:
> Em Fri, 13 Dec 2013 15:12:58 +0000
> James Hogan <james.hogan@imgtec.com> escreveu:
> 
>> Add an img-ir module for decoding the Sharp infrared protocol.
> 
> Patches 5 and 7-11 look OK to me.

Thanks very much for reviewing.

> 
> While not required for patchset acceptance, it would be great if you could
> also add an IR raw decoder for this protocol, specially if you can also
> test it.

Yes, this had occurred to me too, but I haven't got around to it yet.
I've found several codes my universal remote control can use which
appear to be the sharp protocol so I am able to test it a bit, but don't
have any original sharp remotes to hand.

Cheers
James

