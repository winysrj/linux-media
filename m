Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40324 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaI3PUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 11:20:21 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so3742383wib.10
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 08:20:20 -0700 (PDT)
Message-ID: <542ACA32.3050403@googlemail.com>
Date: Tue, 30 Sep 2014 17:20:18 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?QW5kcsOpIFJvdGg=?= <neolynx@gmail.com>
Subject: Re: Upcoming v4l-utils 1.6.0 release
References: <20140925213820.1bbf43c2@recife.lan>	<54269807.50109@googlemail.com> <20140927085455.5b0baf89@recife.lan>
In-Reply-To: <20140927085455.5b0baf89@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 27/09/14 13:54, Mauro Carvalho Chehab wrote:
> Em Sat, 27 Sep 2014 12:57:11 +0200
> Gregor Jasny <gjasny@googlemail.com> escreveu:
>> As far as I understand the service_location feature should work but is
>> an extension to the standard. Does it harm if we keep it until we have
>> something better in place to handle extensions?
>>
>> The service list descriptor feature is unimplemented (and thus broken).
>> Would it help if we return -1 from dvb_desc_service_list_init to reflect
>> that fact or does it break something else? But I'd keep the symbol in
>> the library to maintain ABI compatibility.

> I would actually prefer if we could get rid of those two broken
> descriptors on some release, and to re-add them only when they're
> actually working.

I have sent a patch series to remove the public headers of this two
descriptors and provide stubs to maintain SONAME compatibility.

Could you please ACK it?

Thanks,
Gregor
