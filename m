Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2IDcQ8v027895
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 09:38:26 -0400
Received: from mail.hidayahonline.org (hidayahonline.org [67.19.146.138])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2IDcDC5024076
	for <video4linux-list@redhat.com>; Thu, 18 Mar 2010 09:38:13 -0400
Message-ID: <4BA22CBF.3080902@hidayahonline.org>
Date: Thu, 18 Mar 2010 09:38:07 -0400
From: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Re: .yuv file
References: <fe6fd5f61003180356i4f9346b9j31089e4d6fa94a44@mail.gmail.com>
In-Reply-To: <fe6fd5f61003180356i4f9346b9j31089e4d6fa94a44@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 03/18/2010 06:56 AM, Carlos Lavin wrote:
> hello, I am making an application for save images in yuv format in files
> with .yuv extension, but I don't find information about how the information
> about the image is save in the file, how the image is saved in the file? how
> it is organized in the file .yuv? anyboy can help me? anybody kwon any link
> where to explain my problem? thanks
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>   
A "yuv" format image is a raw stream of bits.  It does not normally
store *any* metadata about the image itself.  So, typically, there's no
way to know the dimensions of the image, the framerate of the stream, or
even the format of the pixels themselves.  You will have to know these
yourself if you wish to work with those images, and since you're
creating them, that shouldn't be a problem.

If, on the other hand, you want to store raw, uncompressed data but
retain some metadata about it, you can choose the yuv4mpeg format, which
can store data such as the resolution, pixel format, frame rate, and
even whether the frames are progressive or interlaced.  A yuv4mpeg file
has nothing explicitly to do with mpeg video, it was just named that
because that was the original primary use for such raw data.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
