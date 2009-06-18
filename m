Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:31667 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZFRNGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 09:06:50 -0400
Received: by yw-out-2324.google.com with SMTP id 5so567316ywb.1
        for <linux-media@vger.kernel.org>; Thu, 18 Jun 2009 06:06:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
References: <ccdf9f470906171618r26518ce7pa97d747e301009ca@mail.gmail.com>
	 <1a297b360906180132l49aa7be4j8a1e238aa9bac65@mail.gmail.com>
	 <1a297b360906180148lefc2d8fp972647ad0df64320@mail.gmail.com>
Date: Thu, 18 Jun 2009 08:06:52 -0500
Message-ID: <ccdf9f470906180606w1046ee88nda933b4e6638357a@mail.gmail.com>
Subject: Re: [Patch] New utility program atsc_epg added to dvb-apps utility
	suite.
From: Yufei Yuan <yfyuan@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I guess I violated at least coding style rule No.1, :) Will peruse
the coding style page tonight and redo the submission.

Regards,
Yufei

On Thu, Jun 18, 2009 at 3:48 AM, Manu Abraham<abraham.manu@gmail.com> wrote:
> On Thu, Jun 18, 2009 at 12:32 PM, Manu Abraham<abraham.manu@gmail.com> wrote:
>> 2009/6/18 Yufei Yuan <yfyuan@gmail.com>:
>>> Hi,
>>>
>>> I am not sure if this is the correct mailing list to send this patch.
>>> From the LinuxTV website, it seems that currently dvb-apps project has
>>> no owner.
>>>
>>> A new utility atsc_epg is added into the dvb-apps utility suite. It
>>> parses PSIP information carried in OTA ATSC channels, and constructs a
>>> basic EPG in a terminal window. Changes were also made to files to
>>> please GCC4.4.
>>>
>>> The patch is against latest revision 1278 from the dvb-apps repository.
>>
>>
>> Please do send the patch with tabs instead of spaces for indentation.
>
> Also:
>
> * please cleanup the white spaces in the patch, if any.
> * please use the unified format, diff -u option.
>
> Regards,
> Manu
>



-- 
好学近乎智，力行近乎仁，知耻近乎勇。
Eagerness in learning is close to intelligence.
Commitment in doing is close to nobleness.
Realization of shamefulness is close to courageousness.
