Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2LEeXd1011932
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 10:40:33 -0400
Received: from mta2.srv.hcvlny.cv.net (mta2.srv.hcvlny.cv.net [167.206.4.197])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2LEdu8Y028514
	for <video4linux-list@redhat.com>; Fri, 21 Mar 2008 10:39:56 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JY3004XR4QE46Z0@mta2.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Fri, 21 Mar 2008 10:39:51 -0400 (EDT)
Date: Fri, 21 Mar 2008 10:39:50 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <C82A808D35A16542ACB16AF56367E0580A796941@exchange01.nsighttel.com>
To: Mark A Jenks <Mark.Jenks@nsighttel.com>
Message-id: <47E3C8B6.2060508@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <C82A808D35A16542ACB16AF56367E0580A796941@exchange01.nsighttel.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge remote.
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

Mark A Jenks wrote:
> I have a HVR-1250 that I just got working, and I"m not sure if this is 
> the right place for this question.
>  
> What does it take to get this remote working in Linux?   I'd like to use 
> it over my lirc_imon, since I can move the IR around for better reception.
>  
> Is this a question for Lirc?  Or does this fall under Dvb?

It probably falls under the v4l mailing list, which I've cc'd in for 
reference.

The HVR1250 uses IR on the cx23885 which is not currently supported. 
It's going to be a while before I get around to this.

Regards,

- Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
