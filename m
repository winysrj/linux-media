Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39291 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbcBWQ2F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 11:28:05 -0500
Subject: Re: [PATCH] [media] tvp5150: remove signal generator as input from
 the DT binding
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1456243798-12453-1-git-send-email-javier@osg.samsung.com>
 <3469550.VVKtG3tqH6@avalon>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56CC8887.803@osg.samsung.com>
Date: Tue, 23 Feb 2016 13:27:51 -0300
MIME-Version: 1.0
In-Reply-To: <3469550.VVKtG3tqH6@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 02/23/2016 01:16 PM, Laurent Pinchart wrote:
> Hi Javier,
>
> On Tuesday 23 February 2016 13:09:58 Javier Martinez Canillas wrote:
>> The chip internal signal generator was modelled as an input connector
>> and represented as a media entity but isn't really a connector so the
>> driver was changed to use the V4L2_CID_TEST_PATTERN control instead.
>>
>> Remove the signal generator input from the list of connectors in the
>> tvp5150 DT binding document as well since isn't a connector anymore.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>> Hello,
>>
>> I think is OK to change this DT binding because is only in the media tree
>> for now and not in mainline yet and also is expected to change more since
>> there are still discussions about how input connectors will be supported
>> by the Media Controller framework in the media subsystem.
>
> I think that's fine, yes
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks.
  
> I haven't noticed the patch that introduced this early enough I'm afraid, and
> I think we still have issues with those bindings.
>

Yes, I posted those patches and got merged before we had the discussion about
input connectors over IRC so I didn't know what was the correct way to do it.

> The tvp5150 node should *not* contain connector subnodes, the connectors nodes
> should use the bindings defined in
> Documentation/devicetree/bindings/display/connector/ and be linked to the
> tvp5150 node using the OF graph bindings (ports and endpoints).
>

Agreed.

> Do you think you could fix that ?
>

Yes I will, I'm waiting for the input connectors discussions to settle so I
can post a final version of the DT bindings following what is agreed by all.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
