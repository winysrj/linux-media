Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64122 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbZLRVwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 16:52:16 -0500
Received: by ewy19 with SMTP id 19so1965938ewy.21
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2009 13:52:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091218201349.69ca27a5@tele>
References: <20091218184604.GA24444@pathfinder.pcs.usp.br>
	 <20091218201349.69ca27a5@tele>
Date: Fri, 18 Dec 2009 22:52:12 +0100
Message-ID: <c2fe070d0912181352j7c8a8085sf14d8ea68fe63ddb@mail.gmail.com>
Subject: Re: patch to support for 0x0802 sensor in t613.c
From: leandro Costantino <lcostantino@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Nicolau Werneck <nwerneck@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nicolau, if you need help, let me know.
I also, sent you some mails asking for the patch for review some weeks
ago, i thougth you were missing :)
good woork
best regards

On Fri, Dec 18, 2009 at 8:13 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Fri, 18 Dec 2009 16:46:04 -0200
> Nicolau Werneck <nwerneck@gmail.com> wrote:
>
>> Hello. I am a clueless n00b, and I can't make patches or use any
>> proper development tools. But I made this modification to t613.c to
>> support this new sensor. It is working fine with me. I just cleaned
>> the code up a bit and compiled and tested with the 2.6.32 kernel, and
>> it seems to be working fine.
>>
>> If somebody could help me creating a proper patch to submit to the
>> source tree, I would be most grateful. The code is attached.
>
> Hello Nicolau,
>
> Your code seems fine. To create a patch, just go to the linux tree
> root, make a 'diff -u' from the original file to your new t613.c, edit
> it, at the head, add a comment and a 'Signed-off-by: <your email>', and
> submit to the mailing-list with subject '[PATCH] gspca - t613: Add new
> sensor lt168g'.
>
> BTW, as you know the name of your sensor, do you know the real name of
> the sensor '0x803' ('other')? (it should be in some xxx.ini file in a
> ms-win driver, but I could not find it - the table n4_other of t613.c
> should be a table 'Regxxx' in the xx.ini)
>
> Best regards.
>
> --
> Ken ar c'hentań |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
