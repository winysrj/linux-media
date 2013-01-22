Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55709 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3AVNjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 08:39:14 -0500
Received: by mail-ee0-f49.google.com with SMTP id d4so3378149eek.22
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 05:39:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130121180932.6f6ca48b@redhat.com>
References: <CAOwYNKaFPLbkJn5J5XL05+g73D1k333+JjLc1rcchFk9B599Aw@mail.gmail.com>
	<20130121180932.6f6ca48b@redhat.com>
Date: Tue, 22 Jan 2013 13:39:11 +0000
Message-ID: <CAOwYNKb4d=Ci_F6QmBnJA=6P9bHtk1+ef1s85epoDDhNzap9CQ@mail.gmail.com>
Subject: Re: dvb-usb-it913x dissapeared kernel 3.7.2
From: Mike Martin <mike@redtux.org.uk>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/2013, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em Mon, 21 Jan 2013 15:47:49 +0000
> Mike Martin <mike@redtux.org.uk> escreveu:
>
>> After updating the kernel on Fedora 18 module dvb-usb-it913x seems to
>> have dissapeared.
>>
>> This has meant my dvb stick ( ID 1b80:e409 Afatech IT9137FN Dual DVB-T
>> [KWorld UB499-2T]) no longer works
>>
>> Is this a Redhat only thing or is it upstream
>
> See this bugzilla:
> 	https://bugzilla.redhat.com/show_bug.cgi?id=895460
>
> Basically, DVB_USB_V2 wasn't selected. The kernel-3.7.2-204.fc18 should
> fix this issue.
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
>
> Cheers,
> Mauro
>
Seems to be fixed now
