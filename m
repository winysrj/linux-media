Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:47209 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab3HETLi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 15:11:38 -0400
Received: by mail-we0-f182.google.com with SMTP id u55so2798169wes.41
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 12:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130801141518.258ff0a3@samsung.com>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost> <20130801141518.258ff0a3@samsung.com>
From: Luis Polasek <lpolasek@gmail.com>
Date: Mon, 5 Aug 2013 16:11:17 -0300
Message-ID: <CAER7dwfhXEzNY5Ue=Rxfe3kQiigp-uyz4g0TKyBXcKYpQaru6A@mail.gmail.com>
Subject: Re: dib8000 scanning not working on 3.10.3
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org,
	"jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, I have tested using dvb5-scan, and the results are the same
(no results, and no error logs) :(

 Do you have any clue why it is not working with this kernel version ?

Thanks and regards...

On Thu, Aug 1, 2013 at 2:15 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Thu, 1 Aug 2013 13:36:25 -0300
> Ezequiel Garcia <ezequiel.garcia@free-electrons.com> escreveu:
>
>> Hi Luis,
>>
>> (I'm Ccing Mauro, who mantains this driver and might know what's going on).
>>
>> On Wed, Jul 31, 2013 at 03:47:10PM -0300, Luis Polasek wrote:
>> > Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
>> > work anymore.
>> >
>> > I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
>> > Pixelview SBTVD (dib8000 module*).This tools worked very well on
>> > version 3.9.9 , but now it does not produces any result, and also
>> > there are no error messages in the logs (dmesg).
>> >
>>
>> Please run a git bisect and report your findings.
>>
>> Note that dibcom8000 shows just a handful of commit on 2013,
>> so you could start reverting those and see what happens.
>
> Perhaps it is a failure at the DVBv3 emulation.
>
> Did it also break using dvbv5-scan (part of v4l-utils)?
>
> Regards,
> Mauro
> --
>
> Cheers,
> Mauro
