Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4684 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1BYMrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 07:47:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: Hauppauge Colossus Support
Date: Fri, 25 Feb 2011 13:47:28 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTi=kQn3oP3OwwcBPPuTbYWPZeVsgZf_fXajdJ8ZM@mail.gmail.com>
In-Reply-To: <AANLkTi=kQn3oP3OwwcBPPuTbYWPZeVsgZf_fXajdJ8ZM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251347.28409.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, February 25, 2011 12:53:20 Brandon Jenkins wrote:
> Greetings all,
> 
> My search of the list turned up nothing on planned support for the
> Colossus in Linux. Hauppauge has begun shipping the card, and I have
> one being shipped today which I am willing to loan to a developer if
> it would help.
> 
> Here's a few links on the components:
> http://www.vixs.com/briefs/XCode_3111_v2.pdf
> http://www.analog.com/en/analog-to-digital-converters/video-decoders/adv7441a/products/product.html

An initial driver for the ADV7604 was posted recently. Cisco is working on this.
The ADV7441 is quite similar in many respects to the ADV7604, so that should help.
In fact, it might well be that the same driver can support both models, but without
a careful comparison of the datasheets I cannot be certain.

Regards,

	Hans

> http://www.missingremote.com/sites/default/files/imagepicker/629/DSCN2261.jpg
> http://hauppauge.com/site/products/data_colossus.html
> 
> Thanks in advance!
> 
> Brandon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
