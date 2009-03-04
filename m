Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n24043Ij004268
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 19:04:03 -0500
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.120])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2403kh1026904
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 19:03:46 -0500
Message-ID: <49ADC561.3090403@nc.rr.com>
Date: Tue, 03 Mar 2009 19:03:45 -0500
From: Andrew Robinson <awrobinson-ml@nc.rr.com>
MIME-Version: 1.0
To: semantikous@yahoo.com
References: <702621.62683.qm@web59709.mail.ac4.yahoo.com>
In-Reply-To: <702621.62683.qm@web59709.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: linux newbie tv card help
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

Robert Lastname wrote:
> Hello, I quit windows not too long ago and have no idea how to install a tv card.  I searched the internet but still don't know how any of this works.  Here is what I want to know:
> 
> Would someone please give me a quick run down of the steps needed to install a card.  I don't need anything in detail---just the very basics of what, in general, is going on.
> 
> like
> 
> 1. install card
> 2. install v4l-dev, v4l-apps
> 3. find chipset drivers and install.
> etc etc
> 
> I don't know where to begin, as so far what I've read is overwhelming and I can't make out what comes first and what comes after.  I want to take this one step at a time and I can't tell if I missed something important.

Start at linux-tv.org. Find a reference for the particular tuner card 
you have. Follow those references.

If you are using a very recent version of Linux, chances are, the 
drivers already exist in the kernel. You'll probably need to install 
some ancillary software, like v4l-apps. You'll need an application to 
view the TV. I use MythTV, which is a whole Tivo-like system. But again, 
start at linux-tv.org.

Andrew Robinson

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
