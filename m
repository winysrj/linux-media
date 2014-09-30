Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbaI3Q3g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 12:29:36 -0400
Message-ID: <542ADA66.3040905@redhat.com>
Date: Tue, 30 Sep 2014 18:29:26 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?QW5kcsOpIFJvdGg=?= <neolynx@gmail.com>
Subject: Re: Upcoming v4l-utils 1.6.0 release
References: <20140925213820.1bbf43c2@recife.lan>	<54269807.50109@googlemail.com> <20140927085455.5b0baf89@recife.lan> <542ACA32.3050403@googlemail.com>
In-Reply-To: <542ACA32.3050403@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/30/2014 05:20 PM, Gregor Jasny wrote:
> Hello,
>
> On 27/09/14 13:54, Mauro Carvalho Chehab wrote:
>> Em Sat, 27 Sep 2014 12:57:11 +0200
>> Gregor Jasny <gjasny@googlemail.com> escreveu:
>>> As far as I understand the service_location feature should work but is
>>> an extension to the standard. Does it harm if we keep it until we have
>>> something better in place to handle extensions?
>>>
>>> The service list descriptor feature is unimplemented (and thus broken).
>>> Would it help if we return -1 from dvb_desc_service_list_init to reflect
>>> that fact or does it break something else? But I'd keep the symbol in
>>> the library to maintain ABI compatibility.
>
>> I would actually prefer if we could get rid of those two broken
>> descriptors on some release, and to re-add them only when they're
>> actually working.
>
> I have sent a patch series to remove the public headers of this two
> descriptors and provide stubs to maintain SONAME compatibility.
>
> Could you please ACK it?

About the 1.6.0 release, please do not release it until the series
fixing the regression in 1.4.0 with gstreamer which I've posted
today. A review of that series would be appreciated. If you're ok
with the series feel free to push it to master.

Regards,

Hans
