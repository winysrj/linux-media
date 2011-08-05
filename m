Return-path: <linux-media-owner@vger.kernel.org>
Received: from bonnie-vm4.ifh.de ([141.34.50.21]:37000 "EHLO smtp.ifh.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094Ab1HEIqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2011 04:46:44 -0400
Date: Fri, 5 Aug 2011 10:46:40 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DiBxxxx: fixes for 3.1/3.0
In-Reply-To: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
Message-ID: <alpine.LRH.2.00.1108051043480.19389@pub5.ifh.de>
References: <alpine.LRH.2.00.1108031728090.30199@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, 3 Aug 2011, Patrick Boettcher wrote:
> Would you please pull from
>
> git://linuxtv.org/pb/media_tree.git for_v3.0
>
> for the following to changesets:
>
> [media] dib0700: protect the dib0700 buffer access
> [media] DiBcom: protect the I2C bufer access

I added a patch from Olivier which fixes wrongly used dprintks and 
replaces them by err()-calls.

[media] dib0700: correct error message

I herewith renew my PULL-request. The request now contains 3 changesets.

best regards,
--
Patrick
