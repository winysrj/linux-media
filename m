Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:37411 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755301AbeEHR1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 13:27:06 -0400
Received: by mail-pf0-f171.google.com with SMTP id e9so20287398pfi.4
        for <linux-media@vger.kernel.org>; Tue, 08 May 2018 10:27:06 -0700 (PDT)
Date: Tue, 8 May 2018 10:27:03 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: v4l2-ioctl: fix function types for
 IOCTL_INFO_STD
Message-ID: <20180508172703.GA5503@samitolvanen.mtv.corp.google.com>
References: <44310a2b-2797-223c-fab4-0214490e5201@xs4all.nl>
 <20180507205135.88398-1-samitolvanen@google.com>
 <a627c61e-f227-297c-087e-c2a701b46a64@xs4all.nl>
 <20180508171759.GA184279@samitolvanen.mtv.corp.google.com>
 <2a04c948-82ba-c69f-891e-303db85b66a4@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a04c948-82ba-c69f-891e-303db85b66a4@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 08, 2018 at 07:22:21PM +0200, Hans Verkuil wrote:
> This looks good, I would just rename DEFINE_IOCTL_FNC to DEFINE_V4L_STUB_FUNC.
> This makes it clear that it defines a v4l stub function.

Sure, sounds good. I'll send v3 shortly. Thanks for the reviews!

	Sami
