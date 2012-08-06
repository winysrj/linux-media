Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:57766 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2HFEck (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 00:32:40 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-226.nexicom.net [216.168.121.226])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q764Wcd9022202
	for <linux-media@vger.kernel.org>; Mon, 6 Aug 2012 00:32:39 -0400
Message-ID: <501F48E8.1010109@lockie.ca>
Date: Mon, 06 Aug 2012 00:32:40 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: Oliver Schinagl <oliverlist@schinagl.nl>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: firmware directory
References: <501E90C8.1000906@lockie.ca> <501EB212.7070004@schinagl.nl>
In-Reply-To: <501EB212.7070004@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/12 13:49, Oliver Schinagl wrote:
> On 05-08-12 17:27, James wrote:
>> [   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw
>>
>> Did the firmware directory change recently?
>>
>> # ls -l /lib/firmware/v4l-cx23885-avcore-01.fw
>> -rw-r--r-- 1 root root 16382 Oct 15  2011 /lib/firmware/v4l-cx23885-avcore-01.fw

> I had the exact same error, but was my own fault, I compiled drxd instead of drxk. Firmware on 3.5.0 works as expected.

I don't think I compile any firmware, what is the kernel option I should look for?
