Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1BCnHkE025733
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 07:49:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1BCmuk8012017
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 07:48:56 -0500
Date: Mon, 11 Feb 2008 10:48:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Guillaume Quintard" <guillaume.quintard@gmail.com>
Message-ID: <20080211104821.00756b8e@gaivota>
In-Reply-To: <1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
	<1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Question about saa7115
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

On Fri, 8 Feb 2008 18:27:19 -0800
"Guillaume Quintard" <guillaume.quintard@gmail.com> wrote:

> thank you for your answers, I think I have a better understanding of
> what's happenning.
> still, Imade a little test to be sure, and it didn't return what I expected
> 
> I added a print_test function (printk something then return 0) to
> vivi.c, and pointed .ioctl (in the file_operations structure) to that
> function, and started this :
> int main(int argc, char *argv[])
> {
>         int err;
>         struct v4l2_capability cap;
>         int fd = open("/dev/video0", O_RDWR );
>         err = ioctl(fd, VIDIOC_QUERYCAP, &cap);
>         return 0;
> }
> (consider required includes done)
> 
> vivi tells me the device is opened, closed (yeah, I know, I should
> have coded the close instruction) but nothing between those two, did I
> missed something, such as the fact that vivi doesn't respond to ioctl
> ?

Vivi will show all ioctls called, if you use debug=3.
> 
> regards
> 




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
