Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:35732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbZFQSLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 14:11:43 -0400
Received: by fg-out-1718.google.com with SMTP id d23so940869fga.17
        for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 11:11:45 -0700 (PDT)
Message-ID: <4A3931DC.1060003@gmail.com>
Date: Wed, 17 Jun 2009 14:11:40 -0400
From: Brian Johnson <brijohn@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>	<20090617065621.23515ab7@pedra.chehab.org>	<4A38CCAF.5060202@redhat.com> <20090617112802.152a6d64@pedra.chehab.org> <4A390093.5090003@redhat.com>
In-Reply-To: <4A390093.5090003@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
>>> sn9c102
>>> Supports a large number of cams also supported by gspca's sonixb / sonixj driver, we're using
>>> #ifdef .... macros to detect if both are being build at the same time to include usb-id's only
>>> in one of the 2.
>> Btw, it would be interesting to work with the out-of-tree microdia driver,
>> since there are some models that are supported only by the alternative driver.
> 
> Ack, only one small problem, which is another reason why Luca's drivers should slowly be phased
> out, Luca has gone closed source with his sn9cxxx driver.
> 
> There is an out of tree driver for the new sn9c2xx models you talk about though, with active
> developers, I've pushing them to get it into the mainline, I'll give it another try soonish.
> 

Hello I'm one of the developers for the current out of tree sn9c20x driver.  What needs to be done in order
to get the sn9c20x code into the mainline? Am i right in assuming it would be preferred to move the code into 
a sn9c20x gspca subdriver rather then include the complete out of tree driver? If this is the case I can work
on a set of patches to implement our code as a gspca subdriver.

Also i have a few questions regarding submitting the patches.

1) In addition to sending them to linux-media should I CC them to anyone in particular?
2) The entire patch would likely be about 70k. Should I just send one patch or split the
thing up into several?

Thanks,
Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

