Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41758 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbcGFDkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 23:40:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1bKdgy-0003k4-D5
	for linux-media@vger.kernel.org; Wed, 06 Jul 2016 05:40:04 +0200
Received: from viz4.rc.colorado.edu ([128.138.65.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 05:40:04 +0200
Received: from chrischavez by viz4.rc.colorado.edu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 05:40:04 +0200
To: linux-media@vger.kernel.org
From: Christopher Chavez <chrischavez@gmx.us>
Subject: Re: usbvision: problems adding support for ATI TV Wonder USB Edition
Date: Wed, 6 Jul 2016 03:29:40 +0000 (UTC)
Message-ID: <loom.20160706T052858-643@post.gmane.org>
References: <CAAFQ00=2qFjs41KJs5evJVcCHjuCwtATeTL6aOvz8tN47_RyTQ@mail.gmail.com> <d37d5725-b6cb-fe15-1767-a28649153137@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 1, 2016 at 5:15 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Christopher,
>
> On 12/19/2015 07:12 AM, Christopher Chavez wrote:
>>
>> I'm still researching what other programs to test this with (VLC?
>> v4l-utils?)...
>
> I use qv4l2 from v4l-utils.

Thanks for the suggestion!

> Did you make any progress with this?
> 
> The problem is that the usbvision driver is very old and very badly written.
> And I doubt anyone will have time to upgrade this driver to modern standards.
>
> I don't mind taking this patch, but I should at least have confirmation that
> you got it to work :-)

I have not had any success yet. I haven't yet come across any documentation on
how to determine what values to use for the ATI device; I wanted to try reusing
values from another device first, but either some of those values are
completely off or there is a separate issue that needs to be addressed first
before I can test the ATI device. I don't own a "supported" device to help
determine which is the case.

I can try again as early as August; I'll resubmit if I make any progress.

> Regards,
>
>         Hans (who is cleaning out old submitted patches)
>

Thanks for following up.

Christopher Chavez


