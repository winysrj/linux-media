Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41616 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JHNv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 09:51:26 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2765774eek.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 06:51:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50727208.8020902@googlemail.com>
References: <1349635312-3045-1-git-send-email-raj.khem@gmail.com> <50727208.8020902@googlemail.com>
From: Khem Raj <raj.khem@gmail.com>
Date: Mon, 8 Oct 2012 06:50:53 -0700
Message-ID: <CAMKF1sqANY8=Yf5y8qL_pDm+ENDrmtWd68U_uvhc6RuZLJ7NnA@mail.gmail.com>
Subject: Re: [v4l-utils] Use RCC variable to call rcc compiler
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 7, 2012 at 11:26 PM, Gregor Jasny <gjasny@googlemail.com> wrote:
> Hello Khem,
>
> On 10/7/12 8:41 PM, Khem Raj wrote:
>> In cross compile environment rcc native version
>> may be staged in a different directory or even
>> called rcc4 or somesuch. Lets provide a facility
>> to specify it in environment
>
> I'll take care of this patch.
>
>> diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
>> index 02d0bcb..86d0285 100644
>> --- a/utils/qv4l2/Makefile.am
>> +++ b/utils/qv4l2/Makefile.am
>> @@ -29,7 +29,7 @@ moc_capture-win.cpp: $(srcdir)/capture-win.h
>>
>>  # Call the Qt resource compiler
>>  qrc_qv4l2.cpp: $(srcdir)/qv4l2.qrc
>> -     rcc -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
>> +     $(RCC) -name qv4l2 -o $@ $(srcdir)/qv4l2.qrc
>>
>>  install-data-local:
>>       $(INSTALL_DATA) -D -p "$(srcdir)/qv4l2.desktop"   "$(DESTDIR)$(datadir)/applications/qv4l2.desktop"
>>
>
> Where does RCC gets populated? The configure.ac parts seems to be missing.
>

hmm ok. I have been using it in environment. but I will do a v2 with
configure.in detecting it with pkgconfig

> Thanks,
> Gregor
