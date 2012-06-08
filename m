Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44789 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2FHWXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 18:23:17 -0400
Received: by vcbf11 with SMTP id f11so1282195vcb.19
        for <linux-media@vger.kernel.org>; Fri, 08 Jun 2012 15:23:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120608214229.GH5761@phenom.ffwll.local>
References: <4fbf6893.a709d80a.4f7b.0e0eSMTPIN_ADDED@mx.google.com>
 <CACSP8SgSi+v70+-r1wR1hM0rDzmJK0g20i0fxRePLPuTXqrxuA@mail.gmail.com>
 <CAO8GWq=UYWTuJ=V6Luh4z49=og2X2wrHzVNYvbK7Tnw2zgzNeA@mail.gmail.com>
 <CACSP8Sgog0cDtxG+JsWQ=aYyiXtEr-N7+xPPRsAjwt3LAYC+uw@mail.gmail.com>
 <CAO8GWqnVN3tVp2chzsYKjhfzoupxsWwUT_LojzJ7kYWPRdZYJw@mail.gmail.com>
 <CACSP8SiVYiEg8BY9gvmbqiKNXEwEjHa+vxOvXpEgr+W-Wd5+rg@mail.gmail.com>
 <4fd09200.830ed80a.24f9.1a54SMTPIN_ADDED@mx.google.com> <CACSP8SgrB2YxsvUx6y-EomgJhupb3uVmF_hH0Sd-PG6G6G9Cfg@mail.gmail.com>
 <20120608214229.GH5761@phenom.ffwll.local>
From: Erik Gilling <konkers@android.com>
Date: Fri, 8 Jun 2012 15:22:56 -0700
Message-ID: <CACSP8SiyzYHZJNxuNoVOqPCj-FwWy3dNMxhoixrwKfQt+2g7jg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] Synchronizing access to buffers shared with
 dma-buf between drivers/devices
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Tom Cooksey <tom.cooksey@arm.com>, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 8, 2012 at 2:42 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> I think this is an approach worth investigating.  I'd like a way to
>> either opt out of implicit sync or have a way to check if a dma-buf
>> has an attached fence and detach it.  Actually, that could work really
>> well. Consider:
>>
>> * Each dma_buf has a single fence "slot"
>> * on submission
>>    * the driver will extract the fence from the dma_buf and queue a wait on it.
>>    * the driver will replace that fence with it's own complettion
>> fence before the job submission ioctl returns.
>
> This is pretty much what I've had in mind with the extension that we
> probably need both a read and a write fence - in a lot of cases multiple
> people want to use a buffer for reads (e.g. when decoding video streams
> the decode needs it as a reference frame wheras later stages use it
> read-only, too).

I actually hit "send" instead of "save draft" on this before talking
this over with some co-workers.  We came up with the same issues.  I'm
actually less concerned about the specifics as long as we have a way
to attach and detach the fences.

>> * dma_buf will have two userspace ioctls:
>>    * DETACH: will return the fence as an FD to userspace and clear the
>> fence slot in the dma_buf
>>    * ATTACH: takes a fence FD from userspace and attaches it to the
>> dma_buf fence slot.  Returns an error if the fence slot is non-empty.
>
> I am not yet sold on explicit fences, especially for cross-device sync. I
> do see uses for explicit fences that can be accessed from userspace for
> individual drivers - otherwise tricks like suballocation are a bit hard to
> pull off. But for cross-device buffer sharing I don't quite see the point,
> especially since the current Linux userspace graphics stack manages to do
> so without (e.g. DRI2 is all implicit sync'ed).

The current linux graphics stack does not allow synchronization
between the GPU and a camera/video decoder.  When we've seen people
try to support this behind the scenes, they get it wrong and introduce
bugs that can take weeks to track down.  As stated in the previous
email, one of our goals is to centrally manage synchronization so that
it's easer for people bringing up a platform to get it right.

> btw, I'll try to stitch together a more elaborate discussion over the w/e,
> I have a few more pet-peeves with your actual implementation ;-)

Happy to hear feedback on the specifics.

-Erik
