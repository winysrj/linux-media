Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1Iuixg022308
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:56:44 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1IuVar020994
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 13:56:31 -0500
Received: by qw-out-2122.google.com with SMTP id 3so563983qwe.39
	for <video4linux-list@redhat.com>; Mon, 01 Dec 2008 10:56:30 -0800 (PST)
Message-ID: <7d7f2e8c0812011056r4f364e06la2873a829bcdc228@mail.gmail.com>
Date: Mon, 1 Dec 2008 10:56:29 -0800
From: "Steve Fink" <sphink@gmail.com>
To: "Carl Karsten" <carl@personnelware.com>
In-Reply-To: <49339FB1.7000700@personnelware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7d7f2e8c0811302255q3168bbe1yfcd075616d4d9fc6@mail.gmail.com>
	<49339FB1.7000700@personnelware.com>
Cc: video4linux-list@redhat.com
Subject: Re: USB device for uncompressed NTSC capture
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

On Mon, Dec 1, 2008 at 12:26 AM, Carl Karsten <carl@personnelware.com> wrote:
>
> if it only has analog out, how will the 1394 help?

Oh, sorry. I was thinking of an external device with analog input and
1394 output. My laptop has a 1394 port.

Ah, yes. They do exist:
<http://www.firewire-1394.com/canopus-advc55.htm>. But (1) I was
hoping to pay about a quarter of that, and (2) I still don't
understand the Linux side of it  -- although it seems like it
shouldn't be a problem; I'm assuming I can use a generic 1394 video
capture driver, whereas USB would be device-specific. There is a v4l
driver for 1394, I hope?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
