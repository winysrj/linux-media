Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SJm9sA003020
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 15:48:09 -0400
Received: from ian.pickworth.me.uk (ian.pickworth.me.uk [81.187.248.227])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SJlwcU029255
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 15:47:59 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 8D1EC13123FB
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 19:47:58 +0000 (GMT)
Received: from ian.pickworth.me.uk ([127.0.0.1])
	by localhost (ian.pickworth.me.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mndL1b16omis for <video4linux-list@redhat.com>;
	Tue, 28 Oct 2008 19:47:58 +0000 (GMT)
Received: from [192.168.1.11] (ian2.pickworth.me.uk [192.168.1.11])
	by ian.pickworth.me.uk (Postfix) with ESMTP id 4E9EC13123FA
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 19:47:58 +0000 (GMT)
Message-ID: <49076C6D.7080509@pickworth.me.uk>
Date: Tue, 28 Oct 2008 19:47:57 +0000
From: Ian Pickworth <ian@pickworth.me.uk>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
References: <49075186.7090101@pickworth.me.uk> <49075DA9.3000501@hhs.nl>
In-Reply-To: <49075DA9.3000501@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: libv4l: Skype terminates after options dialogue is closed
Reply-To: ian@pickworth.me.uk
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

Hans de Goede wrote:
> Ian Pickworth wrote:
>> The process I go through is as follows:
>>     LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so /usr/bin/skype &
>>     
>>     After Skype starts, open the Skype options dialogue
>>     Select the "Video Devices" tab
>>     With "Enable Skype Video" enabled, select the Camera device
>>     Press "test" - which shows the webcam picture correctly
>>
>>     Press close
>>
>> At this point Skype aborts.
>> ...
>> Bus 002 Device 003: ID 046d:092e Logitech, Inc.
> 
> Thats a spca561 cam, I've just run skype with the latest gspca + libv4l
> on an other spca561 cam with the same revision spca561 asic and it works
> fine.
> 
> So I believe this is caused by something else on your system.

I think you are correct. This happens when I run Skype in a Gnome
session, with compiz-fusion, and Kaffiene has been active.

If I go to a FVWM session, and just start Skype and nothing else, it
works fine. If I then Start Kaffiene Skype will abort soon after (if
I've used the webcam in Skype).

So, some wierd clash/timing issue. I'll just have to try and pin it down.
Thanks for the help,
Regards
Ian


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
