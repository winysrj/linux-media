Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbcBIQuW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2016 11:50:22 -0500
Subject: Re: [PATCH tvtime 2/2] xvoutput: Add support for planar yuv formats
To: Devin Heitmueller <dheitmueller@kernellabs.com>
References: <1455015598-18805-1-git-send-email-hdegoede@redhat.com>
 <1455015598-18805-2-git-send-email-hdegoede@redhat.com>
 <CAGoCfiz+qpbyskJJzXgNkTEea5w_6Np1Q7_GgDY53ZMFu=YswQ@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <56BA18CA.8090803@redhat.com>
Date: Tue, 9 Feb 2016 17:50:18 +0100
MIME-Version: 1.0
In-Reply-To: <CAGoCfiz+qpbyskJJzXgNkTEea5w_6Np1Q7_GgDY53ZMFu=YswQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/09/2016 03:20 PM, Devin Heitmueller wrote:
> On Tue, Feb 9, 2016 at 5:59 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> When running on video cards which are using the modesetting driver +
>> glamor, or when running under XWayland + glamor, only planar yuv
>> formats are supported by the XVideo extension.
>>
>> This commits adds support for planar yuv formats to tvtime, making it
>> works on these kind of video-cards and XWayland.
>
> This is certainly a welcome change.  Does it work with the overlay
> though (i.e. hit tab to show the on-screen menu)?

Yes it does. Note I'm also working on some audio handling improvements,
so expect another tvtime patch-set from me soonish.

Regards,

Hans
