Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:36502 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754024AbdCTQ3z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 12:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170320080517.5b748830@xeon-e3>
References: <20170320093225.1180723-1-arnd@arndb.de> <20170320093225.1180723-3-arnd@arndb.de>
 <20170320080517.5b748830@xeon-e3>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 20 Mar 2017 17:29:54 +0100
Message-ID: <CAK8P3a0YvHwooiAg_6PQ4e879=rwM9wJzLFQLg_21JfK4jUGSA@mail.gmail.com>
Subject: Re: [PATCH 3/9] stating/atomisp: fix -Wold-style-definition warning
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 4:05 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Mon, 20 Mar 2017 10:32:19 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> -void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/)
>> +void ia_css_dequeue_param_buffers(/*unsigned int pipe_num*/ void)
>>  {
> Why keep the comment?

The comment matches one later in the file when this function gets called.

I thought about cleaning up both at the same time, but couldn't figure out
how the comment ended up in there or why it was left behind in the first
place, so I ended up leaving both for another patch on top. If you prefer,
I could resend the patch and do both at once.

        Arnd
