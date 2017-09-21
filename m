Return-path: <linux-media-owner@vger.kernel.org>
Received: from us-smtp-delivery-107.mimecast.com ([216.205.24.107]:34612 "EHLO
        us-smtp-delivery-107.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751598AbdIUQUe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 12:20:34 -0400
Subject: Re: [PATCH v3 2/2] media: rc: Add driver for tango HW IR decoder
To: Sean Young <sean@mess.org>
CC: Mans Rullgard <mans@mansr.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
References: <0e433f1b-ec16-5fce-ab21-085f69e266ce@free.fr>
 <4fe2e398-ba7d-3670-f29b-fe3c5e079b39@free.fr>
 <20170921155712.bqxipuxdaf6feeg5@gofer.mess.org>
From: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Message-ID: <75a3ee58-f515-925f-0f13-ea96ddcbe4e2@sigmadesigns.com>
Date: Thu, 21 Sep 2017 18:20:28 +0200
MIME-Version: 1.0
In-Reply-To: <20170921155712.bqxipuxdaf6feeg5@gofer.mess.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/09/2017 17:57, Sean Young wrote:

> On Thu, Sep 21, 2017 at 04:49:53PM +0200, Marc Gonzalez wrote:
> 
>> The tango HW IR decoder supports NEC, RC-5, RC-6 protocols.
>>
>> Signed-off-by: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
> 
> Missing signed-off-by.

I am aware of that. Hopefully, at some point, Mans will add his.
I have no control over this, unless I rewrite the driver from
scratch.

> Your patch still gives numerous checkpatch warnings, please run it
> preferaby with --strict.

Some checkpatch warnings are silly, such as unconditionally mandating
4 lines for a Kconfig help message. Do you consider it mandatory to
address all warnings, whatever they are?

Regards.
