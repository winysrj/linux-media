Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241Ab2GEPxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 11:53:46 -0400
Message-ID: <4FF5B87E.4010702@redhat.com>
Date: Thu, 05 Jul 2012 12:53:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org, pomidorabelisima@gmail.com
Subject: Re: [PATCH v5 1/5] rtl2832 ver. 0.5: support for RTL2832 demod
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <1337366864-1256-2-git-send-email-thomas.mair86@googlemail.com> <4FF5A582.7070908@redhat.com> <4FF5A786.7020706@iki.fi>
In-Reply-To: <4FF5A786.7020706@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 11:41, Antti Palosaari escreveu:
> On 07/05/2012 05:32 PM, Mauro Carvalho Chehab wrote:
>> Em 18-05-2012 15:47, Thomas Mair escreveu:
> 
>>> +static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>>> +{
>>> +    *strength = 0;
>>> +    return 0;
>>> +}
>>
>> Why to implement the above, if they're doing nothing?
> 
> Other your findings were correct but for that I would like to comment.
> 
> Have you ever tested what happens you lest those without stub implementation?
> IIRC ugly errors are seen for example zap and femon outputs. Some kind of DVB-core
> changes are needed. And IIRC there was some error code defined too for API - but such 
> code does not exists.

So, let's fix the dvb_core, and not fill drivers with stubs. With regards to userspace
tools, they should be patched to accept the error code that signalizes that an ioctl
was not implemented, and not try to fix an userpace issue in Kernel.

Regards,
Mauro
