Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m867f6EY030484
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 03:41:07 -0400
Received: from smtp-out2.blueyonder.co.uk (smtp-out2.blueyonder.co.uk
	[195.188.213.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m867eLQS023606
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 03:40:21 -0400
Message-ID: <48C233E6.3020407@blueyonder.co.uk>
Date: Sat, 06 Sep 2008 08:40:22 +0100
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: danflu@uninet.com.br
References: <48c16426.349.7a8c.1092537460@uninet.com.br>
In-Reply-To: <48c16426.349.7a8c.1092537460@uninet.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Capture card
Reply-To: ian.davidson@bigfoot.com
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

Hi Daniel,

If what you want to do is simply to capture I would suggest that you 
take a look at xawtv.

The 'package' comes with 'xawtv' itself which is menu driven and allows 
you to view the video on screen.  You can select from the various 
sources and you can capture if you want.  Also included in the 'package' 
is 'streamer' which is a command-line program which will capture from 
the nominated source to a file.  Various formats are supported.

On the other hand, if you want to look at some code - you will need to 
be guided by someone else.

Ian

danflu@uninet.com.br wrote:
> Hello,
>
> I have a capture card with three types of input:
>
> -composite video
> -Svideo
> -tunner.
>
> I'm looking for some code ilustrating how to capture from a
> capture card device. 
>
> Is it possible ? If so , how can i do this ?
>
> Please Help,
>
> Thanks
> Daniel
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>   

-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
