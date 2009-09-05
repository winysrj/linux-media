Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64656 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZIERy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 13:54:28 -0400
Received: by fxm17 with SMTP id 17so1269811fxm.37
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 10:54:29 -0700 (PDT)
Message-ID: <4AA2A5D3.2060508@googlemail.com>
Date: Sat, 05 Sep 2009 18:54:27 +0100
From: Peter Brouwer <pb.maillists@googlemail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"William M. Brack" <wbrack@mmm.com.hk>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: problem building v4l2-spec from docbook source
References: <4A9A3650.3000106@freemail.hu>	<d88b96090d4bf9d9d152db5645149594.squirrel@delightful.com.hk>	<4A9F52E1.7030004@freemail.hu>	<20090903085455.176f4df3@pedra.chehab.org> <20090903090847.4aeef6cc@pedra.chehab.org> <4AA12791.7070103@freemail.hu>
In-Reply-To: <4AA12791.7070103@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is it possible to create a link on the linuxtv.org website to the latest dvb and 
v4l spec in pdf?
For dvb the v3 is still on the documentation page.

Peter
Németh Márton wrote:
> Mauro Carvalho Chehab wrote:
>> Em Thu, 3 Sep 2009 08:54:55 -0300
>> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
>>
>>> Em Thu, 03 Sep 2009 07:23:45 +0200
>>> Németh Márton <nm127@freemail.hu> escreveu:
>>>
>>>
>>> Try to replace "Role" to "role". Maybe it is just another case where you need to use lowercase with some xml engines.
>> Ok, I just added a patch that does this to remote_controllers.sgml:
>>
>> -<row><entry><emphasis Role="bold">Miscelaneous keys</emphasis></entry></row>
>> +<row><entry><emphasis role="bold">Miscelaneous keys</emphasis></entry></row>
>>
>> changeset:   12615:2b49813f8482
>> tag:         tip
>> user:        Mauro Carvalho Chehab <mchehab@redhat.com>
>> date:        Thu Sep 03 09:06:34 2009 -0300
>> summary:     v4l2-spec: Fix xmlto compilation with some versions of the tool
>>
>> Please see if this fixes the issue.
> 
> Thanks, now the "make v4l2-spec" successfully build the html documentation
> on my computer.
> 
> Regards,
> 
> 	Márton Németh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

