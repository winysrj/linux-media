Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41937 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3JGRTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 13:19:14 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so2753335bkb.38
        for <linux-media@vger.kernel.org>; Mon, 07 Oct 2013 10:19:13 -0700 (PDT)
Message-ID: <5252ED11.9060702@googlemail.com>
Date: Mon, 07 Oct 2013 19:19:13 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: libtool warning in libdvbv5
References: <524EA330.8010700@xs4all.nl>
In-Reply-To: <524EA330.8010700@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 10/4/13 1:14 PM, Hans Verkuil wrote:
> When linking libdvbv5.la I get the following warning from libtool:
>
>    CCLD     libdvbv5.la
> libtool: link: warning: `-version-info/-version-number' is ignored for convenience libraries
>
> Other libs don't give that warning, but I don't see any obvious differences.
>
> Do you know what might cause this?

Yes. It is caused by the fact that libdvbv5 is built as static lib by 
default. And for static libs it does not make sense to specify version 
numbers like for dynamic libs. I'll fix the warning during the next days.

Thanks,
Gregor
