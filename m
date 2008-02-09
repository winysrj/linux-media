Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m192Rhx1001345
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 21:27:43 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m192RMZX007340
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 21:27:22 -0500
Received: by wa-out-1112.google.com with SMTP id j37so744649waf.7
	for <video4linux-list@redhat.com>; Fri, 08 Feb 2008 18:27:19 -0800 (PST)
Message-ID: <1e5fdab70802081827x4b656625h3b20332d0ee030ab@mail.gmail.com>
Date: Fri, 8 Feb 2008 18:27:19 -0800
From: "Guillaume Quintard" <guillaume.quintard@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080207181136.5c8c53fc@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1e5fdab70802061744u4b053ab3o43fcfbb86fe248a@mail.gmail.com>
	<20080207174703.5e79d19a@gaivota>
	<1e5fdab70802071203ndbce13an1fa226d5ec3e4ca1@mail.gmail.com>
	<20080207181136.5c8c53fc@gaivota>
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

thank you for your answers, I think I have a better understanding of
what's happenning.
still, Imade a little test to be sure, and it didn't return what I expected

I added a print_test function (printk something then return 0) to
vivi.c, and pointed .ioctl (in the file_operations structure) to that
function, and started this :
int main(int argc, char *argv[])
{
        int err;
        struct v4l2_capability cap;
        int fd = open("/dev/video0", O_RDWR );
        err = ioctl(fd, VIDIOC_QUERYCAP, &cap);
        return 0;
}
(consider required includes done)

vivi tells me the device is opened, closed (yeah, I know, I should
have coded the close instruction) but nothing between those two, did I
missed something, such as the fact that vivi doesn't respond to ioctl
?

regards

-- 
Guillaume

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
