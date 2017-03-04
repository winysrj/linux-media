Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33943 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdCDN34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 08:29:56 -0500
Received: by mail-qk0-f174.google.com with SMTP id g129so32164330qkd.1
        for <linux-media@vger.kernel.org>; Sat, 04 Mar 2017 05:29:55 -0800 (PST)
Subject: Re: Kaffeine commit b510bff2 won't compile
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
 <20170227071122.3a319481@vento.lan>
 <a2c23f62-215a-9066-45bc-0b8eebacc84b@gmail.com>
 <20170301070024.3ca3150a@vento.lan>
Cc: linux-media@vger.kernel.org
From: bill murphy <gc2majortom@gmail.com>
Message-ID: <fdc10667-1ed9-7c84-bf7d-ec3a255c59b2@gmail.com>
Date: Sat, 4 Mar 2017 08:21:51 -0500
MIME-Version: 1.0
In-Reply-To: <20170301070024.3ca3150a@vento.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

yes I can appreciate that, but why not just make one file for each 
country that actually differs,

rather than make the rest of us suffer?

canada and the us are the same.

atsc/us-ATSC-center-frequencies-8VSB

So could add two files for mexico and korea.

atsc/mx-ATSC-center-frequencies-8VSB
atsc/kr-ATSC-center-frequencies-8VSB

can't be any worse that the hundreds of files being maintained for DVB-T 
in various countries.


On 03/01/2017 05:00 AM, Mauro Carvalho Chehab wrote:
> Hi Bill,
>
> Em Mon, 27 Feb 2017 23:46:09 -0500
> bill murphy <gc2majortom@gmail.com> escreveu:
>
>> Hi Mauro,
>>
>> Thanks for looking in to it. All is well now.
> Good! Thanks for testing.
>
>> On a sidenote, given 700 MHz is used for LTE, and not broadcasting
>>
>> anymore, would you folks consider removing ch 52 thru 69
>>
>> in the us-atsc-frequencies if I posted a simple patch to dtv-scan-tables?
> The problem is that, despite its name, this table is used on other
> Countries using atsc (like Mexico, Canada and South Korea):
>
> 	https://en.wikipedia.org/wiki/List_of_digital_television_deployments_by_country#/media/File:Digital_broadcast_standards.svg
>
> So, while the 700 MHz are still used on other ATSC Countries, we can't
> remove, as otherwise, it will not discover the channels at the upper
> frequency range there.
>
> Regards,
> Mauro
