Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59069 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654AbbAOQdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 11:33:01 -0500
Message-ID: <1421339578.2355.2.camel@xs4all.nl>
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>, ray@apollo.lv
Date: Thu, 15 Jan 2015 17:32:58 +0100
In-Reply-To: <1421168382.2615.1.camel@xs4all.nl>
References: <54B52548.7010109@xs4all.nl> <1421168382.2615.1.camel@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 2015-01-13 at 17:59 +0100, Jurgen Kramer wrote:
> Hi Hans,
> On Tue, 2015-01-13 at 15:01 +0100, Hans Verkuil wrote:
> > Hi Raimonds, Jurgen,
> > 
> > Can you both test this patch? It should (I hope) solve the problems you
> > both had with the cx23885 driver.
> > 
> > This patch fixes a race condition in the vb2_thread that occurs when
> > the thread is stopped. The crucial fix is calling kthread_stop much
> > earlier in vb2_thread_stop(). But I also made the vb2_thread more
> > robust.
> 
> Thanks. Will test your patch and report back.
I have tested the patch, unfortunately results are not positive.
With the patch MythTV has issues with the tuners. Live TV no longer
works and eventually mythbackend hangs. Reverting the patch brings
everything back to a working state.

Regards,
Jurgen

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


