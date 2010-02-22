Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55155 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0BVVR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:17:26 -0500
Received: by bwz1 with SMTP id 1so452348bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 13:17:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B828D9C.50303@redhat.com>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <1266838852.3095.20.camel@palomino.walls.org>
	 <4B827548.10005@redhat.com>
	 <829197381002220510v64f6e948pfb73ebe4fcc180af@mail.gmail.com>
	 <4B828939.4040708@redhat.com>
	 <829197381002220547n3468019bmdb17f401f7c5b6e1@mail.gmail.com>
	 <4B828D9C.50303@redhat.com>
Date: Mon, 22 Feb 2010 16:17:24 -0500
Message-ID: <829197381002221317p42dda715lbd7ea1193c40d45c@mail.gmail.com>
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

On Mon, Feb 22, 2010 at 8:58 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>> Ok then.  I'll add the 15-20 lines of code which add the extended
>> controls mechanism to the 7115, which just operates as a passthrough
>> for the older control interface.
>
> The better is to do the opposite: extended being the control interface and
> the old calls as a passthrough, since the idea is to remove the old interface
> after having all drivers converted.

I gave this a bit of thought, and I'm not sure what you are proposing
is actually possible.  Because the extended controls provides a
superset of the functionality of the older user controls interface, it
is possible to create a extended control callback which just passes
through the request (since any user control can be converted into a
extended control).  However, you cannot convert the extended control
results into the older user control format, since not all the
information could be provided.

In fact, I would be in favor of taking the basic logic found in
cx18_g_ext_ctrls(), and making that generic to the videodev interface,
such that any driver which provides a user control interface but
doesn't provide an extended control function will work if the calling
application makes an extended control call.  This will allow userland
applications to always use the extended controls API, even if the
driver didn't explicitly add support for it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
