Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2EEHfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 03:35:04 -0400
Message-ID: <4FA4D910.6010906@redhat.com>
Date: Sat, 05 May 2012 09:38:56 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 0/7] gspca: allow use of control framework and other
 fixes
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <4F9E73F7.6040207@redhat.com> <20120501122830.2c4d4cbe@tele>
In-Reply-To: <20120501122830.2c4d4cbe@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/01/2012 12:28 PM, Jean-Francois Moine wrote:
> On Mon, 30 Apr 2012 13:13:59 +0200
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> I'll review this and add these to my tree. Jean-Francois, is it ok for these changes
>> to go upstream through my tree? The reason I'm asking is that I plan to convert
>> more subdrivers to the control framework for 3.5 and its easiest to have this all
>> in one tree then.
>
> Hi Hans,
>
> As you know, I don't like them, but no matter, I am a bit tired
> about the webcams (4 years now) and I'd be glad to change for new
> applications (wayland, haiku, ARM?).

I will be sad to see you stop maintaining gspca, but I can understand that
after 4 years you want a change. Thanks for the great job you've
done on gspca! So is there nothing we can do to change your mind?

 > Is anybody interested in maintaining the gspca stuff?

I can take over gspca maintenance if you want me to.

So if you're really going to stop maintaining gspca, may I suggest that
you start playing with arm. The trimslice, which I've just bought myself :)

I should get mine on Monday. It is a really nice machine for development
(enough cpu power and ram to compile on the machine which is a lot
easier then cross compilation). You can find the trimslice here:
http://trimslice.com/web/

I'm going to work on getting Fedora to support the trimslice as good
as possible. One interesting area where your hardware talents may
be very useful is getting FOSS support for the NVidia Tegra 2 video
core on the trimslice. There are already some people working on
an opensource (kms) driver for it but I'm sure they could use some
help.

Regards,

Hans


