Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO8Li3U005362
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:21:44 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO8LXT1002218
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:21:33 -0500
Received: by nf-out-0910.google.com with SMTP id d3so976434nfc.21
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 00:21:32 -0800 (PST)
Message-ID: <4389ffee0811240021x35389c40h3bce88881ddc64f1@mail.gmail.com>
Date: Mon, 24 Nov 2008 09:21:32 +0100
From: "Jens Bongartz" <bongartz@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: Testing Requested: Python Bindings for Video4linux2
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

Hi Jackson, Laurent and Carl,

I would appreciate the uvcvideo supprt of the Python bindings for
Video4Linux2 a lot.
Could you send a message on this list, when its done?

Thanks a lot,
Jens


Lauren,

On Wed, Nov 5, 2008 at 7:42 PM, Laurent Pinchart
<laurent.pinchart@xxxxxxxxx> wrote:
> The uvcvideo driver doesn't implement the standard ioctls. This should not be
> fatal (and you probably want to define FindKeyas well).

The standard ioctls are, unfortunately, all I have to go by since I'm
testing on my amd64 box with a bttv card. If a function does not
succeed though, it should throw an exception and let the user code
sort things out. Do you have a link for the uncvideo driver so I could
add support for it?

FindKey looks to be Carl's code. ;-) I've added the function now.

> The problem comes from a bad alignment in the PixFormat structure. At least on
> my architecture (x86) the type field is 32 bits wide.

I've updated the type field on PixFormat to c_long, which should come
out to be the right size on both x86 and amd64 platforms now.

Thanks for the test. I'm working on adding libavcodec/libavformat
support so that we can capture straight to video instead of jpegs like
we're doing now. Please let me know if we have any other issues.

-- 
Regards,
Jackson Yee
The Possum Company
540-818-4079
me@xxxxxxxxxxxxx

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@xxxxxxxxxx?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
