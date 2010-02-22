Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63286 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0BVVi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:38:57 -0500
Received: by bwz1 with SMTP id 1so469752bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 13:38:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B82F7F4.3090802@redhat.com>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <1266838852.3095.20.camel@palomino.walls.org>
	 <4B827548.10005@redhat.com>
	 <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
	 <4B828939.4040708@redhat.com>
	 <829197381002220547n3468019bmdb17f401f7c5b6e1@mail.gmail.com>
	 <4B828D9C.50303@redhat.com>
	 <829197381002221317p42dda715lbd7ea1193c40d45c@mail.gmail.com>
	 <4B82F7F4.3090802@redhat.com>
Date: Mon, 22 Feb 2010 16:38:56 -0500
Message-ID: <829197381002221338q6af601bfs8d99632f82b75c8e@mail.gmail.com>
Subject: Re: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	hverkuil@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2010 at 4:32 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Devin Heitmueller wrote:
>> In fact, I would be in favor of taking the basic logic found in
>> cx18_g_ext_ctrls(), and making that generic to the videodev interface,
>> such that any driver which provides a user control interface but
>> doesn't provide an extended control function will work if the calling
>> application makes an extended control call.  This will allow userland
>> applications to always use the extended controls API, even if the
>> driver didn't explicitly add support for it.
>
> That's exactly the idea: convert all driverst o use ext_ctrl's and let the
> V4L2 core to handle the calls to the non-extended interface.

I think you actually missed the point of what I'm trying to say:  You
can only do the opposite of what you proposed:  You can have the v4l2
core receive extended interface calls and pass those calls through to
the older interface in drivers (since the older interface is a
*subset* of the newer interface).  However, you cannot provide a way
for callers of the older interface have those requests passed through
to the new interface (since the old interface does not support
multiple controls in one call and there are multiple classes of
controls in the newer interface).

In other words, a caller using the extended interface can
automatically call the old interface, but a caller using the old
interface cannot automatically call into the extended interface.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
