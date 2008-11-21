Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJMSeY011422
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:22:28 -0500
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALJMEkA021322
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:22:15 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 21 Nov 2008 20:22:12 +0100
In-Reply-To: <Pine.LNX.4.64.0811202055210.8290@axis700.grange> (Guennadi
	Liakhovetski's message of "Thu\,
	20 Nov 2008 21\:43\:40 +0100 \(CET\)")
Message-ID: <8763mg28bf.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

>> If we're in pass-through mode, and depth is 16 (example: a today unknown RYB
>> format), we return -EINVAL. Is that on purpose ?
>
> Yes, I do not know how to pass a 16-bit format in a pass-through mode, and 
> I don't have a test-case for it. Do you?
BYR2 I think (12bit Bayer in 16bit words), and Bxxx (10bit Bayer in 16bit
words).

And I can test the 10bit Bayer on 16bit words on mt9m111, and will do.

>> > -	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
>> > +	int ret = test_platform_param(pcdev, buswidth, &bus_flags);
<snip>
>> Likewise, is bus param matching necessary here, or should it be done at format
>> generation ? Can that be really be dynamic, or is it constrained by hardware,
>> and thus only necessary at startup, and not at each format try ?
>
> Hm, ok, so far I don't have any cases, where bus parameters can change at 
> run-time. So, yes, I think, we could shift it into 
> pxa_camera_get_formats().
Right. Roger.

>> What if pcdev->platform_flags is 9 bits wide and sensor provides RGB565 ?
>> Variable formats will be incremented, but fmt will never be filled in. So there
>> will be holes in fmt. Shouldn't the formats++ depend on platform_flags &
>> PXA_CAMERA_DATAWIDTH_8 ?
>
> Right, that's a bug, will fix, thanks. Same as above for 
> V4L2_PIX_FMT_UYVY.
OK.

>> > +	default:
>> > +		/* Generic pass-through */
>> > +		if (depth_supported(icd, icd->formats[idx].depth)) {
>> > +			formats++;
>> > +			if (fmt) {
<snip>
>
> No, this looks correct - it first checks for depth_supported().
You're right, sorry.

> I know this code repeats, and it is not nice. But as I was writing it I 
> didn't see another possibility. Or more precisely, I did see it, but I 
> couldn't compare the two versions well without having at least one of them 
> in code in front of my eyes:-) Now that I see it, I think, yes, there is a 
> way to do this only once by using a translation struct similar to what you 
> have proposed. Now _this_ would be a possibly important advantage, so it 
> is useful not _only_ for debugging:-) But we would have to extend it with 
> at least a buswidth. Like
>
> 	const struct soc_camera_data_format *cam_fmt;
> 	const struct soc_camera_data_format *host_fmt;
> 	unsigned char buswidth;
>
> Now this _seems_ to provide the complete information so far... In 
> pxa_camera_get_formats() we would
>
> 1. compute camera- and host-formats and buswidth
> 2. call pxa_camera_try_bus_param() to check bus-parameter compatibility
>
> and then in try_fmt() and set_fmt() just traverse the list of translation 
> structs and adjust geometry?
That sounds great. I'm on it.

>> All in all, I wonder why we need that many tests, and if we could reduce them at
>> format generation (under hypothesis that platform_flags are constant and sensor
>> flags are constant).
>
> Ok, I propose you make the next round:-) I would be pleased if you base 
> your new patches on these my two, and just replace the user_formats with a 
> translation list, and modify pxa try_fmt() and set_fmt() as discussed 
> above. I would be quite happy if you mark them "From: <you>". Or if you do 
> not want to - let me know, I'll do it. And please do not make 13 patches 
> this time:-) I think, two should be enough.
I'll be happy to make the next round.

Give me a couple of days, and I'll post the 2 patches, on top of your serie
(serie which will end with your 2 patches). After review, you can either merge
each one of them with yours, or take them apart.

Don't worry, I won't flood the list anymore :)

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
