Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F4DC04EB8
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 13:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBB412082D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 13:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mglgUKr7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBB412082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbeLHNBf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 08:01:35 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38059 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeLHNBf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 08:01:35 -0500
Received: by mail-io1-f67.google.com with SMTP id l14so5436884ioj.5
        for <linux-media@vger.kernel.org>; Sat, 08 Dec 2018 05:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XrO7kRT1LlBtYHtI9I+rovLvojpAbc5EDLVDYnFkfhQ=;
        b=mglgUKr7j40IUzf3F+VoL+vDGxXeA0TEU59EIn8IX/xN+5l8Y3Ot1p9NJ3OAxTZuP/
         YTa6ufEgyEKQ+Ugokf3x/Vssl2fCJAX2TAE+LZnk3g7qWDkmqcigo4yrFO7XgUrId1et
         znRVrhLUgTJrwYTR6oeJc/sdzIvxELoiGXWWC5W0SfqF0P4IQ2XIKGSyT7HAV4mslhbb
         R2TF+DymidWhuhnWru/pW+HKTv2o+FdkiZQ5vQY17gEBUoTwEgK1toBzS256b8g67yWh
         D5ZGvlpzX3w5lMIPI5hVRiRtIxOD2JPs8S64ZxibYIvpMeBT6U9h0qxlLzSI06FpYAL3
         lzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XrO7kRT1LlBtYHtI9I+rovLvojpAbc5EDLVDYnFkfhQ=;
        b=XjvIbJQtMQhyZdU5gtSjzy/aEhSkHp6JdGg52A490b3JEF0KdoXkeekhmzw3eCxv5H
         1YnUFA/d8vWqltSEu6BoOvs0tFr/zE0cnKcoFdBOxxPPz918XPy2Cg5+F6uUfS257GfW
         MPJ/rTH/IIz2ybC0YF5HwTuqi8FeBfblsG4dy3O3G/JoYRROMYiyY6Ruyhm2zi2TO2Kx
         OFJE9o+ZPfpB55YiMH2KhqH2ENHpQ6dhALbcil5C0JybPLne9NpFSXai+6el/FhrgqKX
         qev5iGl70jrgRPyhP+gNY8d55T0ZtooUN3Yc26y/tYjnMjKZt7ZtLxr7elp9cwywusht
         iJ0w==
X-Gm-Message-State: AA+aEWYmzx1m0KEPpLyXDyZRAWDnO2UBJLI5ahCotjiWmfqUYtt0Al8Z
        36BjXxJynh5XT51sR71Fe3sSYG4q2px7VD2NCEOkFQ==
X-Google-Smtp-Source: AFSGD/VuI6C7EHz1YQSf4x1rdSEXaffRrTvavxHTq86vPPimTcJGpcHjnTohRv47HsFC+xEKKSuk57loX0+xko1xlag=
X-Received: by 2002:a5d:8491:: with SMTP id t17mr4613739iom.11.1544274093622;
 Sat, 08 Dec 2018 05:01:33 -0800 (PST)
MIME-Version: 1.0
References: <CACT4Y+YHx3RUMGLv5T=-FJDZKEavK+sWBbAbenfm8mTQry8F+w@mail.gmail.com>
 <ea1f7e70-6e8c-76a2-291d-228f99ca0cd4@xs4all.nl> <f5c8b506-325c-0164-c258-5c103592598d@collabora.com>
 <02f4c514-e899-513a-7e2c-3a005bbf7f2c@collabora.com>
In-Reply-To: <02f4c514-e899-513a-7e2c-3a005bbf7f2c@collabora.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 8 Dec 2018 14:01:21 +0100
Message-ID: <CACT4Y+aCFZcpAkDbcE2ptZ64jJeh-eH-6MZZM-uK5XFKG5CQTw@mail.gmail.com>
Subject: Re: VIVID/VIMC and media fuzzing
To:     helen.koike@collabora.com
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        syzkaller <syzkaller@googlegroups.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 7, 2018 at 8:22 PM Helen Koike <helen.koike@collabora.com> wrote:
> >>> You also mentioned that one of the devices requires some complex setup
> >>> via configfs. Is this interface described somewhere? Do you think it's
> >>> more profitable to pre-setup some fixed configuration for each test
> >>> process? Or just give the setup interface to fuzzer and let it do
> >>> random setup? Or both?
> >>
> >> That's the vimc driver, but the configfs code isn't in yet.
> >
> > I'll try to submit it later this week (with documentation) :)
>
> I submitted the first version at:
> https://www.spinics.net/lists/linux-media/msg144244.html
> As soon as it is updated we can add it to fuzzer. I believe some
> pre-setup/fixed configuration would work.
>
> I don't know much about fuzzer's code, if you could give me some
> pointers I can help with that.

Hi Helen,

Great!

It may be easier to think about this on 2 levels:
The first is _what_ we want to do. For this, imagine you are writing a
stress test for the subsystem as a C program that does some fixed
setup and then executes random syscalls related to the subsystem and
acting on the devices using rand() to select syscalls and arguments.
What setup would you do for this? What syscalls would you issue?

The second is then how to fit this into syzkaller.
The setup part in syzkaller is also just custom C code. E.g. this
setups network devices for test process:
https://github.com/google/syzkaller/blob/master/executor/common_linux.h#L154-L301
There is a little bit of trickery because this code is also used to
generate C reproducers for crashes, and it also needs to preferably
support multiple independent test processes (namely this code has
procid=0..N variable and needs to setup e.g. /dev/loopN device
corresponding to current procid). E.g. for vivid we use
"vivid.n_devs=16 vivid.multiplanar=1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2".
But overall it's just C code.

For the main stress/fuzzing we have these declarative descriptions,
which are hopefully mostly self-explanatory:
https://github.com/google/syzkaller/blob/master/sys/linux/video4linux.txt
If there is something missing, we need to add missing parts. And maybe
even give fuzzer the configfs interface too to mess with (it can open
specified files and do, say, writes with complex inputs, both binary
and text based).

Also, will we gain something by enabling the following ones inside of a VM:
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
? Or, it's just physical hardware drivers?
FTR, here are configs that syzbot uses:
https://github.com/google/syzkaller/blob/master/dashboard/config/upstream-kasan.config
https://github.com/google/syzkaller/blob/master/dashboard/config/upstream-selinux.cmdline
https://github.com/google/syzkaller/blob/master/dashboard/config/upstream.sysctl

Thanks
