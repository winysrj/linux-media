Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab2DTRKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 13:10:44 -0400
Message-ID: <4F919891.7030909@redhat.com>
Date: Fri, 20 Apr 2012 14:10:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com> <201204201601166255937@gmail.com>
In-Reply-To: <201204201601166255937@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-04-2012 05:01, nibble.max escreveu:
> 2012-04-20 15:56:27 nibble.max@gmail.com
> At first time, I check it exist so try to patch it.
> But with new m88ds3103 features to add and ts2022 tuner include, find it is hard to do simply patch.
> It is better to create a new driver for maintain.

The tuner should be split into a separate file. For the new ds3103 features, just add
some logic (or some config) parameter to tell that the device is DS3103 and use the
new features only in this case.

Regards,
Mauro

