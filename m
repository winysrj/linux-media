Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50723 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbZJaXCM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:02:12 -0400
Received: by ewy28 with SMTP id 28so3917982ewy.18
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 16:02:15 -0700 (PDT)
Message-ID: <4AECC1EE.8000603@gmail.com>
Date: Sun, 01 Nov 2009 00:02:06 +0100
From: Albert Comerma <albert.comerma@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] somebody messed something on xc2028 code?
References: <4AEC2F03.6050205@gmail.com> <829197380910310923nf45eba5o29083127328c5d47@mail.gmail.com>
In-Reply-To: <829197380910310923nf45eba5o29083127328c5d47@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, it worked! the current tree works well. Thanks.

Albert

En/na Devin Heitmueller ha escrit:
> On Sat, Oct 31, 2009 at 8:35 AM, Albert Comerma
> <albert.comerma@gmail.com> wrote:
>   
>> Hi all, I just updated my ubuntu to karmic and found with surprise that with
>> 2.6.31 kernel my device does not work... It seems to be related to the
>> xc2028 code part since the kernel explosion happens when you try to tune the
>> device, here it's my dmesg, any idea?
>>
>> Albert
>>     
>
> Oh, you're using the stock 2.6.31 which didn't get my fix yet.  Please
> try the latest v4l-dvb tree and see if it still happens.
>
> Devin
>
>   

