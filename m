Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36052 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933174AbdCLPpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 11:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20170312135423.GA911@kroah.com>
References: <20170310133504.GA18916@singhal-Inspiron-5558> <20170312135423.GA911@kroah.com>
From: SIMRAN SINGHAL <singhalsimran0@gmail.com>
Date: Sun, 12 Mar 2017 21:14:59 +0530
Message-ID: <CALrZqyOdKmSF10Ba60_00OzzRMnKAt7XwjksmuQfGEKvBY-avg@mail.gmail.com>
Subject: Re: [PATCH v1] staging: media: Remove unused function atomisp_set_stop_timeout()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 12, 2017 at 7:24 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 10, 2017 at 07:05:05PM +0530, simran singhal wrote:
>> The function atomisp_set_stop_timeout on being called, simply returns
>> back. The function hasn't been mentioned in the TODO and doesn't have
>> FIXME code around. Hence, atomisp_set_stop_timeout and its calls have been
>> removed.
>>
>> This was done using Coccinelle.
>>
>> @@
>> identifier f;
>> @@
>>
>> void f(...) {
>>
>> -return;
>>
>> }
>>
>> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
>> ---
>>  v1:
>>    -Change Subject to include name of function
>>    -change commit message to include the coccinelle script
>
> You should also cc: the developers doing all of the current work on this
> driver, Alan Cox, to get their comment if this really is something that
> can be removed or not.
>
> thanks,
>
Greg I have cc'd all the developers which script get_maintainer.pl showed:

$ git show HEAD | perl scripts/get_maintainer.pl --separator ,
--nokeywords --nogit --nogit-fallback --norolestats

Mauro Carvalho Chehab <mchehab@kernel.org>,Greg Kroah-Hartman
<gregkh@linuxfoundation.org>,
linux-media@vger.kernel.org,devel@driverdev.osuosl.org,linux-kernel@vger.kernel.org

> greg k-h
