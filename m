Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3HTNjH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 09:39:07 -0400
Message-ID: <52137171.3000600@redhat.com>
Date: Tue, 20 Aug 2013 15:38:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org, Yaroslav Zakharuk <slavikz@gmail.com>,
	1173723@bugs.launchpad.net, stable@vger.kernel.org
Subject: Re: [PATCH] [media] gspca-ov534: don't call sd_start() from sd_init()
References: <5205D969.4040301@gmail.com> <1376562572-10772-1-git-send-email-ospite@studenti.unina.it> <52135F42.1070707@redhat.com> <20130820151316.08617248d480ab5464ffde47@studenti.unina.it>
In-Reply-To: <20130820151316.08617248d480ab5464ffde47@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/20/2013 03:13 PM, Antonio Ospite wrote:
> On Tue, 20 Aug 2013 14:21:22 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
>
>> Hi,
>>
>> Thanks for the patch I've added this to my "gspca" tree, and this
>> will be included in my next pull-request to Mauro for 3.12
>>
>
> Thanks HdG.
>
> It's fine with me to have the patch in 3.12 and then have it picked up
> for inclusion in stable releases, I was just wondering why you didn't
> consider it as a fix for 3.11

I did not have time to do v4l work before now, and atm it is simply too
late for 3.11

Regards,

Hans
