Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5UFKnfF008605
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:20:49 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.184])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5UFKUBB016891
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 11:20:31 -0400
Received: by nf-out-0910.google.com with SMTP id d3so446362nfc.21
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 08:20:30 -0700 (PDT)
Message-ID: <4868F9B9.2060300@gmail.com>
Date: Mon, 30 Jun 2008 18:20:25 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
References: <486553B5.9070609@gmail.com> <4868CEB0.2020901@gmail.com>
	<200806301706.28703.laurent.pinchart@skynet.be>
In-Reply-To: <200806301706.28703.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>,
	linux-uvc-devel@lists.berlios.de
Subject: Re: [Linux-uvc-devel] UVCVIDEO for 2.6.27 ?
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

Laurent Pinchart wrote:
> Hi Maxim,
> 
> On Monday 30 June 2008, Maxim Levitsky wrote:
>> Maxim Levitsky wrote:
>>> Hello,
>>>
>>> Is UVC driver planned for inclusion in 2.6.27?
>>>
>>> As a new user of this driver, I confirm that it works almost perfectly.
>>>
>>> cheese/xawtv/kdetv/zapping/ekiga work fine.
>>> tvtime complains about 'too short video frames'
>>>
>>> zapping crashes when trying to see settings dialog - almost for sure
>>> unrelated bug, this application is not stable.
>>>
>>> kdetv hangs on exit, app buggy as well, but maybe it triggers some race
>>> in videobuf, I have already triggered one race with this app once.
>>>
>>> The camera used to hang minutes after launch, but after I installed
>>> latest svn of
>>> uvcvideo the bug disappeared.
>>>
>>> Oh, almost forgot, I have Acer Crystal eye webcam integrated
>>> in my new laptop. aspire 5720.
>>>
>>> Best regards,
>>>     Maxim Levitsky
>> Any news?
> 
> I've just submitted the Linux UVC driver to the video4linux and linux-usb 
> mailing lists. Unless people report blocking issues it should get into 
> 2.6.27.
> 
> Best regards,
> 
> Laurent Pinchart

Thanks a lot for writing this driver,
it will surly help a lot with webcams, especially integrated ones.

Best regards,
	Maxim Levitsky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
