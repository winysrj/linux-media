Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3EMlTVD032686
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 18:47:29 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3EMlIwp022481
	for <video4linux-list@redhat.com>; Mon, 14 Apr 2008 18:47:18 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZC00ING7AO2961@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Mon, 14 Apr 2008 18:47:12 -0400 (EDT)
Date: Mon, 14 Apr 2008 18:47:12 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48037622.2040506@gmail.com>
To: Scott Z <zuidemsr@gmail.com>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Message-id: <4803DEF0.8090003@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <478CA9C0.6060004@egrandrapids.net> <478CD0A5.1000700@linuxtv.org>
	<48037622.2040506@gmail.com>
Cc: 
Subject: Re: Pinnacle HD 801e
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

Scott Z wrote:
> Steve,
> 
> I saw you were working on a driver for the HVR950Q.  I recently went out 
> to purchase a Pinnacle 800e, and it turned out to be an 801e.  I was 
> thinking the 801e was a copy of the HVR950Q since I thought the 800e was 
> a copy of the HVR950.
> 
> I tried to use the HVR950Q repository that you have.  I just simply 
> changed the device ID to make a 801e look like a HVR950Q.  This didn't 
> work.  I wondered this was too simple of an approach.  Also, if there is 
> an advice you can give on things I could try, that would be great.  I 
> have a fairly good programming background, but limited driver support.

Hey Scott,

Bad choice, 950q is a good stick.

I've copied the v4l mailing list on this reply, as other may be able to 
help.

Have you opened the device? Do you know what parts it contains? Do you 
have a list of the windows driver files - perhaps we can partly 
determine form this.

Also please include the lsusb -v output for this device.

Thanks,

Steve


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
