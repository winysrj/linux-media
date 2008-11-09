Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9CaLAd024017
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 07:36:21 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA9Ca9gA016388
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 07:36:09 -0500
Date: Sun, 9 Nov 2008 13:36:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87y6ztxibu.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811091319540.4485@axis700.grange>
References: <Pine.LNX.4.64.0811081917070.8956@axis700.grange>
	<87tzahwwr1.fsf@free.fr> <87y6ztxibu.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi Robert,

On Sun, 9 Nov 2008, Robert Jarzmik wrote:

> I thought a bit about pixel format negociation.
> 
> The thing that came to my mind is that it is not the sensor that can tell all
> the pixel formats available, it's the camera host. That means that icd->formats
> should be filled in by the host, not the sensor.
> 
> What I would see is a generic call in soc_camera (or a structure), called by
> each sensor to declare the pixel formats it handles. This call (or structure)
> will be used by camera host driver to fill in icd->formats, deduced from what
> the sensors offers, and the host possible translations.
> 
> Tell me you opinion about it please.

Well, actually, I consider pixel format negotiation implemented with my 
latest patch. Well, almost, I forgot about (at least) one part, which I 
can implement with an incremental patch.

As I wrote in the comment to the patch, I think, lists of pixel formats, 
supported by sensors are rather static, therefore they can be easily 
represented by a list of structures, that's what our ->formats are about.  
Now, the latest patch changes the logic in a way, that this list is now 
what a sensor offers, and not what the user gets, requests to set a format 
are now handled by camera hosts, so they decide how to implement the 
requested format. Now, we are almost that far. What I've forgotten about 
and why, probably, you decided we still don't do that, is that the 
->formats array is still used for format enumeration. It shall not be. So, 
I'm going to write another patch, that would move format enumeration into 
host drivers. To do that, we will probably have to create such a list 
_dynamically_ in .add() method based on the ->formats list _and_ host's 
capabilities. We might use the ->host_priv link, I suggested in my 
previous email, to hold that list. It would be even better to not have to 
create such a list and just enumerate formats dynamically in the host 
driver, but I am not sure how to handle the index... I'll have to think 
about it a bit more.

Does this answer your question?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
