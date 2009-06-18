Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:38897 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZFRIsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 04:48:01 -0400
Received: by fxm8 with SMTP id 8so871838fxm.37
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 01:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
References: <ccdf9f470906171618r26518ce7pa97d747e301009ca@mail.gmail.com>
	 <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
Date: Thu, 18 Jun 2009 12:48:03 +0400
Message-ID: <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
Subject: Re: [Patch] New utility program atsc_epg added to dvb-apps utility
	suite.
From: Manu Abraham <abraham.manu@gmail.com>
To: Yufei Yuan <yfyuan@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 18, 2009 at 12:32 PM, Manu Abraham<abraham.manu@gmail.com> wrote:
> 2009/6/18 Yufei Yuan <yfyuan@gmail.com>:
>> Hi,
>>
>> I am not sure if this is the correct mailing list to send this patch.
>> From the LinuxTV website, it seems that currently dvb-apps project has
>> no owner.
>>
>> A new utility atsc_epg is added into the dvb-apps utility suite. It
>> parses PSIP information carried in OTA ATSC channels, and constructs a
>> basic EPG in a terminal window. Changes were also made to files to
>> please GCC4.4.
>>
>> The patch is against latest revision 1278 from the dvb-apps repository.
>
>
> Please do send the patch with tabs instead of spaces for indentation.

Also:

* please cleanup the white spaces in the patch, if any.
* please use the unified format, diff -u option.

Regards,
Manu
