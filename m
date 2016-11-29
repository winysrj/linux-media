Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46559
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752395AbcK2RHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 12:07:32 -0500
Subject: Re: [PATCH 0/2] media protect enable and disable source handler paths
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
 <20161129071526.5a004b75@vento.lan>
Cc: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <9881c3f5-6d6a-14d0-8c22-da8a2eb8d268@osg.samsung.com>
Date: Tue, 29 Nov 2016 10:07:21 -0700
MIME-Version: 1.0
In-Reply-To: <20161129071526.5a004b75@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2016 02:15 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 28 Nov 2016 19:15:12 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> These two patches fix enable and disable source handler paths. These
>> aren't dependent patches, grouped because they fix similar problems.
> 
> Those two patches should be fold, as applying just the first patch
> would cause au0828 to try to double lock.
> 

No it doesn't. The first patch holds the lock to just clear and set
enable disable source handlers and doesn't change any other paths.
The second patch removes lock hold from enable and disable source
handlers and the callers to hold the lock.

However, I can easily fold them together and not a problem.

>>
>> This work is triggered by a review comment from Mauro Chehab on a
>> snd_usb_audio patch about protecting the enable and disabel handler
>> path in it.
>>
>> Ran tests to make sure enable and disable handler paths work. When
>> digital stream is active, analog app finds the tuner busy and vice
>> versa. Also ran the Sakari's unbind while video stream is active test.
> 
> Sorry, but your patches descriptions don't make things clear:

Right. I should have explained it better.

> 
> - It doesn't present any OOPS or logs that would help to
>   understand what you're trying to fix;
> 
> - From what I understood, you're moving the lock out of
>   enable/disable handlers, and letting their callers to do
>   the locks themselves. Why? Are there any condition where it
>   won't need to be locked?

So here is the scenario these patches fix. Say user app starts
and during start of video streaming v4l2 checks to see if enable
source handler is defined. This check is done without holding the
graph_mutex. If unbind happens to be in progress, au0828 could
clear enable and disable source handlers. So these could race.
I am not how large this window is, but could happen.

If graph_mutex protects the check for enable source handler not
being null, then it has to be released before calling enable source
handler as shown below:

if (mdev) {
	mutex_lock(&mdev->graph_mutex);
	if (mdev->disable_source) {
		mutex_unlock(&mdev->graph_mutex);
		mdev->disable_source(&vdev->entity);
	} else
		mutex_unlock(&mdev->graph_mutex);
}

The above will leave another window for handlers to be cleared.
That is why it would make sense for the caller to hold the lock
and the call enable and disable source handlers.

> 
> - It is not touching documentation. If now the callbacks should
>   not implement locks, this should be explicitly described.

Yes documentation needs to be updated and I can do that in v2 if
we are okay with this approach.

> 
> Btw, I think it is a bad idea to let the callers to handle
> the locks. The best would be, instead, to change the code in
> some other way to avoid it, if possible. If not possible at all,
> clearly describe why it is not possible and insert some comments
> inside the code, to avoid some cleanup patch to mess up with this.
> 

Hope the above explanation helps answer the question. We do need a
way to protect enable and disable handler access and the call itself.
I am using the same graph_mutex for both, hence I decided to have the
caller hold the lock. Any other ideas welcome.

thanks,
-- Shuah

