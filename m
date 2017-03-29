Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35152 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdC2ElZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 00:41:25 -0400
Received: by mail-pg0-f65.google.com with SMTP id g2so1082647pge.2
        for <linux-media@vger.kernel.org>; Tue, 28 Mar 2017 21:41:24 -0700 (PDT)
Subject: Re: [PATCH] staging: media: atomisp: i2c: removed unnecessary white
 space before comma in memset()
To: Greg KH <greg@kroah.com>
References: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
 <1490678084-12740-1-git-send-email-vaibhavddit@gmail.com>
 <20170328052336.GA27784@kroah.com>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, linux-media@vger.kernel.org
From: vk <vaibhavddit@gmail.com>
Message-ID: <49c21c8d-7263-8b0a-e1d2-02734b4d1b6d@gmail.com>
Date: Wed, 29 Mar 2017 10:11:39 +0530
MIME-Version: 1.0
In-Reply-To: <20170328052336.GA27784@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Corrected all comments.


Thanks,

Vaibhav

On Tuesday 28 March 2017 10:53 AM, Greg KH wrote:
> On Tue, Mar 28, 2017 at 10:44:44AM +0530, vaibhavddit@gmail.com wrote:
>> gc2235.c
> Why is this file name here?
>
>>   Removed extra space before comma in memset() as a part of
>>   checkpatch.pl fix-up.
> Why the extra space at the beginning of the line?
>
>> Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
> This doesn't match your "From:" line above :(
>
> Please fix up.
>
> thanks,
>
> greg k-h
