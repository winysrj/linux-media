Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NL19fe021809
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 17:01:09 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.251])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NL0lSC024998
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 17:00:47 -0400
Received: by rv-out-0506.google.com with SMTP id b17so1578017rvf.51
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 14:00:41 -0700 (PDT)
Date: Wed, 23 Apr 2008 13:59:46 -0700
From: Brandon Philips <brandon@ifup.org>
To: Jon Lowe <jonlowe@aol.com>
Message-ID: <20080423205946.GO6703@plankton.ifup.org>
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
	<20080422040728.GD24855@plankton.ifup.org>
	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
	<20080423200134.GJ6703@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423200134.GJ6703@plankton.ifup.org>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
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

On 13:01 Wed 23 Apr 2008, Brandon Philips wrote:
>   $ netcat -u -l -p 666

Gah.  That should be:

  $ netcat -u -l -p 6666

Devils in the details ;)

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
