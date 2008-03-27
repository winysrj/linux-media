Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2RIA2Pg024623
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 14:10:03 -0400
Received: from smtp808.mail.ird.yahoo.com (smtp808.mail.ird.yahoo.com
	[217.146.188.68])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2RI9lVf004049
	for <video4linux-list@redhat.com>; Thu, 27 Mar 2008 14:09:47 -0400
Message-ID: <47EBE2E6.5090801@btinternet.com>
Date: Thu, 27 Mar 2008 18:09:42 +0000
From: Edward Ludlow <eludlow@btinternet.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <47EBC75E.8040905@btinternet.com>	
	<37219a840803271052h59c73235pa44932bef06388a6@mail.gmail.com>
	<37219a840803271054i174dbf1ck3953d8e78ef79ab9@mail.gmail.com>
In-Reply-To: <37219a840803271054i174dbf1ck3953d8e78ef79ab9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Problems building v4l-dvb modules
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

Michael Krufky wrote:

>>  Don't do *make load* (I'll edit the wiki entry)
>>
>>  Reboot your computer, and it should be OK.
> 
> 
> Ugh, it's too much to change and I don't have the time right now....
> 
> 
> If anybody is interested in fixing this wiki entry, please be aware
> that "make load" and "make reload" are *never* appropriate.  Just
> modprobe the module that you need.  Loading ALL modules is a terrible
> idea, and is only useful for debugging if you *really* know what
> you're doing.
> 
> -Mike
> 

Thanks Mike.

So do I stop after "make install" or do the "make unload" as per the wiki?

Is that it then?  The wiki then goes on to explain errors you may get - 
and not a lot more.  What's the next step?

Please excuse the linux noobie questions!

Ed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
