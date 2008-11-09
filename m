Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9DVKQU005985
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 08:31:20 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9DV8H4004107
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 08:31:08 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811081917070.8956@axis700.grange>
	<87tzahwwr1.fsf@free.fr> <87y6ztxibu.fsf@free.fr>
	<Pine.LNX.4.64.0811091319540.4485@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 09 Nov 2008 14:31:06 +0100
In-Reply-To: <Pine.LNX.4.64.0811091319540.4485@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun\,
	9 Nov 2008 13\:36\:14 +0100 \(CET\)")
Message-ID: <87prl5xbz9.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 3/3] soc-camera: let camera host drivers decide upon
	pixel format
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert,
> As I wrote in the comment to the patch, I think, lists of pixel formats, 
> supported by sensors are rather static, therefore they can be easily 
> represented by a list of structures, that's what our ->formats are about.  
> Now, the latest patch changes the logic in a way, that this list is now 
> what a sensor offers, and not what the user gets, requests to set a format 
> are now handled by camera hosts, so they decide how to implement the 
> requested format. Now, we are almost that far. What I've forgotten about 
> and why, probably, you decided we still don't do that, is that the 
> ->formats array is still used for format enumeration. It shall not be. So, 
> I'm going to write another patch, that would move format enumeration into 
> host drivers. To do that, we will probably have to create such a list 
> _dynamically_ in .add() method based on the ->formats list _and_ host's 
> capabilities. We might use the ->host_priv link, I suggested in my 
> previous email, to hold that list. It would be even better to not have to 
> create such a list and just enumerate formats dynamically in the host 
> driver, but I am not sure how to handle the index... I'll have to think 
> about it a bit more.
>
> Does this answer your question?
Yes, absolutely. That's the right direction. I'm looking forward to see the
incremental patch, as you may guess ;) My YUV work is over, I'm just waiting for
the soc_camera patchset to stabilize to fire my own serie.

I'll try to think about the fully dynamic formats list, even if I prefer the
computed list at sensor attachment.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
