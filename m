Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154Ab2D3LLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 07:11:34 -0400
Message-ID: <4F9E73F7.6040207@redhat.com>
Date: Mon, 30 Apr 2012 13:13:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [RFCv1 PATCH 0/7] gspca: allow use of control framework and other
 fixes
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/28/2012 05:09 PM, Hans Verkuil wrote:
> Hi all,
>
> Here is a patch series that makes it possible to use the control framework
> in gspca. The gspca core changes are very minor but as a bonus give you
> priority support as well.
>
> The hard work is in updating the subdrivers. I've done two, and I intend
> to do the stv06xx driver as well, but that's the last of my gspca webcams
> that I can test. Looking through the subdrivers I think that 50-70% are in
> the category 'easy to convert', the others will take a bit more time
> (autogain/gain type of constructs are always more complex than just a simple
> brightness control).
>
> After applying this patch series the two converted drivers pass the
> v4l2-compliance test as it stands today.

I haven't looked at any details yet, but from the description I love the changes :)

I was actually planning on doing something very similar myself soon-ish, so you've
saved me a bunch of work :)

I'll review this and add these to my tree. Jean-Francois, is it ok for these changes
to go upstream through my tree? The reason I'm asking is that I plan to convert
more subdrivers to the control framework for 3.5 and its easiest to have this all
in one tree then.

If you've remarks to the core changes I will make sure these get addressed in my
tree of course.

Regards,

Hans (the other Hans :)


