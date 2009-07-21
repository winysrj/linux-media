Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47019 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZGUFAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 01:00:30 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KN400LHX8KTQZ@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jul 2009 14:00:29 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KN400A0T8KTQA@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jul 2009 14:00:29 +0900 (KST)
Date: Tue, 21 Jul 2009 14:00:29 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 4/4] radio-si470x: add i2c driver for si470x
In-reply-to: <208cbae30907190719v3fcffee0g1f15d05da5e182f2@mail.gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	tobias.lorenz@gmx.net, kyungmin.park@samsung.com
Message-id: <4A654B6D.1070805@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4A5C145D.30300@samsung.com>
 <208cbae30907190719v3fcffee0g1f15d05da5e182f2@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>

>> +
>> +int si470x_disconnect_check(struct si470x_device *radio)
>> +{
>> +       return 0;
>> +}
> 
> Looks like this function is empty and it's called few times. Is it
> good to make it inline?
> 

Yes, this function is empty. It looks fine to me too.
I will modify it, thanks.
