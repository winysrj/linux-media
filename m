Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABC2FeE018251
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 07:02:15 -0500
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABC2DXc022261
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 07:02:14 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811101323490.4248@axis700.grange>
	<Pine.LNX.4.64.0811101335170.4248@axis700.grange>
	<874p2fkwh5.fsf@free.fr>
	<Pine.LNX.4.64.0811110834140.4565@axis700.grange>
	<87k5bar0aq.fsf@free.fr>
	<Pine.LNX.4.64.0811111220130.4565@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 11 Nov 2008 13:02:12 +0100
In-Reply-To: <Pine.LNX.4.64.0811111220130.4565@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue\,
	11 Nov 2008 12\:31\:46 +0100 \(CET\)")
Message-ID: <87y6zqpj23.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 5/5] pxa-camera: framework to handle camera-native and
	synthesized formats
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

> Don't you think we can have a default case? If the format requested by the 
> user is provided by the camera and we "can trandfer it 1-to-1" (bus-width 
> == depth or some such) then just switch on the pass-through mode?
Yes, we should, you're perfectly right.
>
> Wow, I'm scared...:-) Ok, let's try it your way, I don't want to play the 
> "maintainer" card, and you seem to be strongly in favour of a central 
> solution, whereas I just slightly incline towards local... So, either give 
> me a few days, or feel free to code off - whichever you prefer.

Well, since I bring the burden, I'll bring in the solution too, that's fair.

What I can do is make the translation in pxa_camera, but generic enough so that
it's transplantation to soc_camera is only a matter of copy/paste (with a bit of
renaming).
That way, we'll have :
 - the local model holding : no centralization in soc_camera
 - if you see a wave of incoming host cameras copy pasting that bit of code,
 transplant that to soc_camera.
 - tradeoff between your model and my model.

Do you like that approach ? If you prefer the soc_camera one (translation code
in soc_camera), I'll put it in there, just tell me.

> If you do this, I think, best do something like
>
> int soc_camera_host_register(struct soc_camera_host *ici)
> {
> ...
> 	if (!ici->ops->enum_fmt)
> 		ici->ops->enum_fmt = soc_camera_enum_fmt;
> ...
>
> etc. for any other methods you want to provide defaults for. Instead of 
> exporting more functions and letting hosts do
>
> int x_do_something(...)
> {
> 	return soc_camera_do_something(...);
> }
Yep. Sounds less poluting to kernel namespace.

OK, now I'm on the coding path, let's see what futur brings :)

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
