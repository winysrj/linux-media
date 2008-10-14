Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EJHUBX032749
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 15:17:30 -0400
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9EJGbwW013599
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 15:17:08 -0400
Received: from mx34.stngva01.us.mxservers.net (204.202.242.42)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-0411401796
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 15:16:37 -0400 (EDT)
Message-ID: <48F4F013.5090601@sensoray.com>
Date: Tue, 14 Oct 2008 12:16:35 -0700
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48F4CF01.8020602@sensoray.com>
In-Reply-To: <48F4CF01.8020602@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: v4l2 field types
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

Sorry, please ignore this question re spec. 0.24.  I found the 
V4L2_MODE_HIGHQUALITY definition.  It's not ideal, however, because 
there may be different algorithms implemented (or desired) to remove the 
artifacts.


dean wrote:
> Re: http://v4l2spec.bytesex.org/spec/x6386.htm
> 
> Is there a v4l2_field if the capture hardware does the "de-interlacing" 
> to compensate for motion artifacts for full size NTSC/PAL video?
> 
> Our hardware has 2 modes for full size.  One where it outputs the top 
> and bottom fields interlaced without modification(default 2255 setting). 
>  The other where it compensates for motion by removing "comb" or 
> "feathering" artifacts in the hardware.  This second mode still 
> transmits both fields at the same time interlaced in one buffer.
> 
> 
> 
> 
> 
> 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
