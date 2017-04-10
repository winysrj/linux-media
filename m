Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:33062 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdDJRUr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 13:20:47 -0400
Received: by mail-qt0-f174.google.com with SMTP id m36so9343537qtb.0
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 10:20:46 -0700 (PDT)
Subject: Re: [PATCHv3 00/22] Ion clean up in preparation in moving out of
 staging
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1491245884-15852-1-git-send-email-labbott@redhat.com>
 <20170408103821.GA12084@kroah.com>
 <b1a52f74-a089-96c1-a6b9-5f4eb3d28f8b@redhat.com>
 <20170410162555.GA9534@kroah.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        devel@driverdev.osuosl.org, romlem@google.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Mark Brown <broonie@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <6d03f9e8-0e02-384f-69e3-66217ae95850@redhat.com>
Date: Mon, 10 Apr 2017 10:20:41 -0700
MIME-Version: 1.0
In-Reply-To: <20170410162555.GA9534@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2017 09:25 AM, Greg Kroah-Hartman wrote:
> On Mon, Apr 10, 2017 at 09:20:27AM -0700, Laura Abbott wrote:
>> On 04/08/2017 03:38 AM, Greg Kroah-Hartman wrote:
>>> On Mon, Apr 03, 2017 at 11:57:42AM -0700, Laura Abbott wrote:
>>>> Hi,
>>>>
>>>> This is v3 of the series to do some serious Ion cleanup in preparation for
>>>> moving out of staging. I didn't hear much on v2 so I'm going to assume
>>>> people are okay with the series as is. I know there were still some open
>>>> questions about moving away from /dev/ion but in the interest of small
>>>> steps I'd like to go ahead and merge this series assuming there are no more
>>>> major objections. More work can happen on top of this.
>>>
>>> I've applied patches 3-11 as those were independant of the CMA changes.
>>> I'd like to take the rest, including the CMA changes, but I need an ack
>>> from someone dealing with the -mm tree before I can do that.
>>>
>>> Or, if they just keep ignoring it, I guess I can take them :)
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Thanks. I'll send out some nag e-mails asking for Acks. If I don't get
>> any, I'll resend the rest of the series after the 4.12 merge window.
> 
> Why so long?  This series has been sent a bunch, if no one responds in a
> week, I'll be glad to take them all in my tree :)
> 
> thanks,
> 
> greg k-h
> 

Ideally I'd like some confirmation that at least someone other than
myself thinks it's a good idea but I know mm review bandwidth has
been a topic of discussion so maybe silence is the best I can get.
If you pick it up and nobody objects, I guess I won't object either :)

Thanks,
Laura
