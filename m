Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41596 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752669AbdFWI1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 04:27:06 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-media <linux-media@vger.kernel.org>,
        zhaoxuegang <zhaoxuegang@suntec.net>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
        <m3d1bhhwf3.fsf_-_@t19.piap.pl>
        <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
        <m38tm3j0wr.fsf@t19.piap.pl>
        <CAAEAJfAo8-efB-ZopydXFdRZDKsTKcSzx1vkaJwcpDQQ1Eiivw@mail.gmail.com>
        <m3zieiheng.fsf@t19.piap.pl>
        <b088a7cd-7585-5235-224d-a90ea9042c24@xs4all.nl>
Date: Fri, 23 Jun 2017 10:18:49 +0200
In-Reply-To: <b088a7cd-7585-5235-224d-a90ea9042c24@xs4all.nl> (Hans Verkuil's
        message of "Fri, 16 Jun 2017 13:35:48 +0200")
Message-ID: <m34lv715hy.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Any progress on this? I gather I can expect a new patch from someone?

Well, the issue is trivial and very easy to test, though not present
on common x86 hw. That patch I've sent fixes it, but I'm not the one who
decides.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
